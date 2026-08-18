import 'cart.dart';

abstract interface class CartRepository {
  Cart? getById(String id);

  List<Cart> getAll();

  void save(String id, Cart cart);

  void update(String id, Cart cart);

  void deleteById(String id);
}
