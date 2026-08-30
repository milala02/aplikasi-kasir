import 'sync_queue_entry.dart';

abstract interface class SyncQueueRepository {
  Future<void> save(SyncQueueEntry entry);

  Future<List<SyncQueueEntry>> getPending();

  Future<List<SyncQueueEntry>> getAll();

  Future<void> update(SyncQueueEntry entry);
}
