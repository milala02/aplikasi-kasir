import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/orders/domain/order.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';

void main() {
  group('Order lifecycle - state machine', () {
    SaleItem item() => SaleItem(
          productId: 'prod_100',
          productName: 'Lada',
          unit: Unit.kilogram,
          quantity: Quantity(value: 2, scale: 0),
          unitPrice: const Money(minorUnits: 3000000, currency: 'IDR'),
        );

    Order buildOrder({
      OrderSource source = OrderSource.onsite,
      OrderStatus status = OrderStatus.pendingPayment,
      OrderPaymentMethod paymentMethod = OrderPaymentMethod.qris,
    }) {
      return Order(
        id: 'ord_1',
        saleId: 'sale_1',
        source: source,
        status: status,
        paymentMethod: paymentMethod,
        items: [item()],
        createdAt: DateTime(2026, 8, 20),
      );
    }

    test('transisi valid onsite: pendingPayment -> paid -> preparing -> completed',
        () {
      final order = buildOrder();
      final paid = order.transitionTo(OrderStatus.paid);
      expect(paid.status, OrderStatus.paid);

      final preparing = paid.transitionTo(OrderStatus.preparing);
      expect(preparing.status, OrderStatus.preparing);

      final completed = preparing.transitionTo(OrderStatus.completed);
      expect(completed.status, OrderStatus.completed);
    });

    test('transisi valid online: paid -> preparing -> readyForPickup -> pickedUp -> completed',
        () {
      final order = buildOrder(source: OrderSource.online);
      final paid = order.transitionTo(OrderStatus.paid);
      final preparing = paid.transitionTo(OrderStatus.preparing);
      final ready = preparing.transitionTo(OrderStatus.readyForPickup);
      final pickedUp = ready.transitionTo(OrderStatus.pickedUp);
      final completed = pickedUp.transitionTo(OrderStatus.completed);

      expect(completed.status, OrderStatus.completed);
    });

    test('payment failure -> retry -> paid', () {
      final order = buildOrder();
      final failed = order.transitionTo(OrderStatus.paymentFailed);
      expect(failed.status, OrderStatus.paymentFailed);

      final paid = failed.transitionTo(OrderStatus.paid);
      expect(paid.status, OrderStatus.paid);
    });

    test('payment expiry adalah terminal', () {
      final order = buildOrder();
      final expired = order.transitionTo(OrderStatus.expired);
      expect(expired.status, OrderStatus.expired);

      expect(
        () => expired.transitionTo(OrderStatus.paid),
        throwsArgumentError,
      );
    });

    test('tidak ada cancel/edit setelah submit (transisi mundur ditolak)', () {
      final order = buildOrder(status: OrderStatus.paid);
      expect(
        () => order.transitionTo(OrderStatus.pendingPayment),
        throwsArgumentError,
      );
      expect(
        () => order.transitionTo(OrderStatus.paymentFailed),
        throwsArgumentError,
      );

      final completed = buildOrder(status: OrderStatus.completed);
      expect(
        () => completed.transitionTo(OrderStatus.pendingPayment),
        throwsArgumentError,
      );
    });

    test('transisi item dipertahankan (immutable)', () {
      final order = buildOrder();
      final paid = order.transitionTo(OrderStatus.paid);
      expect(paid.items, same(order.items));
      expect(paid.items.single.productId, 'prod_100');
    });

    test('channel constraint: onsite tidak boleh readyForPickup', () {
      final order = buildOrder(status: OrderStatus.preparing);
      expect(
        () => order.transitionTo(OrderStatus.readyForPickup),
        throwsArgumentError,
      );
    });

    test('channel constraint: online tidak boleh handover langsung', () {
      final order =
          buildOrder(source: OrderSource.online, status: OrderStatus.preparing);
      expect(
        () => order.transitionTo(OrderStatus.completed),
        throwsArgumentError,
      );
    });

    test('online wajib QRIS', () {
      expect(
        () => buildOrder(
          source: OrderSource.online,
          paymentMethod: OrderPaymentMethod.cash,
        ),
        throwsArgumentError,
      );
    });

    test('onsite boleh QRIS atau tunai', () {
      expect(
        buildOrder(paymentMethod: OrderPaymentMethod.qris).status,
        OrderStatus.pendingPayment,
      );
      expect(
        buildOrder(paymentMethod: OrderPaymentMethod.cash).status,
        OrderStatus.pendingPayment,
      );
    });

    test('item duplikat ditolak', () {
      expect(
        () => Order(
          id: 'ord_1',
          saleId: 'sale_1',
          source: OrderSource.onsite,
          status: OrderStatus.pendingPayment,
          paymentMethod: OrderPaymentMethod.qris,
          items: [item(), item()],
          createdAt: DateTime(2026, 8, 20),
        ),
        throwsArgumentError,
      );
    });
  });
}
