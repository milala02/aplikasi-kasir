import 'stock_ledger.dart';
import 'stock_movement.dart';

abstract interface class InventoryRepository {
  Future<StockLedger?> getLedger(String productId);

  Future<List<StockMovement>> getMovements(String productId);

  Future<void> saveLedger(StockLedger ledger);

  Future<void> recordMovement(StockMovement movement);
}
