import 'stock_ledger.dart';
import 'stock_movement.dart';

abstract interface class InventoryRepository {
  StockLedger? getLedger(String productId);

  List<StockMovement> getMovements(String productId);

  void saveLedger(StockLedger ledger);

  void recordMovement(StockMovement movement);
}
