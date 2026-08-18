import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/cart/domain/cart.dart';
import 'package:aplikasi_kasir/features/cart/domain/cart_item.dart';
import 'package:aplikasi_kasir/features/cart/domain/cart_repository.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';

void main() {
  group('CartRepository', () {
    test('defines the cart repository contract', () {
      final repository = _FakeCartRepository();

      expect(repository, isA<CartRepository>());
    });

    test('repository can save and retrieve a cart', () {
      final repository = _FakeCartRepository();
      final cart = createCart();

      repository.save('cart-001', cart);

      expect(repository.getById('cart-001'), equals(cart));
      expect(repository.getAll(), contains(cart));
    });

    test('repository can update a cart', () {
      final repository = _FakeCartRepository();
      final cart = createCart();

      repository.save('cart-001', cart);

      final updated = cart.addItem(
        CartItem(
          product: createSecondProduct(),
          quantity: Quantity(value: 1),
        ),
      );

      repository.update('cart-001', updated);

      expect(repository.getById('cart-001'), equals(updated));
    });

    test('repository can delete a cart', () {
      final repository = _FakeCartRepository();
      final cart = createCart();

      repository.save('cart-001', cart);
      repository.deleteById('cart-001');

      expect(repository.getById('cart-001'), isNull);
      expect(repository.getAll(), isEmpty);
    });

    test('returns null for unknown cart', () {
      final repository = _FakeCartRepository();

      expect(repository.getById('unknown'), isNull);
    });
  });
}

Cart createCart() {
  return Cart(
    items: [
      CartItem(
        product: createProduct(),
        quantity: Quantity(value: 2),
      ),
    ],
  );
}

Product createProduct() {
  return const Product(
    id: 'product-001',
    sku: 'SKU-001',
    name: 'Beras Premium',
    baseUnit: Unit.kilogram,
    purchasePrice: Money(
      minorUnits: 12000,
      currency: 'IDR',
    ),
    sellingPrice: Money(
      minorUnits: 15000,
      currency: 'IDR',
    ),
  );
}

Product createSecondProduct() {
  return const Product(
    id: 'product-002',
    sku: 'SKU-002',
    name: 'Minyak Goreng',
    baseUnit: Unit.liter,
    purchasePrice: Money(
      minorUnits: 15000,
      currency: 'IDR',
    ),
    sellingPrice: Money(
      minorUnits: 18000,
      currency: 'IDR',
    ),
  );
}

class _FakeCartRepository implements CartRepository {
  final Map<String, Cart> _carts = {};

  @override
  Cart? getById(String id) => _carts[id];

  @override
  List<Cart> getAll() => List.unmodifiable(_carts.values);

  @override
  void save(String id, Cart cart) {
    _carts[id] = cart;
  }

  @override
  void update(String id, Cart cart) {
    _carts[id] = cart;
  }

  @override
  void deleteById(String id) {
    _carts.remove(id);
  }
}
