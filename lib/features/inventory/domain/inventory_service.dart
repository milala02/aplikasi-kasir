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
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.purchase,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService sellStock({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.sale,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService adjustStockIncrease({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.adjustmentIncrease,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService adjustStockDecrease({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.adjustmentDecrease,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService recordDamage({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.damage,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService returnStockIn({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.returnIn,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService returnStockOut({
    required String movementId,
    required Quantity quantity,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    return _recordMovement(
      movementId: movementId,
      quantity: quantity,
      type: StockMovementType.returnOut,
      occurredAt: occurredAt,
      referenceId: referenceId,
    );
  }

  InventoryService _recordMovement({
    required String movementId,
    required Quantity quantity,
    required StockMovementType type,
    required DateTime occurredAt,
    String? referenceId,
  }) {
    final movement = StockMovement(
      id: movementId,
      productId: ledger.productId,
      quantity: quantity,
      type: type,
      referenceId: referenceId,
      occurredAt: occurredAt,
    );

    return InventoryService(
      ledger: ledger.addMovement(movement),
    );
  }
}
