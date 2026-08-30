import 'package:drift/drift.dart' as d;

import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../../core/unit/unit.dart';
import '../../sales/domain/sale_item.dart';
import '../domain/order.dart';
import '../domain/order_repository.dart';

class DriftOrderRepository implements OrderRepository {
  final AppDatabase db;
  final Map<String, Order> _cache = {};

  DriftOrderRepository(this.db);

  /// Muat semua order + item dari DB ke dalam cache.
  Future<void> init() async {
    final orderRows = await db.select(db.ordersTable).get();
    final itemRows = await db.select(db.orderItemsTable).get();

    _cache.clear();
    for (final row in orderRows) {
      final items = itemRows
          .where((i) => i.orderId == row.id)
          .map(_itemToDomain)
          .toList();

      if (items.isEmpty) continue; // Order tanpa item tidak valid.

      final order = Order(
        id: row.id,
        saleId: row.saleId,
        source: OrderSource.values.firstWhere(
          (s) => s.name == row.source,
          orElse: () =>
              throw StateError('Unknown order source: ${row.source}'),
        ),
        status: OrderStatus.values.firstWhere(
          (s) => s.name == row.status,
          orElse: () =>
              throw StateError('Unknown order status: ${row.status}'),
        ),
        paymentMethod: OrderPaymentMethod.values.firstWhere(
          (m) => m.name == row.paymentMethod,
          orElse: () =>
              throw StateError('Unknown payment method: ${row.paymentMethod}'),
        ),
        items: items,
        createdAt: row.createdAt,
      );
      _cache[order.id] = order;
    }
  }

  @override
  Order? getById(String id) => _cache[id];

  @override
  List<Order> getAll() => List.unmodifiable(_cache.values);

  @override
  Future<void> save(Order order) async {
    if (_cache.containsKey(order.id)) {
      throw ArgumentError('Order ID already exists.');
    }

    await db.transaction(() async {
      await db.into(db.ordersTable).insert(
            OrdersTableCompanion.insert(
              id: order.id,
              saleId: order.saleId,
              source: order.source.name,
              status: order.status.name,
              paymentMethod: order.paymentMethod.name,
              createdAt: order.createdAt,
            ),
          );

      for (final item in order.items) {
        await db.into(db.orderItemsTable).insert(
              _itemCompanion(order.id, item),
            );
      }
    });

    _cache[order.id] = order;
  }

  @override
  Future<void> update(Order order) async {
    if (!_cache.containsKey(order.id)) {
      throw ArgumentError('Order not found.');
    }

    // Pertahankan flag CDC saat update (sync layer mengelolanya terpisah).
    final existingRow = await (db.select(db.ordersTable)
          ..where((t) => t.id.equals(order.id)))
        .getSingle();

    await db.transaction(() async {
      await db.update(db.ordersTable).replace(
            OrdersTableData(
              id: order.id,
              saleId: order.saleId,
              source: order.source.name,
              status: order.status.name,
              paymentMethod: order.paymentMethod.name,
              createdAt: order.createdAt,
              isSynced: existingRow.isSynced,
              syncedAt: existingRow.syncedAt,
            ),
          );

      await (db.delete(db.orderItemsTable)
            ..where((t) => t.orderId.equals(order.id)))
          .go();

      for (final item in order.items) {
        await db.into(db.orderItemsTable).insert(
              _itemCompanion(order.id, item),
            );
      }
    });

    _cache[order.id] = order;
  }

  OrderItemsTableCompanion _itemCompanion(String orderId, SaleItem item) {
    return OrderItemsTableCompanion.insert(
      id: '${orderId}_${item.productId}',
      orderId: orderId,
      productId: item.productId,
      quantityValue: item.quantity.value.toInt(),
      quantityScale: d.Value(item.quantity.scale),
      productName: item.productName,
      unit: item.unit.name,
      unitPriceMinorUnits: item.unitPrice.minorUnits,
      unitPriceCurrency: d.Value(item.unitPrice.currency),
    );
  }

  SaleItem _itemToDomain(OrderItemsTableData row) {
    // Order item tidak pernah membawa HPP (HPP dikunci pada Sale saat
    // stock-out) — unitCost selalu null saat dimuat.
    return SaleItem(
      productId: row.productId,
      productName: row.productName,
      unit: Unit.values.firstWhere(
        (u) => u.name == row.unit,
        orElse: () => throw StateError('Unknown unit: ${row.unit}'),
      ),
      quantity: Quantity(
        value: row.quantityValue,
        scale: row.quantityScale,
      ),
      unitPrice: Money(
        minorUnits: row.unitPriceMinorUnits,
        currency: row.unitPriceCurrency,
      ),
    );
  }
}
