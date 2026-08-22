import 'package:drift/drift.dart' as d;
import '../../../core/database/app_database.dart';
import '../domain/inventory_repository.dart';
import '../domain/stock_ledger.dart';
import '../domain/stock_movement.dart';

class DriftInventoryRepository implements InventoryRepository {
  final AppDatabase db;
  final Map<String, StockLedger> _ledgers = {};
  final List<StockMovement> _movements = [];

  DriftInventoryRepository(this.db);

  @override
  StockLedger? getLedger(String productId) => _ledgers[productId];

  @override
  List<StockMovement> getMovements(String productId) {
    return List.unmodifiable(
      _movements.where((m) => m.productId == productId),
    );
  }

  @override
  void saveLedger(StockLedger ledger) {
    _ledgers[ledger.productId] = ledger;
  }

  @override
  void recordMovement(StockMovement movement) {
    final alreadyRecorded = _movements.any((e) => e.id == movement.id);
    if (alreadyRecorded) {
      throw ArgumentError('Stock movement ID already exists.');
    }
    _movements.add(movement);
    db.into(db.stockMovementsTable).insertOnConflictUpdate(
      StockMovementsTableCompanion.insert(
        id: movement.id,
        productId: movement.productId,
        quantityValue: movement.quantity.value.toInt(),
        type: movement.type.toString(),
        referenceId: d.Value(movement.referenceId),
        occurredAt: movement.occurredAt,
      ),
    );
  }
}
