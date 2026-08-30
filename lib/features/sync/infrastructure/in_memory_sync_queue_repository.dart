import '../domain/sync_queue_entry.dart';
import '../domain/sync_queue_repository.dart';

class InMemorySyncQueueRepository implements SyncQueueRepository {
  final Map<String, SyncQueueEntry> _entries = {};

  @override
  Future<void> save(SyncQueueEntry entry) async {
    if (_entries.containsKey(entry.id)) {
      throw ArgumentError('Sync queue entry ID already exists.');
    }
    _entries[entry.id] = entry;
  }

  @override
  Future<List<SyncQueueEntry>> getPending() async {
    return List.unmodifiable(
      _entries.values.where((e) => e.status == SyncQueueStatus.pending),
    );
  }

  @override
  Future<List<SyncQueueEntry>> getAll() async {
    return List.unmodifiable(_entries.values);
  }

  @override
  Future<void> update(SyncQueueEntry entry) async {
    if (!_entries.containsKey(entry.id)) {
      throw ArgumentError('Sync queue entry not found.');
    }
    _entries[entry.id] = entry;
  }
}
