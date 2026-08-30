import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aplikasi_kasir/features/sync/application/auto_sync_worker.dart';
import 'package:aplikasi_kasir/features/sync/application/sync_orchestrator.dart';
import 'package:aplikasi_kasir/features/sync/domain/master_data_pull.dart';
import 'package:aplikasi_kasir/features/sync/domain/auth_repository.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_api_client.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_queue_entry.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_state_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_master_data_pull_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_pull_state_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_sync_queue_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/local_auth_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/remote_auth_repository.dart';
import 'package:aplikasi_kasir/features/sync/presentation/sync_login_controller.dart';
import 'package:aplikasi_kasir/features/sync/presentation/sync_login_screen.dart';
import 'package:aplikasi_kasir/features/sync/presentation/sync_status_indicator.dart';

class _NoopApiClient implements SyncApiClient {
  @override
  Future<void> push(SyncQueueEntry entry, {String? authToken}) async {}

  @override
  Future<MasterDataPull> pull({DateTime? since, String? authToken}) async {
    return const MasterDataPull(products: [], categories: [], uoms: []);
  }
}

class _NoopStateRepository implements SyncStateRepository {
  @override
  Future<void> markSynced(
      SyncSourceTable table, String id, DateTime at) async {}
}

class _NoopAuthRepository implements AuthRepository {
  @override
  String? getToken() => null;

  @override
  Future<void> saveToken(String token) async {}

  @override
  Future<void> clearToken() async {}
}

void main() {
  group('SyncStatusIndicator & SyncNowButton', () {
    late StreamController<List<ConnectivityResult>> controller;
    late AutoSyncWorker worker;

    setUp(() {
      controller = StreamController<List<ConnectivityResult>>.broadcast();
      worker = AutoSyncWorker(
        orchestrator: SyncOrchestrator(
          queueRepository: InMemorySyncQueueRepository(),
          apiClient: _NoopApiClient(),
          syncStateRepository: _NoopStateRepository(),
          masterDataRepository: InMemoryMasterDataPullRepository(),
          pullStateRepository: InMemoryPullStateRepository(),
        ),
        queueRepository: InMemorySyncQueueRepository(),
        authRepository: _NoopAuthRepository(),
        connectivityStream: controller.stream,
      );
      worker.start();
    });

    tearDown(() async {
      worker.dispose();
      await controller.close();
    });

    testWidgets('ikon berubah OFFLINE -> SYNCED saat online',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [
              SyncStatusIndicator(worker: worker),
              SyncNowButton(worker: worker),
            ],
          ),
        ),
      ));
      await tester.pump();

      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
      expect(find.byIcon(Icons.sync), findsOneWidget);

      controller.add([ConnectivityResult.wifi]);
      // Jalankan event + rantai async worker di zona async nyata,
      // lalu pump untuk rebuild indikator.
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
      await tester.pump();

      expect(find.byIcon(Icons.cloud_done), findsOneWidget);
    });

    testWidgets('tidak online -> ikon offline dengan badge jumlah pending',
        (tester) async {
      final repo = InMemorySyncQueueRepository();
      await repo.save(SyncQueueEntry(
        id: 'sq_1',
        endpoint: '/api/v1/sync/push',
        sourceTable: 'order',
        referenceId: 'ord_1',
        payloadJson: '{"orders":[]}',
        status: SyncQueueStatus.pending,
        retryCount: 0,
        createdAt: DateTime(2026, 8, 20),
        updatedAt: DateTime(2026, 8,20),
      ));
      final pendingWorker = AutoSyncWorker(
        orchestrator: SyncOrchestrator(
          queueRepository: repo,
          apiClient: _NoopApiClient(),
          syncStateRepository: _NoopStateRepository(),
          masterDataRepository: InMemoryMasterDataPullRepository(),
          pullStateRepository: InMemoryPullStateRepository(),
        ),
        queueRepository: repo,
        authRepository: _NoopAuthRepository(),
        connectivityStream: controller.stream,
      );
      pendingWorker.start();

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            actions: [SyncStatusIndicator(worker: pendingWorker)],
          ),
        ),
      ));
      await tester.pump(const Duration(milliseconds: 20));

      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
      expect(find.text('1'), findsOneWidget);

      pendingWorker.dispose();
    });
  });

  group('SyncLoginScreen', () {
    testWidgets('login gagal -> error tampil dan layar tidak tertutup',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final local = LocalAuthRepository(await SharedPreferences.getInstance());
      final remote = RemoteAuthRepository(
        baseUri: Uri.parse('http://localhost:3000'),
        client: MockClient(
            (request) async => http.Response('unauthorized', 401)),
      );
      final loginController = SyncLoginController(
        remoteAuthRepository: remote,
        localAuthRepository: local,
      );

      await tester.pumpWidget(MaterialApp(
        home: SyncLoginScreen(controller: loginController),
      ));

      expect(find.text('Akun Sinkronisasi'), findsOneWidget);
      expect(find.text('Status: belum login.'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField).first, 'owner');
      await tester.enterText(find.byType(TextFormField).last, 'salah');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Login gagal'), findsOneWidget);
      expect(find.text('Status: belum login.'), findsOneWidget);
    });

    testWidgets('login sukses -> snackbar dan kembali ke layar sebelumnya',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final local = LocalAuthRepository(await SharedPreferences.getInstance());
      final remote = RemoteAuthRepository(
        baseUri: Uri.parse('http://localhost:3000'),
        client: MockClient((request) async {
          expect(request.body, contains('"username":"owner"'));
          return http.Response('{"token":"jwt-abc"}', 200);
        }),
      );
      final loginController = SyncLoginController(
        remoteAuthRepository: remote,
        localAuthRepository: local,
      );

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      SyncLoginScreen(controller: loginController),
                ),
              ),
              child: const Text('buka-login'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('buka-login'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, 'owner');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Login'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Kembali ke layar sebelumnya dan token tersimpan.
      expect(find.text('buka-login'), findsOneWidget);
      expect(local.getToken(), 'jwt-abc');

      // Tuntaskan timer snackbar agar tidak ada timer tersisa.
      await tester.pump(const Duration(seconds: 5));
    });
  });
}
