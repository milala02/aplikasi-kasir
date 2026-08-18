import '../../../core/quantity/quantity.dart';

enum StockMovementType {
  purchase,
  sale,
  adjustmentIncrease,
  adjustmentDecrease,
  damage,
  returnIn,
  returnOut,
}

class StockMovement {
  final String id;
  final String productId;
  final Quantity quantity;
  final StockMovementType type;
  final String? referenceId;
  final DateTime occurredAt;

  StockMovement({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.type,
    required this.occurredAt,
    this.referenceId,
  }) {
    if (id.isEmpty) {
      throw ArgumentError(
        'Stock movement ID cannot be empty.',
      );
    }

    if (productId.isEmpty) {
      throw ArgumentError(
        'Stock movement product ID cannot be empty.',
      );
    }

    if (quantity.isZero) {
      throw ArgumentError(
        'Stock movement quantity cannot be zero.',
      );
    }
  }

  bool get isIncrease {
    switch (type) {
      case StockMovementType.purchase:
      case StockMovementType.adjustmentIncrease:
      case StockMovementType.returnIn:
        return true;

      case StockMovementType.sale:
      case StockMovementType.adjustmentDecrease:
      case StockMovementType.damage:
      case StockMovementType.returnOut:
        return false;
    }
  }

  @override
  bool operator ==(Object other) {
    return other is StockMovement &&
        other.id == id &&
        other.productId == productId &&
        other.quantity == quantity &&
        other.type == type &&
        other.referenceId == referenceId &&
        other.occurredAt == occurredAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      productId,
      quantity,
      type,
      referenceId,
      occurredAt,
    );
  }
}
