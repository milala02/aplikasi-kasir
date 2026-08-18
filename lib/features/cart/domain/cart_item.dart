import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../products/domain/product.dart';

class CartItem {
  final Product product;
  final Quantity quantity;
  final Money unitPrice;

  CartItem({
    required this.product,
    required this.quantity,
    Money? unitPrice,
  }) : unitPrice = unitPrice ?? product.sellingPrice {
    if (quantity.isZero) {
      throw ArgumentError(
        'Cart item quantity must be greater than zero.',
      );
    }

    if (unitPrice != product.sellingPrice &&
        unitPrice.currency != product.sellingPrice.currency) {
      throw ArgumentError(
        'Cart item price currency must match product currency.',
      );
    }

    if (unitPrice.isNegative) {
      throw ArgumentError(
        'Cart item unit price cannot be negative.',
      );
    }
  }

  Money get subtotal => unitPrice.multiply(quantity.value);

  CartItem copyWith({
    Product? product,
    Quantity? quantity,
    Money? unitPrice,
  }) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is CartItem &&
        other.product == product &&
        other.quantity == quantity &&
        other.unitPrice == unitPrice;
  }

  @override
  int get hashCode => Object.hash(
        product,
        quantity,
        unitPrice,
      );

  @override
  String toString() {
    return 'CartItem('
        'product: $product, '
        'quantity: $quantity, '
        'unitPrice: $unitPrice'
        ')';
  }
}
