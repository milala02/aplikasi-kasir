import '../../../core/quantity/quantity.dart';
import 'stock_movement.dart';

class StockLedger {
  final String productId;
  final List<StockMovement> movements;

  const StockLedger({
    required this.productId,
    this.movements = const [],
  });

  Quantity calculateBalance() {
    if (movements.isEmpty) {
      return Quantity.zero();
    }

    var balance = Quantity.zero(
      scale: movements.first.quantity.scale,
    );

    for (final movement in movements) {
      if (movement.productId != productId) {
        throw ArgumentError(
          'Stock movement product does not match ledger product.',
        );
      }

      if (movement.isIncrease) {
        balance = balance.add(movement.quantity);
      } else {
        balance = balance.subtract(movement.quantity);
      }
    }

    return balance;
  }

  StockLedger addMovement(StockMovement movement) {
    if (productId.isEmpty) {
      throw ArgumentError(
        'Stock ledger product ID cannot be empty.',
      );
    }

    if (movement.productId != productId) {
      throw ArgumentError(
        'Stock movement product does not match ledger product.',
      );
    }

    if (movement.quantity.isZero) {
      throw ArgumentError(
        'Stock movement quantity cannot be zero.',
      );
    }

    if (movements.any((existing) => existing.id == movement.id)) {
      throw ArgumentError(
        'Stock movement ID already exists.',
      );
    }

    if (!movement.isIncrease) {
      final currentBalance = calculateBalance();
      currentBalance.subtract(movement.quantity);
    }

    return StockLedger(
      productId: productId,
      movements: [
        ...movements,
        movement,
      ],
    );
  }
}
