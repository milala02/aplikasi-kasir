import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../../core/unit/unit.dart';

class SaleItem {
  final String productId;
  final String productName;
  final Unit unit;
  final Quantity quantity;
  final Money unitPrice;

  /// HPP per unit hasil konsumsi FIFO cost layer.
  /// Null untuk data lama (sebelum HPP per item disimpan) — pembaca wajib
  /// menangani null secara eksplisit.
  final Money? unitCost;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
    this.unitCost,
  }) {
    if (productId.isEmpty) {
      throw ArgumentError('Sale item product ID cannot be empty.');
    }

    if (productName.isEmpty) {
      throw ArgumentError('Sale item product name cannot be empty.');
    }

    if (quantity.isZero) {
      throw ArgumentError('Sale item quantity must be greater than zero.');
    }

    if (unitPrice.isNegative) {
      throw ArgumentError('Sale item unit price cannot be negative.');
    }

    if (unitCost?.isNegative == true) {
      throw ArgumentError('Sale item unit cost cannot be negative.');
    }
  }

  Money get subtotal => Money(
        minorUnits:
            unitPrice.minorUnits * quantity.value ~/ _scaleFactor(quantity.scale),
        currency: unitPrice.currency,
      );

  static int _scaleFactor(int scale) {
    var result = 1;
    for (var i = 0; i < scale; i++) {
      result *= 10;
    }
    return result;
  }

  SaleItem withUnitCost(Money cost) {
    return SaleItem(
      productId: productId,
      productName: productName,
      unit: unit,
      quantity: quantity,
      unitPrice: unitPrice,
      unitCost: cost,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SaleItem &&
        other.productId == productId &&
        other.productName == productName &&
        other.unit == unit &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice &&
        other.unitCost == unitCost;
  }

  @override
  int get hashCode {
    return Object.hash(
      productId,
      productName,
      unit,
      quantity,
      unitPrice,
      unitCost,
    );
  }

  @override
  String toString() {
    return 'SaleItem('
        'productId: $productId, '
        'productName: $productName, '
        'unit: $unit, '
        'quantity: $quantity, '
        'unitPrice: $unitPrice, '
        'unitCost: $unitCost'
        ')';
  }
}
