import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/cart/domain/cart.dart';
import 'package:aplikasi_kasir/features/cart/domain/cart_item.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';

void main() {
  group('Cart', () {
    Product createProduct({
      String id = 'product-001',
      int price = 15000,
    }) {
      return Product(
        id: id,
        sku: 'SKU-$id',
        name: 'Product $id',
        baseUnit: Unit.pcs,
        purchasePrice: const Money(
          minorUnits: 10000,
          currency: 'IDR',
        ),
        sellingPrice: Money(
          minorUnits: price,
          currency: 'IDR',
        ),
      );
    }

    CartItem createItem({
      String productId = 'product-001',
      int quantity = 1,
      int price = 15000,
    }) {
      return CartItem(
        product: createProduct(
          id: productId,
          price: price,
        ),
        quantity: Quantity(value: quantity),
      );
    }

    test('starts empty', () {
      final cart = Cart();

      expect(cart.items, isEmpty);
      expect(cart.subtotal, isNull);
    });

    test('adds item', () {
      final cart = Cart().addItem(
        createItem(quantity: 2),
      );

      expect(cart.items.length, 1);
      expect(cart.items.single.quantity, Quantity(value: 2));
    });

    test('calculates subtotal', () {
      final cart = Cart()
          .addItem(
            createItem(
              productId: 'product-001',
              quantity: 2,
              price: 15000,
            ),
          )
          .addItem(
            createItem(
              productId: 'product-002',
              quantity: 3,
              price: 10000,
            ),
          );

      expect(
        cart.subtotal,
        const Money(
          minorUnits: 60000,
          currency: 'IDR',
        ),
      );
    });

    test('merges the same product quantity', () {
      final cart = Cart()
          .addItem(createItem(quantity: 2))
          .addItem(createItem(quantity: 3));

      expect(cart.items.length, 1);
      expect(
        cart.items.single.quantity,
        Quantity(value: 5),
      );
    });

    test('does not mutate original cart', () {
      final original = Cart();
      final updated = original.addItem(
        createItem(),
      );

      expect(original.items, isEmpty);
      expect(updated.items.length, 1);
    });

    test('removes product', () {
      final cart = Cart()
          .addItem(createItem(productId: 'product-001'))
          .addItem(createItem(productId: 'product-002'));

      final updated = cart.removeProduct('product-001');

      expect(updated.items.length, 1);
      expect(
        updated.items.single.product.id,
        'product-002',
      );
    });

    test('updates quantity', () {
      final cart = Cart().addItem(
        createItem(quantity: 2),
      );

      final updated = cart.updateQuantity(
        productId: 'product-001',
        quantity: Quantity(value: 7),
      );

      expect(
        updated.items.single.quantity,
        Quantity(value: 7),
      );
      expect(
        cart.items.single.quantity,
        Quantity(value: 2),
      );
    });

    test('rejects zero updated quantity', () {
      final cart = Cart().addItem(
        createItem(),
      );

      expect(
        () => cart.updateQuantity(
          productId: 'product-001',
          quantity: Quantity.zero(),
        ),
        throwsArgumentError,
      );
    });

    test('rejects updating missing product', () {
      final cart = Cart();

      expect(
        () => cart.updateQuantity(
          productId: 'missing-product',
          quantity: Quantity(value: 1),
        ),
        throwsArgumentError,
      );
    });

    test('rejects duplicate products in constructor', () {
      final item = createItem();

      expect(
        () => Cart(
          items: [
            item,
            item,
          ],
        ),
        throwsArgumentError,
      );
    });
  });
}
