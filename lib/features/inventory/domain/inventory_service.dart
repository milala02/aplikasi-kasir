import '../../../core/quantity/quantity.dart';
import 'stock_ledger.dart';
import 'stock_movement.dart';

class InventoryService {
  final StockLedger ledger;

  const InventoryService({
    required this.ledger,
  });

  Quantity get balance => ledger.calculateBalance();

  InventoryService receiveStock({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final movement = StockMovement(
      id: movementId,
      productId: ledger.productId,
      quantity: quantity,
      type: StockMovementType.purchase,
      referenceId: referenceId,
      occurredAt: occurredAt,
    );

    return InventoryService(
      ledger: ledger.addMovement(movement),
    );
  }

  InventoryService sellStock({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final movement = StockMovement(
      id: movementId,
      productId: ledger.productId,
      quantity: quantity,
      type: StockMovementType.sale,
      referenceId: referenceId,
      occurredAt: occurredAt,
    );

    return InventoryService(
      ledger: ledger.addMovement(movement),
    );
  }
}
