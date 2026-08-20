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
  StockLedger? getLedger(String productId) {
    final movements = getMovements(productId);
    if (movements.isEmpty) return null;
    return StockLedger(productId: productId, movements: movements);
  }

  @override
  List<StockMovement> getMovements(String productId) {
    return [];
  }

  @override
  void saveLedger(StockLedger ledger) {}

  @override
  void recordMovement(StockMovement movement) {
    db.into(db.stockMovementsTable).insert(
      StockMovementsTableCompanion.insert(
        id: movement.id,
        productId: movement.productId,
        quantityValue: movement.quantity.value.toInt(), // Menggunakan .value
        type: movement.type.toString(),
        referenceId: d.Value(movement.referenceId),
        occurredAt: movement.occurredAt,
      ),
    );
  }
}
