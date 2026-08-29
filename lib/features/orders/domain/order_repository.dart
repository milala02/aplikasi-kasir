import 'order.dart';

abstract interface class OrderRepository {
  Order? getById(String id);

  List<Order> getAll();

  Future<void> save(Order order);

  Future<void> update(Order order);
}
