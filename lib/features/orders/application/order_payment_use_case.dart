import '../../../core/errors/domain_error.dart';
import '../../../core/result/result.dart';
import '../domain/order.dart';
import '../domain/order_repository.dart';

/// Transisi pembayaran order. TIDAK menyentuh inventory/cost layer.
class OrderPaymentUseCase {
  final OrderRepository orderRepository;

  OrderPaymentUseCase({
    required this.orderRepository,
  });

  Future<Result<Order>> confirm(Order order) async {
    return _transition(order, OrderStatus.paid, 'PAYMENT_ERROR');
  }

  Future<Result<Order>> markFailed(Order order) async {
    return _transition(order, OrderStatus.paymentFailed, 'PAYMENT_ERROR');
  }

  Future<Result<Order>> markExpired(Order order) async {
    return _transition(order, OrderStatus.expired, 'PAYMENT_ERROR');
  }

  Future<Result<Order>> _transition(
    Order order,
    OrderStatus target,
    String errorCode,
  ) async {
    try {
      final updated = order.transitionTo(target);
      await orderRepository.update(updated);
      return Success(updated);
    } on ArgumentError catch (e) {
      return Failure(
        DomainError(code: 'INVALID_TRANSITION', message: e.message ?? '$e'),
      );
    } catch (e) {
      return Failure(
        DomainError(
          code: errorCode,
          message: 'Gagal memproses pembayaran: ${e.toString()}',
        ),
      );
    }
  }
}
