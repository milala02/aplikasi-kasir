import 'package:drift/drift.dart' as d;

import '../../../core/database/app_database.dart';
import '../domain/sync_queue_entry.dart';
import '../domain/sync_queue_repository.dart';

class DriftSyncQueueRepository implements SyncQueueRepository {
  final AppDatabase db;

  DriftSyncQueueRepository(this.db);

  @override
  Future<void> save(SyncQueueEntry entry) async {
    await db.into(db.syncQueueTable).insert(
          SyncQueueTableCompanion.insert(
            id: entry.id,
            endpoint: entry.endpoint,
            sourceTable: d.Value(entry.sourceTable),
            referenceId: d.Value(entry.referenceId),
            payloadJson: entry.payloadJson,
            status: entry.status.name,
            retryCount: d.Value(entry.retryCount),
            createdAt: entry.createdAt,
            updatedAt: entry.updatedAt,
          ),
          mode: d.InsertMode.insertOrAbort,
        );
  }

  @override
  Future<List<SyncQueueEntry>> getPending() async {
    final rows = await (db.select(db.syncQueueTable)
          ..where((t) => t.status.equals(SyncQueueStatus.pending.name))
          ..orderBy([(t) => d.OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<SyncQueueEntry>> getAll() async {
    final rows = await (db.select(db.syncQueueTable)
          ..orderBy([(t) => d.OrderingTerm.asc(t.createdAt)]))
        .get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> update(SyncQueueEntry entry) async {
    await db.update(db.syncQueueTable).replace(
          SyncQueueTableData(
            id: entry.id,
            endpoint: entry.endpoint,
            sourceTable: entry.sourceTable,
            referenceId: entry.referenceId,
            payloadJson: entry.payloadJson,
            status: entry.status.name,
            retryCount: entry.retryCount,
            createdAt: entry.createdAt,
            updatedAt: entry.updatedAt,
          ),
        );
  }

  SyncQueueEntry _toDomain(SyncQueueTableData row) {
    return SyncQueueEntry(
      id: row.id,
      endpoint: row.endpoint,
      sourceTable: row.sourceTable,
      referenceId: row.referenceId ?? '',
      payloadJson: row.payloadJson,
      status: SyncQueueStatus.values.firstWhere(
        (s) => s.name == row.status,
        orElse: () =>
            throw StateError('Unknown sync queue status: ${row.status}'),
      ),
      retryCount: row.retryCount,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }
}
