import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import 'cart_item.dart';

class Cart {
  final List<CartItem> items;

  Cart({
    this.items = const [],
  }) {
    final seenProductIds = <String>{};

    for (final item in items) {
      if (!seenProductIds.add(item.product.id)) {
        throw ArgumentError(
          'Cart cannot contain duplicate products.',
        );
      }
    }
  }

  Money? get subtotal {
    if (items.isEmpty) {
      return null;
    }

    var result = Money(
      minorUnits: 0,
      currency: items.first.unitPrice.currency,
    );

    for (final item in items) {
      result = result.add(item.subtotal);
    }

    return result;
  }

  Cart addItem(CartItem item) {
    final index = items.indexWhere(
      (existing) => existing.product.id == item.product.id,
    );

    if (index == -1) {
      return Cart(
        items: [
          ...items,
          item,
        ],
      );
    }

    final existing = items[index];

    final mergedQuantity = existing.quantity.add(item.quantity);

    final updatedItem = existing.copyWith(
      quantity: mergedQuantity,
    );

    final updatedItems = [
      ...items,
    ];

    updatedItems[index] = updatedItem;

    return Cart(
      items: updatedItems,
    );
  }

  Cart removeProduct(String productId) {
    return Cart(
      items: items
          .where((item) => item.product.id != productId)
          .toList(),
    );
  }

  Cart updateQuantity({
    required String productId,
    required Quantity quantity,
  }) {
    if (quantity.isZero) {
      throw ArgumentError(
        'Cart item quantity must be greater than zero.',
      );
    }

    final index = items.indexWhere(
      (item) => item.product.id == productId,
    );

    if (index == -1) {
      throw ArgumentError(
        'Product is not present in cart.',
      );
    }

    final updatedItems = [
      ...items,
    ];

    updatedItems[index] = updatedItems[index].copyWith(
      quantity: quantity,
    );

    return Cart(
      items: updatedItems,
    );
  }

  @override
  bool operator ==(Object other) {
    if (other is! Cart || other.items.length != items.length) {
      return false;
    }

    for (var i = 0; i < items.length; i++) {
      if (other.items[i] != items[i]) {
        return false;
      }
    }

    return true;
  }

  @override
  int get hashCode => Object.hashAll(items);

  @override
  String toString() => 'Cart(items: $items)';
}
