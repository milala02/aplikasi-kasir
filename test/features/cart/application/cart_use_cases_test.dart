import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/cart/application/cart_use_cases.dart';
import 'package:aplikasi_kasir/features/cart/domain/cart.dart';
import 'package:aplikasi_kasir/features/cart/domain/cart_item.dart';
import 'package:aplikasi_kasir/features/cart/domain/cart_repository.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';

void main() {
  group('CartUseCases', () {
    test('creates and stores an empty cart', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      final cart = useCases.createCart('cart-001');

      expect(cart.items, isEmpty);
      expect(repository.getById('cart-001'), equals(cart));
    });

    test('gets an existing cart', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      final created = useCases.createCart('cart-001');

      expect(
        useCases.getCart('cart-001'),
        equals(created),
      );
    });

    test('returns null when cart does not exist', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      expect(
        useCases.getCart('unknown'),
        isNull,
      );
    });

    test('returns all carts', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      useCases.createCart('cart-001');
      useCases.createCart('cart-002');

      expect(
        useCases.getAllCarts(),
        hasLength(2),
      );
    });

    test('adds item to an existing cart', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      useCases.createCart('cart-001');

      final updated = useCases.addItem(
        cartId: 'cart-001',
        item: createCartItem(),
      );

      expect(updated.items, hasLength(1));
      expect(
        updated.items.first.product.id,
        'product-001',
      );
      expect(
        repository.getById('cart-001'),
        equals(updated),
      );
    });

    test('merges quantity when adding the same product', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      useCases.createCart('cart-001');

      useCases.addItem(
        cartId: 'cart-001',
        item: createCartItem(
          quantity: Quantity(value: 2),
        ),
      );

      final updated = useCases.addItem(
        cartId: 'cart-001',
        item: createCartItem(
          quantity: Quantity(value: 3),
        ),
      );

      expect(updated.items, hasLength(1));
      expect(
        updated.items.first.quantity,
        Quantity(value: 5),
      );
    });

    test('removes a product from a cart', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      useCases.createCart('cart-001');

      useCases.addItem(
        cartId: 'cart-001',
        item: createCartItem(),
      );

      final updated = useCases.removeProduct(
        cartId: 'cart-001',
        productId: 'product-001',
      );

      expect(updated.items, isEmpty);
      expect(
        repository.getById('cart-001'),
        equals(updated),
      );
    });

    test('updates product quantity', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      useCases.createCart('cart-001');

      useCases.addItem(
        cartId: 'cart-001',
        item: createCartItem(
          quantity: Quantity(value: 2),
        ),
      );

      final updated = useCases.updateQuantity(
        cartId: 'cart-001',
        productId: 'product-001',
        quantity: Quantity(value: 7),
      );

      expect(
        updated.items.first.quantity,
        Quantity(value: 7),
      );
    });

    test('deletes a cart', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      useCases.createCart('cart-001');

      useCases.deleteCart('cart-001');

      expect(
        repository.getById('cart-001'),
        isNull,
      );
    });

    test('rejects empty cart id when creating cart', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      expect(
        () => useCases.createCart(''),
        throwsArgumentError,
      );
    });

    test('rejects empty cart id when getting cart', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      expect(
        () => useCases.getCart(''),
        throwsArgumentError,
      );
    });

    test('rejects operations on a missing cart', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      expect(
        () => useCases.addItem(
          cartId: 'missing',
          item: createCartItem(),
        ),
        throwsArgumentError,
      );
    });

    test('rejects empty product id when removing product', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      useCases.createCart('cart-001');

      expect(
        () => useCases.removeProduct(
          cartId: 'cart-001',
          productId: '',
        ),
        throwsArgumentError,
      );
    });

    test('rejects empty product id when updating quantity', () {
      final repository = _FakeCartRepository();
      final useCases = CartUseCases(repository: repository);

      useCases.createCart('cart-001');

      expect(
        () => useCases.updateQuantity(
          cartId: 'cart-001',
          productId: '',
          quantity: Quantity(value: 1),
        ),
        throwsArgumentError,
      );
    });
  });
}

CartItem createCartItem({
  Quantity quantity = const Quantity(value: 1),
}) {
  return CartItem(
    product: createProduct(),
    quantity: quantity,
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

class _FakeCartRepository implements CartRepository {
  final Map<String, Cart> _carts = {};

  @override
  Cart? getById(String id) => _carts[id];

  @override
  List<Cart> getAll() {
    return List.unmodifiable(_carts.values);
  }

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
