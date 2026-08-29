import '../../sales/domain/sale_item.dart';

/// Sumber order.
enum OrderSource { online, onsite }

/// Status lifecycle order.
enum OrderStatus {
  pendingPayment,
  paymentFailed,
  expired,
  paid,
  preparing,
  readyForPickup,
  pickedUp,
  completed,
}

/// Metode pembayaran order.
enum OrderPaymentMethod { qris, cash }

/// Order pesanan konsumen.
///
/// Immutable: setelah dibuat (submit), item tidak dapat diubah dan tidak ada
/// transisi kembali (cancel). Perubahan hanya maju melalui [transitionTo].
class Order {
  final String id;
  final String saleId;
  final OrderSource source;
  final OrderStatus status;
  final OrderPaymentMethod paymentMethod;
  final List<SaleItem> items;
  final DateTime createdAt;

  static const _transitions = <OrderStatus, Set<OrderStatus>>{
    OrderStatus.pendingPayment: {
      OrderStatus.paymentFailed,
      OrderStatus.expired,
      OrderStatus.paid,
    },
    OrderStatus.paymentFailed: {OrderStatus.paid},
    OrderStatus.expired: {},
    OrderStatus.paid: {OrderStatus.preparing},
    OrderStatus.preparing: {
      OrderStatus.readyForPickup,
      OrderStatus.completed,
    },
    OrderStatus.readyForPickup: {OrderStatus.pickedUp},
    OrderStatus.pickedUp: {OrderStatus.completed},
    OrderStatus.completed: {},
  };

  Order({
    required this.id,
    required this.saleId,
    required this.source,
    required this.status,
    required this.paymentMethod,
    required this.items,
    required this.createdAt,
  }) {
    if (id.isEmpty) {
      throw ArgumentError('Order ID cannot be empty.');
    }
    if (saleId.isEmpty) {
      throw ArgumentError('Sale ID cannot be empty.');
    }
    if (items.isEmpty) {
      throw ArgumentError('Order items cannot be empty.');
    }
    if (source == OrderSource.online && paymentMethod != OrderPaymentMethod.qris) {
      throw ArgumentError('Online order must use QRIS payment.');
    }

    // Satu order tidak boleh memuat dua item dengan productId sama.
    final seenProductIds = <String>{};
    for (final item in items) {
      if (!seenProductIds.add(item.productId)) {
        throw ArgumentError(
            'Order cannot contain duplicate products (${item.productId}).');
      }
    }
  }

  Order transitionTo(OrderStatus target) {
    final allowed = _transitions[status] ?? const <OrderStatus>{};
    if (!allowed.contains(target)) {
      throw ArgumentError('Invalid order transition: $status -> $target.');
    }

    // Batasan channel:
    // - handover (PREPARING -> COMPLETED) hanya untuk onsite.
    // - ready for pickup hanya untuk online.
    if (status == OrderStatus.preparing && target == OrderStatus.completed) {
      if (source != OrderSource.onsite) {
        throw ArgumentError(
            'Onsite handover is not allowed for online orders.');
      }
    }
    if (status == OrderStatus.preparing &&
        target == OrderStatus.readyForPickup) {
      if (source != OrderSource.online) {
        throw ArgumentError(
            'Ready-for-pickup is not allowed for onsite orders.');
      }
    }

    return Order(
      id: id,
      saleId: saleId,
      source: source,
      status: target,
      paymentMethod: paymentMethod,
      items: items,
      createdAt: createdAt,
    );
  }
}
