import 'dart:convert';

import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../customers/domain/customer.dart';
import '../../orders/domain/order.dart';
import '../../products/domain/product.dart';
import '../../purchasing/domain/purchase.dart';
import '../../receiving/domain/receiving.dart';
import '../../sales/domain/sale.dart';
import '../domain/sync_queue_entry.dart';
import '../domain/sync_queue_repository.dart';
import '../domain/sync_uuid.dart';

/// Enqueue payload sinkronisasi setelah commit lokal sukses.
/// Best-effort: kegagalan antrian tidak boleh menggagalkan transaksi bisnis.
///
/// Konvensi payload: memuat `id` referensi + detail entitas (camelCase) —
/// kontrak final menyesuaikan backend; satu titik perubahan di sini.
class SyncEnqueueService {
  final SyncQueueRepository repository;

  SyncEnqueueService({required this.repository});

  Future<void> enqueue({
    required String referenceId,
    required String endpoint,
    required String sourceTable,
    required Map<String, dynamic> payload,
    bool wrapInOrders = false,
  }) async {
    final now = DateTime.now();
    // Kontrak backend: push order dibungkus `{"orders": [...]}` sesuai
    // domain.SyncPushPayload (tanpa kunci tambahan). Entitas lain masih
    // payload flat sementara menunggu kontrak backend masing-masing.
    final body = wrapInOrders
        ? {'orders': [payload]}
        : {'id': referenceId, ...payload};
    final entry = SyncQueueEntry(
      id: 'sq_${referenceId}_${now.microsecondsSinceEpoch}',
      endpoint: endpoint,
      sourceTable: sourceTable,
      referenceId: referenceId,
      payloadJson: jsonEncode(body),
      status: SyncQueueStatus.pending,
      retryCount: 0,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await repository.save(entry);
    } catch (_) {
      // Best-effort: sync gagal tidak memblokir alur bisnis.
    }
  }

  static Map<String, dynamic> salePayload(Sale sale) => {
        'invoice_number': sale.invoiceNumber,
        'discount_minor_units': sale.discount.minorUnits,
        'tax_minor_units': sale.tax.minorUnits,
        'created_at': sale.createdAt.toIso8601String(),
        'sold_at': sale.soldAt.toIso8601String(),
        'items': [
          for (final item in sale.items)
            {
              'product_id': item.productId,
              'product_name': item.productName,
              'unit': item.unit.name,
              'quantity': _quantity(item.quantity),
              'unit_price': _money(item.unitPrice),
              'unit_cost':
                  item.unitCost == null ? null : _money(item.unitCost!),
            },
        ],
      };

  /// Payload satu order sesuai `domain.OrderPushPayload` backend Go
  /// (camelCase, field uuid di-map dari id lokal via [SyncUuid]).
  /// Dibungkus `{"orders": [...]}` oleh `enqueue(wrapInOrders: true)`.
  ///
  /// Catatan mapping (data konversi packaging tidak tersedia di level
  /// order): unit input diasumsikan sama dengan unit stok, sehingga
  /// `enteredQuantity` == `normalizedStockQty` == `quantity.value`.
  static Map<String, dynamic> orderPayload(
    Order order, {
    required String invoiceNumber,
  }) {
    var totalMinor = 0;
    final items = <Map<String, dynamic>>[
      for (final item in order.items)
        () {
          final subtotalMinor = item.subtotal.minorUnits;
          totalMinor += subtotalMinor;
          return {
            'productId': SyncUuid.entity(item.productId),
            'enteredQuantity': item.quantity.value,
            'enteredUomId': SyncUuid.uom(item.unit.name),
            'normalizedStockQty': item.quantity.value,
            'stockUomId': SyncUuid.uom(item.unit.name),
            'priceMinorUnits': item.unitPrice.minorUnits,
            'subtotalMinorUnits': subtotalMinor,
          };
        }(),
    ];

    return {
      'id': SyncUuid.entity(order.id),
      'orderNumber': invoiceNumber,
      'channel': order.source.name,
      'totalAmountMinorUnits': totalMinor,
      'createdAt': order.createdAt.toUtc().toIso8601String(),
      'items': items,
    };
  }

  static Map<String, dynamic> purchasePayload(Purchase purchase) => {
        'purchased_at': purchase.purchasedAt.toIso8601String(),
        'supplier_id': purchase.supplierId,
        'reference_number': purchase.referenceNumber,
        'items': [
          for (final item in purchase.items)
            {
              'product_id': item.productId,
              'unit': item.unit.name,
              'quantity': _quantity(item.quantity),
              'unit_cost': _money(item.unitCost),
            },
        ],
      };

  static Map<String, dynamic> receivingPayload(Receiving receiving) => {
        'purchase_id': receiving.purchaseId,
        'received_at': receiving.receivedAt.toIso8601String(),
        'items': [
          for (final item in receiving.items)
            {
              'product_id': item.productId,
              'unit': item.unit.name,
              'quantity': _quantity(item.quantityReceived),
              'unit_cost': _money(item.unitCost),
            },
        ],
      };

  static Map<String, dynamic> productPayload(Product product) => {
        'sku': product.sku,
        'name': product.name,
        'base_unit': product.baseUnit.name,
        'purchase_price': _money(product.purchasePrice),
        'selling_price': _money(product.sellingPrice),
        'active': product.active,
      };

  static Map<String, dynamic> customerPayload(Customer customer) => {
        'name': customer.name,
        'phone_number': customer.phoneNumber,
        'address': customer.address,
        'notes': customer.notes,
        'created_at': customer.createdAt.toIso8601String(),
      };

  static Map<String, dynamic> _money(Money money) => {
        'minor_units': money.minorUnits,
        'currency': money.currency,
      };

  static Map<String, dynamic> _quantity(Quantity quantity) => {
        'value': quantity.value,
        'scale': quantity.scale,
      };
}
