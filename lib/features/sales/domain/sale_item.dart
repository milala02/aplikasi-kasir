import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../../core/unit/unit.dart';

class SaleItem {
  final String productId;
  final String productName;
  final Unit unit;
  final Quantity quantity;
  final Money unitPrice;

  SaleItem({
    required this.productId,
    required this.productName,
    required this.unit,
    required this.quantity,
    required this.unitPrice,
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
  }

  Money get subtotal => unitPrice.multiply(quantity.value);

  @override
  bool operator ==(Object other) {
    return other is SaleItem &&
        other.productId == productId &&
        other.productName == productName &&
        other.unit == unit &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice;
  }

  @override
  int get hashCode {
    return Object.hash(
      productId,
      productName,
      unit,
      quantity,
      unitPrice,
    );
  }

  @override
  String toString() {
    return 'SaleItem('
        'productId: $productId, '
        'productName: $productName, '
        'unit: $unit, '
        'quantity: $quantity, '
        'unitPrice: $unitPrice'
        ')';
  }
}
