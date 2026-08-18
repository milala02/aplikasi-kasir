import '../domain/inventory_repository.dart';
import '../domain/stock_ledger.dart';
import '../domain/stock_movement.dart';

class InMemoryInventoryRepository implements InventoryRepository {
  final Map<String, StockLedger> _ledgers = {};
  final List<StockMovement> _movements = [];

  @override
  StockLedger? getLedger(String productId) {
    return _ledgers[productId];
  }

  @override
  List<StockMovement> getMovements(String productId) {
    return List.unmodifiable(
      _movements.where(
        (movement) => movement.productId == productId,
      ),
    );
  }

  @override
  void saveLedger(StockLedger ledger) {
    _ledgers[ledger.productId] = ledger;
  }

  @override
  void recordMovement(StockMovement movement) {
    final alreadyRecorded = _movements.any(
      (existing) => existing.id == movement.id,
    );

    if (alreadyRecorded) {
      throw ArgumentError(
        'Stock movement ID already exists.',
      );
    }

    _movements.add(movement);
  }
}
