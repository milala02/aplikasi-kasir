import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/features/cart/domain/cart.dart';
import 'package:aplikasi_kasir/features/cart/infrastructure/in_memory_cart_repository.dart';

void main() {
  group('InMemoryCartRepository', () {
    test('saves and retrieves a cart', () {
      final repository = InMemoryCartRepository();
      final cart = Cart();

      repository.save('cart-001', cart);

      expect(repository.getById('cart-001'), equals(cart));
    });

    test('returns all carts', () {
      final repository = InMemoryCartRepository();
      final first = Cart();
      final second = Cart();

      repository.save('cart-001', first);
      repository.save('cart-002', second);

      expect(repository.getAll(), hasLength(2));
    });

    test('rejects duplicate cart id', () {
      final repository = InMemoryCartRepository();

      repository.save('cart-001', Cart());

      expect(
        () => repository.save('cart-001', Cart()),
        throwsArgumentError,
      );
    });

    test('updates an existing cart', () {
      final repository = InMemoryCartRepository();
      final original = Cart();
      final updated = Cart();

      repository.save('cart-001', original);
      repository.update('cart-001', updated);

      expect(repository.getById('cart-001'), equals(updated));
    });

    test('rejects updating missing cart', () {
      final repository = InMemoryCartRepository();

      expect(
        () => repository.update('missing', Cart()),
        throwsArgumentError,
      );
    });

    test('deletes a cart', () {
      final repository = InMemoryCartRepository();

      repository.save('cart-001', Cart());
      repository.deleteById('cart-001');

      expect(repository.getById('cart-001'), isNull);
    });
  });
}
