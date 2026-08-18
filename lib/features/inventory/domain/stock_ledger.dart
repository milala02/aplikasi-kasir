import '../../../core/quantity/quantity.dart';
import 'stock_movement.dart';

class StockLedger {
  final List<StockMovement> movements;

  const StockLedger({
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
      if (movement.isIncrease) {
        balance = balance.add(movement.quantity);
      } else {
        balance = balance.subtract(movement.quantity);
      }
    }

    return balance;
  }

  StockLedger addMovement(StockMovement movement) {
    if (movement.quantity.isZero) {
      throw ArgumentError(
        'Stock movement quantity cannot be zero.',
      );
    }

    // Quantity.subtract() automatically prevents
    // the stock balance from becoming negative.
    if (!movement.isIncrease) {
      final currentBalance = calculateBalance();

      currentBalance.subtract(movement.quantity);
    }

    return StockLedger(
      movements: [
        ...movements,
        movement,
      ],
    );
  }
}
