import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_kasir/features/sync/application/auto_sync_worker.dart';
import 'package:aplikasi_kasir/features/sync/application/sync_orchestrator.dart';
import 'package:aplikasi_kasir/features/sync/domain/auth_repository.dart';
import 'package:aplikasi_kasir/features/sync/domain/master_data_pull.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_api_client.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_queue_entry.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_state_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_master_data_pull_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_pull_state_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_sync_queue_repository.dart';

class _CountingSyncApiClient implements SyncApiClient {
  int pushCount = 0;
  final Duration delay;

  _CountingSyncApiClient({this.delay = Duration.zero});

  @override
  Future<void> push(SyncQueueEntry entry, {String? authToken}) async {
    pushCount++;
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
  }

  @override
  Future<MasterDataPull> pull({DateTime? since, String? authToken}) async {
    return const MasterDataPull(products: [], categories: [], uoms: []);
  }
}

class _FakeSyncStateRepository implements SyncStateRepository {
  @override
  Future<void> markSynced(
      SyncSourceTable table, String id, DateTime at) async {}
}

/// Orchestrator pembungkus yang menghitung jumlah pemanggilan sync —
/// transisi offline->online harus memicu sync walau antrian kosong.
class _CountingSyncOrchestrator extends SyncOrchestrator {
  int syncCount = 0;

  _CountingSyncOrchestrator({
    required super.queueRepository,
    required super.apiClient,
    required super.syncStateRepository,
    required super.masterDataRepository,
    required super.pullStateRepository,
  });

  @override
  Future<SyncResult> sync({String? authToken}) async {
    syncCount++;
    return super.sync(authToken: authToken);
  }
}

class _FakeAuthRepository implements AuthRepository {
  @override
  String? getToken() => 'jwt-test';

  @override
  Future<void> saveToken(String token) async {}

  @override
  Future<void> clearToken() async {}
}

void main() {
  group('AutoSyncWorker', () {
    late StreamController<List<ConnectivityResult>> controller;
    late InMemorySyncQueueRepository queueRepo;
    late _CountingSyncApiClient apiClient;
    late _CountingSyncOrchestrator orchestrator;

    setUp(() {
      controller = StreamController<List<ConnectivityResult>>.broadcast();
      queueRepo = InMemorySyncQueueRepository();
    });

    tearDown(() async {
      await controller.close();
    });

    AutoSyncWorker buildWorker({Duration apiDelay = Duration.zero}) {
      apiClient = _CountingSyncApiClient(delay: apiDelay);
      orchestrator = _CountingSyncOrchestrator(
        queueRepository: queueRepo,
        apiClient: apiClient,
        syncStateRepository: _FakeSyncStateRepository(),
        masterDataRepository: InMemoryMasterDataPullRepository(),
        pullStateRepository: InMemoryPullStateRepository(),
      );
      return AutoSyncWorker(
        orchestrator: orchestrator,
        queueRepository: queueRepo,
        authRepository: _FakeAuthRepository(),
        connectivityStream: controller.stream,
      );
    }

    SyncQueueEntry buildEntry() {
      final now = DateTime(2026, 8, 20);
      return SyncQueueEntry(
        id: 'sq_001',
        endpoint: '/api/v1/sync/push',
        sourceTable: 'order',
        referenceId: 'ord_1',
        payloadJson: '{"orders":[]}',
        status: SyncQueueStatus.pending,
        retryCount: 0,
        createdAt: now,
        updatedAt: now,
      );
    }

    // Beri waktu event stream + async listener selesai.
    Future<void> settle([Duration duration = const Duration(milliseconds: 20)]) =>
        Future<void>.delayed(duration);

    test('offline -> online: trigger sync dan antrian terkuras', () async {
      final worker = buildWorker();
      await queueRepo.save(buildEntry());
      worker.start();

      controller.add([ConnectivityResult.none]);
      await settle();
      expect(apiClient.pushCount, 0);

      controller.add([ConnectivityResult.wifi]);
      await settle();

      expect(apiClient.pushCount, 1);
      expect(await queueRepo.getPending(), isEmpty);

      worker.dispose();
    });

    test('online -> online: TIDAK memicu sync ulang', () async {
      final worker = buildWorker();
      await queueRepo.save(buildEntry());
      worker.start();

      controller.add([ConnectivityResult.wifi]);
      await settle();
      controller.add([ConnectivityResult.mobile]);
      await settle();

      expect(apiClient.pushCount, 1);

      worker.dispose();
    });

    test('sync di setiap transisi offline -> online', () async {
      final worker = buildWorker();
      worker.start();

      controller.add([ConnectivityResult.none]);
      await settle();
      controller.add([ConnectivityResult.wifi]);
      await settle();
      controller.add([ConnectivityResult.none]);
      await settle();
      controller.add([ConnectivityResult.ethernet]);
      await settle();

      // Dua transisi offline->online = dua kali sync (antrian kosong,
      // push tidak terjadi tetapi sync tetap dipicu).
      expect(orchestrator.syncCount, 2);
      expect(apiClient.pushCount, 0);

      await queueRepo.save(buildEntry());
      controller.add([ConnectivityResult.none]);
      await settle();
      controller.add([ConnectivityResult.wifi]);
      await settle();

      expect(orchestrator.syncCount, 3);
      expect(apiClient.pushCount, 1);
      expect(await queueRepo.getPending(), isEmpty);

      worker.dispose();
    });

    test('sync in-flight tidak ditumpuk oleh transisi online berikutnya',
        () async {
      final worker = buildWorker(apiDelay: const Duration(milliseconds: 100));
      await queueRepo.save(buildEntry());
      worker.start();

      controller.add([ConnectivityResult.wifi]);
      // Offline lalu online lagi saat sync pertama masih berjalan:
      // _syncing=true menahan sync kedua.
      controller.add([ConnectivityResult.none]);
      controller.add([ConnectivityResult.wifi]);
      await settle(const Duration(milliseconds: 150));

      expect(orchestrator.syncCount, 1);
      expect(apiClient.pushCount, 1);
      expect(await queueRepo.getPending(), isEmpty);

      worker.dispose();
    });

    test('status: OFFLINE -> SYNCING -> SYNCED selama siklus online',
        () async {
      final worker = buildWorker();
      await queueRepo.save(buildEntry());
      worker.start();
      await settle();

      expect(worker.status, SyncUiStatus.offline);
      expect(worker.pendingCount, 1);

      // Transisi online: status berubah dan entri terpush.
      final syncingSeen = <bool>[];
      worker.addListener(() => syncingSeen.add(worker.isSyncing));
      controller.add([ConnectivityResult.wifi]);
      await settle();

      expect(orchestrator.syncCount, 1);
      expect(worker.status, SyncUiStatus.synced);
      expect(worker.pendingCount, 0);
      expect(worker.lastSyncAt, isNotNull);
      expect(syncingSeen, contains(true));

      worker.dispose();
    });

    test('status: push gagal -> PENDING dengan entri gagal terhitung',
        () async {
      // ApiClient selalu gagal: entri menjadi FAILED (bukan pending),
      // tetapi tetap dihitung sebagai belum terpush.
      final failingApi = _FailingSyncApiClient();
      final failingOrchestrator = _CountingSyncOrchestrator(
        queueRepository: queueRepo,
        apiClient: failingApi,
        syncStateRepository: _FakeSyncStateRepository(),
        masterDataRepository: InMemoryMasterDataPullRepository(),
        pullStateRepository: InMemoryPullStateRepository(),
      );
      final failingWorker = AutoSyncWorker(
        orchestrator: failingOrchestrator,
        queueRepository: queueRepo,
        authRepository: _FakeAuthRepository(),
        connectivityStream: controller.stream,
      );
      await queueRepo.save(buildEntry());
      failingWorker.start();
      await settle();

      controller.add([ConnectivityResult.wifi]);
      await settle();

      expect(failingWorker.status, SyncUiStatus.pending);
      expect(failingWorker.pendingCount, 1);

      failingWorker.dispose();
    });

    test('syncNow: sinkronisasi manual memproses antrian', () async {
      final worker = buildWorker();
      await queueRepo.save(buildEntry());
      worker.start();
      await settle();

      await worker.syncNow();

      expect(orchestrator.syncCount, 1);
      expect(apiClient.pushCount, 1);
      expect(worker.pendingCount, 0);
      expect(await queueRepo.getPending(), isEmpty);

      worker.dispose();
    });
  });
}

class _FailingSyncApiClient implements SyncApiClient {
  @override
  Future<void> push(SyncQueueEntry entry, {String? authToken}) async {
    throw Exception('Network error');
  }

  @override
  Future<MasterDataPull> pull({DateTime? since, String? authToken}) async {
    throw Exception('Network error');
  }
}
