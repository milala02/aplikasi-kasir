import 'package:drift/drift.dart' as d;

import '../../../core/database/app_database.dart';
import '../../../core/quantity/quantity.dart';
import '../domain/inventory_repository.dart';
import '../domain/stock_ledger.dart';
import '../domain/stock_movement.dart';

class DriftInventoryRepository implements InventoryRepository {
  final AppDatabase db;

  DriftInventoryRepository(this.db);

  @override
  Future<StockLedger?> getLedger(String productId) async {
    final movements = await getMovements(productId);

    if (movements.isEmpty) {
      return null;
    }

    return StockLedger(
      productId: productId,
      movements: movements,
    );
  }

  @override
  Future<List<StockMovement>> getMovements(String productId) async {
    final rows = await (db.select(db.stockMovementsTable)
          ..where((tbl) => tbl.productId.equals(productId))
          ..orderBy([
            (tbl) => d.OrderingTerm.asc(tbl.occurredAt),
          ]))
        .get();

    return rows.map((row) {
      return StockMovement(
        id: row.id,
        productId: row.productId,
        quantity: Quantity(
          value: row.quantityValue,
          scale: row.quantityScale,
        ),
        type: StockMovementType.values.firstWhere(
          (type) => type.name == row.type,
          orElse: () => throw StateError(
            'Unknown stock movement type: ${row.type}',
          ),
        ),
        referenceId: row.referenceId,
        occurredAt: row.occurredAt,
      );
    }).toList();
  }

  @override
  Future<void> saveLedger(StockLedger ledger) async {
    // Ledger merupakan derived state dari stock movements.
    // Tidak disimpan sebagai data terpisah.
  }

  @override
  Future<void> recordMovement(StockMovement movement) async {
    await db.into(db.stockMovementsTable).insert(
      StockMovementsTableCompanion.insert(
        id: movement.id,
        productId: movement.productId,
        quantityValue: movement.quantity.value,
        quantityScale: d.Value(movement.quantity.scale),
        type: movement.type.name,
        referenceId: d.Value(movement.referenceId),
        occurredAt: movement.occurredAt,
      ),
      mode: d.InsertMode.insertOrAbort,
    );
  }
}
