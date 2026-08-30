import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/features/sync/application/sync_orchestrator.dart';
import 'package:aplikasi_kasir/features/sync/domain/master_data_pull.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_api_client.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_queue_entry.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_state_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_master_data_pull_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_pull_state_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_sync_queue_repository.dart';

class _FakeSyncApiClient implements SyncApiClient {
  final Set<String> failIds;
  DateTime? pullSince;
  final MasterDataPull pullPayload;

  _FakeSyncApiClient({this.failIds = const {}, MasterDataPull? pullPayload})
      : pullPayload = pullPayload ??
            const MasterDataPull(products: [], categories: [], uoms: []);

  @override
  Future<void> push(SyncQueueEntry entry, {String? authToken}) async {
    if (failIds.contains(entry.id)) {
      throw Exception('Network error');
    }
  }

  @override
  Future<MasterDataPull> pull({DateTime? since, String? authToken}) async {
    pullSince = since;
    return pullPayload;
  }
}

class _FakeSyncStateRepository implements SyncStateRepository {
  final List<(SyncSourceTable, String, DateTime)> marked = [];

  @override
  Future<void> markSynced(
      SyncSourceTable table, String id, DateTime at) async {
    marked.add((table, id, at));
  }
}

void main() {
  group('SyncOrchestrator', () {
    late InMemorySyncQueueRepository queueRepo;
    late _FakeSyncStateRepository stateRepo;

    setUp(() {
      queueRepo = InMemorySyncQueueRepository();
      stateRepo = _FakeSyncStateRepository();
    });

    SyncOrchestrator buildOrchestrator(
      _FakeSyncApiClient apiClient, {
      InMemoryMasterDataPullRepository? masterDataRepo,
      InMemoryPullStateRepository? pullStateRepo,
    }) {
      return SyncOrchestrator(
        queueRepository: queueRepo,
        apiClient: apiClient,
        syncStateRepository: stateRepo,
        masterDataRepository:
            masterDataRepo ?? InMemoryMasterDataPullRepository(),
        pullStateRepository: pullStateRepo ?? InMemoryPullStateRepository(),
      );
    }

    SyncQueueEntry buildEntry({String id = 'sq_001', String referenceId = ''}) {
      final now = DateTime(2026, 8, 20);
      return SyncQueueEntry(
        id: id,
        endpoint: 'orders/push',
        sourceTable: 'order', // = SyncSourceTable.order.name
        referenceId: referenceId,
        payloadJson: '{"id":"ord_$id"}',
        status: SyncQueueStatus.pending,
        retryCount: 0,
        createdAt: now,
        updatedAt: now,
      );
    }

    test('sukses: status SYNCED + CDC markSynced dengan tabel & id benar',
        () async {
      final orchestrator = buildOrchestrator(_FakeSyncApiClient());
      await queueRepo.save(buildEntry());

      final result = await orchestrator.sync(authToken: 'jwt-123');

      expect(result.synced, 1);
      expect(result.failed, 0);
      expect(await queueRepo.getPending(), isEmpty);

      final synced = (await queueRepo.getAll()).single;
      expect(synced.status, SyncQueueStatus.synced);

      expect(stateRepo.marked, hasLength(1));
      expect(stateRepo.marked.single.$1, SyncSourceTable.order);
      expect(stateRepo.marked.single.$2, 'ord_sq_001');
    });

    test('entri dengan referenceId (v14): CDC memakai id lokal, bukan '
        'id payload', () async {
      final orchestrator = buildOrchestrator(_FakeSyncApiClient());
      // Payload baru (orders wrapper) tidak memuat id lokal di level atas;
      // CDC harus memakai referenceId.
      await queueRepo.save(buildEntry(referenceId: 'ord_123'));

      final result = await orchestrator.sync(authToken: 'jwt-123');

      expect(result.synced, 1);
      expect(stateRepo.marked.single.$1, SyncSourceTable.order);
      expect(stateRepo.marked.single.$2, 'ord_123');
    });

    test('gagal: status FAILED + retry bertambah, CDC TIDAK ditandai',
        () async {
      final orchestrator =
          buildOrchestrator(_FakeSyncApiClient(failIds: {'sq_001'}));
      await queueRepo.save(buildEntry());

      final result = await orchestrator.sync();

      expect(result.synced, 0);
      expect(result.failed, 1);

      final failed = (await queueRepo.getAll()).single;
      expect(failed.status, SyncQueueStatus.failed);
      expect(failed.retryCount, 1);
      expect(stateRepo.marked, isEmpty);
    });

    test('campuran sukses & gagal: hasil terpisah tanpa partial CDC',
        () async {
      final orchestrator =
          buildOrchestrator(_FakeSyncApiClient(failIds: {'sq_002'}));
      await queueRepo.save(buildEntry(id: 'sq_001'));
      await queueRepo.save(buildEntry(id: 'sq_002'));

      final result = await orchestrator.sync();

      expect(result.synced, 1);
      expect(result.failed, 1);

      final all = await queueRepo.getAll();
      expect(
        all.firstWhere((e) => e.id == 'sq_001').status,
        SyncQueueStatus.synced,
      );
      expect(
        all.firstWhere((e) => e.id == 'sq_002').status,
        SyncQueueStatus.failed,
      );
      expect(
        all.firstWhere((e) => e.id == 'sq_002').retryCount,
        1,
      );
      expect(stateRepo.marked, hasLength(1));
    });
  });

  group('SyncOrchestrator.pullMasterData', () {
    late InMemorySyncQueueRepository queueRepo;
    late _FakeSyncStateRepository stateRepo;
    late InMemoryPullStateRepository pullStateRepo;
    late InMemoryMasterDataPullRepository masterDataRepo;

    setUp(() {
      queueRepo = InMemorySyncQueueRepository();
      stateRepo = _FakeSyncStateRepository();
      pullStateRepo = InMemoryPullStateRepository();
      masterDataRepo = InMemoryMasterDataPullRepository();
    });

    SyncOrchestrator buildOrchestrator(_FakeSyncApiClient apiClient) {
      return SyncOrchestrator(
        queueRepository: queueRepo,
        apiClient: apiClient,
        syncStateRepository: stateRepo,
        masterDataRepository: masterDataRepo,
        pullStateRepository: pullStateRepo,
      );
    }

    MasterDataPull buildPayload() {
      final t = DateTime.utc(2026, 8, 20);
      return MasterDataPull(
        products: [
          PulledProduct(
            id: '550e8400-e29b-41d4-a716-446655440000',
            sku: 'BM-001',
            name: 'Bawang Merah',
            stockUomId: '1bb4f570-213a-57d4-af43-52aacdb83f94',
            categoryId: null,
            isActive: true,
            createdAt: t,
            updatedAt: t,
          ),
        ],
        categories: [
          PulledCategory(
            id: '9c0e1234-e29b-41d4-a716-446655440001',
            name: 'Bumbu Dapur',
            isActive: true,
            createdAt: t,
            updatedAt: t,
          ),
        ],
        uoms: [
          PulledUom(
            id: '1bb4f570-213a-57d4-af43-52aacdb83f94',
            name: 'kilogram',
            symbol: 'kg',
            isActive: true,
            createdAt: t,
            updatedAt: t,
          ),
        ],
      );
    }

    test('pull inkremental: since dari state, upsert, kursor disimpan',
        () async {
      pullStateRepo.lastPullAt = DateTime(2026, 8, 1, 0, 0, 0);
      final apiClient = _FakeSyncApiClient(pullPayload: buildPayload());
      final orchestrator = buildOrchestrator(apiClient);

      final result = await orchestrator.pullMasterData(authToken: 'jwt-1');

      expect(apiClient.pullSince, DateTime(2026, 8, 1, 0, 0, 0));
      expect(masterDataRepo.lastUpsert, isNotNull);
      expect(result.since, DateTime(2026, 8, 1, 0, 0, 0));
      expect(result.productsUpserted, 1);
      expect(result.categoriesUpserted, 1);
      expect(result.uomsUpserted, 1);
      expect(result.productsSkipped, 0);
      expect(pullStateRepo.lastPullAt, isNotNull);
    });

    test('pull pertama (tanpa since): tarik semua', () async {
      final apiClient = _FakeSyncApiClient();
      final orchestrator = buildOrchestrator(apiClient);

      final result = await orchestrator.pullMasterData();

      expect(apiClient.pullSince, isNull);
      expect(result.since, isNull);
    });

    test('pull gagal (api error): exception propagate, kursor TIDAK maju',
        () async {
      final throwingOrchestrator = SyncOrchestrator(
        queueRepository: queueRepo,
        apiClient: _ThrowingPullApiClient(),
        syncStateRepository: stateRepo,
        masterDataRepository: masterDataRepo,
        pullStateRepository: pullStateRepo,
      );

      await expectLater(
        throwingOrchestrator.pullMasterData(),
        throwsA(isA<Exception>()),
      );
      expect(pullStateRepo.lastPullAt, isNull);
    });
  });
}

class _ThrowingPullApiClient extends _FakeSyncApiClient {
  @override
  Future<MasterDataPull> pull({DateTime? since, String? authToken}) async {
    throw Exception('Network error');
  }
}
