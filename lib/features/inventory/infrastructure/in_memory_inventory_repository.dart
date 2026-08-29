import '../domain/inventory_repository.dart';
import '../domain/stock_ledger.dart';
import '../domain/stock_movement.dart';

class InMemoryInventoryRepository implements InventoryRepository {
  final Map<String, StockLedger> _ledgers = {};
  final List<StockMovement> _movements = [];

  @override
  Future<StockLedger?> getLedger(String productId) async {
    return _ledgers[productId];
  }

  @override
  Future<List<StockMovement>> getMovements(String productId) async {
    return List.unmodifiable(
      _movements.where(
        (movement) => movement.productId == productId,
      ),
    );
  }

  @override
  Future<void> saveLedger(StockLedger ledger) async {
    _ledgers[ledger.productId] = ledger;
  }

  @override
  Future<void> recordMovement(StockMovement movement) async {
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
