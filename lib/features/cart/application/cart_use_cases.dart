import '../domain/cart.dart';
import '../domain/cart_item.dart';
import '../domain/cart_repository.dart';
import '../../../core/quantity/quantity.dart';

class CartUseCases {
  final CartRepository repository;

  const CartUseCases({
    required this.repository,
  });

  Cart createCart(String cartId) {
    _validateCartId(cartId);

    final cart = Cart();

    repository.save(cartId, cart);

    return cart;
  }

  Cart? getCart(String cartId) {
    _validateCartId(cartId);

    return repository.getById(cartId);
  }

  List<Cart> getAllCarts() {
    return repository.getAll();
  }

  Cart addItem({
    required String cartId,
    required CartItem item,
  }) {
    _validateCartId(cartId);

    final cart = repository.getById(cartId);

    if (cart == null) {
      throw ArgumentError(
        'Cart is not present.',
      );
    }

    final updated = cart.addItem(item);

    repository.update(cartId, updated);

    return updated;
  }

  Cart removeProduct({
    required String cartId,
    required String productId,
  }) {
    _validateCartId(cartId);

    if (productId.isEmpty) {
      throw ArgumentError(
        'Product ID cannot be empty.',
      );
    }

    final cart = repository.getById(cartId);

    if (cart == null) {
      throw ArgumentError(
        'Cart is not present.',
      );
    }

    final updated = cart.removeProduct(productId);

    repository.update(cartId, updated);

    return updated;
  }

  Cart updateQuantity({
    required String cartId,
    required String productId,
    required Quantity quantity,
  }) {
    _validateCartId(cartId);

    if (productId.isEmpty) {
      throw ArgumentError(
        'Product ID cannot be empty.',
      );
    }

    final cart = repository.getById(cartId);

    if (cart == null) {
      throw ArgumentError(
        'Cart is not present.',
      );
    }

    final updated = cart.updateQuantity(
      productId: productId,
      quantity: quantity,
    );

    repository.update(cartId, updated);

    return updated;
  }

  void deleteCart(String cartId) {
    _validateCartId(cartId);

    repository.deleteById(cartId);
  }

  void _validateCartId(String cartId) {
    if (cartId.isEmpty) {
      throw ArgumentError(
        'Cart ID cannot be empty.',
      );
    }
  }
}
