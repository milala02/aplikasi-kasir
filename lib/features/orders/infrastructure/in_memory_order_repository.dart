import '../domain/order.dart';
import '../domain/order_repository.dart';

class InMemoryOrderRepository implements OrderRepository {
  final Map<String, Order> _orders = {};

  @override
  Order? getById(String id) => _orders[id];

  @override
  List<Order> getAll() => List.unmodifiable(_orders.values);

  @override
  Future<void> save(Order order) async {
    if (_orders.containsKey(order.id)) {
      throw ArgumentError('Order ID already exists.');
    }
    _orders[order.id] = order;
  }

  @override
  Future<void> update(Order order) async {
    if (!_orders.containsKey(order.id)) {
      throw ArgumentError('Order not found.');
    }
    _orders[order.id] = order;
  }
}
