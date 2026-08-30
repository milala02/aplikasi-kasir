import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_queue_entry.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/in_memory_sync_queue_repository.dart';

void main() {
  group('InMemorySyncQueueRepository', () {
    SyncQueueEntry buildEntry({
      String id = 'sq_001',
      SyncQueueStatus status = SyncQueueStatus.pending,
      int retryCount = 0,
    }) {
      final now = DateTime(2026, 8, 20);
      return SyncQueueEntry(
        id: id,
        endpoint: 'orders/push',
        sourceTable: 'orders',
        payloadJson: '{"id":"sale_1"}',
        status: status,
        retryCount: retryCount,
        createdAt: now,
        updatedAt: now,
      );
    }

    test('enqueue, fetch pending, mark synced/failed', () async {
      final repository = InMemorySyncQueueRepository();

      await repository.save(buildEntry());
      await repository.save(buildEntry(id: 'sq_002'));

      expect(await repository.getAll(), hasLength(2));
      expect((await repository.getPending()).map((e) => e.id),
          ['sq_001', 'sq_002']);

      await repository.update(
        buildEntry(id: 'sq_001', status: SyncQueueStatus.synced),
      );
      expect((await repository.getPending()).map((e) => e.id), ['sq_002']);

      await repository.update(
        buildEntry(
            id: 'sq_002',
            status: SyncQueueStatus.failed,
            retryCount: 3),
      );
      expect(await repository.getPending(), isEmpty);
      expect(
        (await repository.getAll())
            .firstWhere((e) => e.id == 'sq_002')
            .retryCount,
        3,
      );
    });

    test('id duplikat ditolak', () async {
      final repository = InMemorySyncQueueRepository();
      await repository.save(buildEntry());

      await expectLater(
        repository.save(buildEntry()),
        throwsArgumentError,
      );
    });
  });
}
