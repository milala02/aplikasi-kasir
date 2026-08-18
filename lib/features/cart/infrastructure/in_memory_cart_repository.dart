import '../domain/cart.dart';
import '../domain/cart_repository.dart';

class InMemoryCartRepository implements CartRepository {
  final Map<String, Cart> _carts = {};

  @override
  Cart? getById(String id) => _carts[id];

  @override
  List<Cart> getAll() {
    return List.unmodifiable(_carts.values);
  }

  @override
  void save(String id, Cart cart) {
    if (id.isEmpty) {
      throw ArgumentError('Cart ID cannot be empty.');
    }

    if (_carts.containsKey(id)) {
      throw ArgumentError('Cart ID already exists.');
    }

    _carts[id] = cart;
  }

  @override
  void update(String id, Cart cart) {
    if (id.isEmpty) {
      throw ArgumentError('Cart ID cannot be empty.');
    }

    if (!_carts.containsKey(id)) {
      throw ArgumentError('Cart not found.');
    }

    _carts[id] = cart;
  }

  @override
  void deleteById(String id) {
    _carts.remove(id);
  }
}
