import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';

class CostLayer {
  final String id;
  final String productId;
  final Quantity originalQuantity;
  final Quantity remainingQuantity;
  final Money unitCost;
  final DateTime acquiredAt;
  final String? purchaseId;

  const CostLayer({
    required this.id,
    required this.productId,
    required this.originalQuantity,
    required this.remainingQuantity,
    required this.unitCost,
    required this.acquiredAt,
    this.purchaseId,
  }) : assert(id != ''),
       assert(productId != ''),
       assert(originalQuantity.value > 0),
       assert(remainingQuantity.value >= 0),
       assert(_isRemainingWithinOriginal(
         originalQuantity,
         remainingQuantity,
       ));

  static bool _isRemainingWithinOriginal(
    Quantity original,
    Quantity remaining,
  ) {
    final commonScale =
        original.scale > remaining.scale
            ? original.scale
            : remaining.scale;

    final originalValue = _scaleQuantity(
      original,
      commonScale,
    );

    final remainingValue = _scaleQuantity(
      remaining,
      commonScale,
    );

    return remainingValue <= originalValue;
  }

  bool get isDepleted => remainingQuantity.isZero;

  bool get isAvailable => remainingQuantity.isPositive;

  bool get hasValidRemainingQuantity {
    final commonScale = originalQuantity.scale > remainingQuantity.scale
        ? originalQuantity.scale
        : remainingQuantity.scale;

    final original = _scaleQuantity(
      originalQuantity,
      commonScale,
    );

    final remaining = _scaleQuantity(
      remainingQuantity,
      commonScale,
    );

    return remaining <= original;
  }

  Money get originalTotalCost => Money(
        minorUnits: unitCost.minorUnits *
            originalQuantity.value ~/
            _scaleFactor(originalQuantity.scale),
        currency: unitCost.currency,
      );

  Money get remainingValue => Money(
        minorUnits: unitCost.minorUnits *
            remainingQuantity.value ~/
            _scaleFactor(remainingQuantity.scale),
        currency: unitCost.currency,
      );

  CostLayer consume(Quantity quantity) {
    if (!hasValidRemainingQuantity) {
      throw StateError(
        'Cost layer remaining quantity cannot exceed original quantity.',
      );
    }

    if (quantity.isZero) {
      throw ArgumentError('Consumed quantity must be positive.');
    }

    final commonScale = remainingQuantity.scale > quantity.scale
        ? remainingQuantity.scale
        : quantity.scale;

    final available = _scaleQuantity(
      remainingQuantity,
      commonScale,
    );
    final requested = _scaleQuantity(
      quantity,
      commonScale,
    );

    if (requested > available) {
      throw ArgumentError(
        'Cannot consume more than the remaining quantity.',
      );
    }

    return CostLayer(
      id: id,
      productId: productId,
      originalQuantity: originalQuantity,
      remainingQuantity: remainingQuantity.subtract(quantity),
      unitCost: unitCost,
      acquiredAt: acquiredAt,
      purchaseId: purchaseId,
    );
  }

  static int _scaleQuantity(
    Quantity quantity,
    int targetScale,
  ) {
    if (quantity.scale == targetScale) {
      return quantity.value;
    }

    var factor = 1;

    for (var i = 0; i < targetScale - quantity.scale; i++) {
      factor *= 10;
    }

    return quantity.value * factor;
  }

  static int _scaleFactor(int scale) {
    var result = 1;

    for (var i = 0; i < scale; i++) {
      result *= 10;
    }

    return result;
  }
}
