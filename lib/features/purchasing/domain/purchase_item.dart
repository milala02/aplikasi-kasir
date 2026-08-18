import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';

class PurchaseItem {
  final String id;
  final String productId;
  final Quantity quantity;
  final Money unitCost;

  PurchaseItem({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.unitCost,
  })  : assert(id != ''),
        assert(productId != ''),
        assert(quantity.value > 0),
        assert(unitCost.minorUnits >= 0);

  Money get totalCost {
    final scaleFactor = _scaleFactor(quantity.scale);
    final totalMinorUnits =
        (unitCost.minorUnits * quantity.value) ~/ scaleFactor;

    return Money(
      minorUnits: totalMinorUnits,
      currency: unitCost.currency,
    );
  }

  static int _scaleFactor(int scale) {
    var result = 1;

    for (var i = 0; i < scale; i++) {
      result *= 10;
    }

    return result;
  }
}
