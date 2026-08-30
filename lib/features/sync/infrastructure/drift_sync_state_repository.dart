import 'package:drift/drift.dart' as d;

import '../../../core/database/app_database.dart';
import '../domain/sync_state_repository.dart';

class DriftSyncStateRepository implements SyncStateRepository {
  final AppDatabase db;

  DriftSyncStateRepository(this.db);

  @override
  Future<void> markSynced(
    SyncSourceTable table,
    String id,
    DateTime at,
  ) async {
    switch (table) {
      case SyncSourceTable.product:
        final row = await (db.select(db.productsTable)
              ..where((t) => t.id.equals(id)))
            .getSingle();
        await db.update(db.productsTable).replace(
            row.copyWith(isSynced: true, syncedAt: d.Value(at)));
      case SyncSourceTable.customer:
        final row = await (db.select(db.customersTable)
              ..where((t) => t.id.equals(id)))
            .getSingle();
        await db.update(db.customersTable).replace(
            row.copyWith(isSynced: true, syncedAt: d.Value(at)));
      case SyncSourceTable.sale:
        final row = await (db.select(db.salesTable)
              ..where((t) => t.id.equals(id)))
            .getSingle();
        await db.update(db.salesTable).replace(
            row.copyWith(isSynced: true, syncedAt: d.Value(at)));
      case SyncSourceTable.order:
        final row = await (db.select(db.ordersTable)
              ..where((t) => t.id.equals(id)))
            .getSingle();
        await db.update(db.ordersTable).replace(
            row.copyWith(isSynced: true, syncedAt: d.Value(at)));
      case SyncSourceTable.purchase:
        final row = await (db.select(db.purchasesTable)
              ..where((t) => t.id.equals(id)))
            .getSingle();
        await db.update(db.purchasesTable).replace(
            row.copyWith(isSynced: true, syncedAt: d.Value(at)));
      case SyncSourceTable.receiving:
        final row = await (db.select(db.receivingsTable)
              ..where((t) => t.id.equals(id)))
            .getSingle();
        await db.update(db.receivingsTable).replace(
            row.copyWith(isSynced: true, syncedAt: d.Value(at)));
    }
  }
}
