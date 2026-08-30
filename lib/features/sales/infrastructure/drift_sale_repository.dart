import 'package:drift/drift.dart' as d;

import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../../core/unit/unit.dart';
import '../domain/sale.dart';
import '../domain/sale_item.dart';
import '../domain/sale_repository.dart';

class DriftSaleRepository implements SaleRepository {
  final AppDatabase db;
  final Map<String, Sale> _cache = {};

  DriftSaleRepository(this.db);

  /// Muat semua data penjualan dari DB ke dalam cache.
  Future<void> init() async {
    final saleRows = await db.select(db.salesTable).get();
    final itemRows = await db.select(db.saleItemsTable).get();

    _cache.clear();
    for (final row in saleRows) {
      final items = itemRows
          .where((i) => i.saleId == row.id)
          .map((i) => SaleItem(
                productId: i.productId,
                productName: (i.productName == null || i.productName!.isEmpty)
                    ? i.productId // Fallback data lama tanpa nama produk.
                    : i.productName!,
                unit: Unit.values.firstWhere(
                  (u) => u.name == i.unit,
                  orElse: () => Unit.pcs, // Fallback data lama tanpa unit.
                ),
                quantity: Quantity(
                  value: i.quantityValue,
                  scale: i.quantityScale,
                ),
                unitPrice:
                    Money(minorUnits: i.unitPriceMinorUnits, currency: 'IDR'),
                unitCost: (i.unitCostMinorUnits == null ||
                        i.unitCostCurrency == null)
                    ? null // Data lama tanpa HPP: fallback eksplisit.
                    : Money(
                        minorUnits: i.unitCostMinorUnits!,
                        currency: i.unitCostCurrency!,
                      ),
              ))
          .toList();

      if (items.isEmpty) continue;

      final sale = Sale(
        id: row.id,
        invoiceNumber: row.invoiceNumber,
        items: items,
        discount: Money(minorUnits: row.discountMinorUnits, currency: 'IDR'),
        tax: Money(minorUnits: row.taxMinorUnits, currency: 'IDR'),
        createdAt: row.createdAt,
        soldAt: row.soldAt,
      );
      _cache[sale.id] = sale;
    }
  }

  @override
  Sale? getById(String id) => _cache[id];

  @override
  Sale? getByInvoiceNumber(String invoiceNumber) {
    try {
      return _cache.values.firstWhere((s) => s.invoiceNumber == invoiceNumber);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Sale> getAll() => List.unmodifiable(_cache.values.toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt)));

  @override
  Future<void> save(Sale sale) async {
    if (_cache.containsKey(sale.id)) {
      throw ArgumentError('Sale ID already exists.');
    }
    if (_cache.values.any((s) => s.invoiceNumber == sale.invoiceNumber)) {
      throw ArgumentError('Invoice number already exists.');
    }

    await db.transaction(() async {
      await db.into(db.salesTable).insert(
            SalesTableCompanion.insert(
              id: sale.id,
              invoiceNumber: sale.invoiceNumber,
              discountMinorUnits: sale.discount.minorUnits,
              taxMinorUnits: sale.tax.minorUnits,
              createdAt: sale.createdAt,
              soldAt: sale.soldAt,
            ),
          );

      for (var item in sale.items) {
        await db.into(db.saleItemsTable).insert(
              _itemCompanion(sale.id, item),
            );
      }
    });

    _cache[sale.id] = sale;
  }

  @override
  Future<void> update(Sale sale) async {
    if (!_cache.containsKey(sale.id)) {
      throw ArgumentError('Sale not found.');
    }

    // Pertahankan flag CDC saat update (sync layer mengelolanya terpisah).
    final existingRow = await (db.select(db.salesTable)
          ..where((t) => t.id.equals(sale.id)))
        .getSingle();

    await db.transaction(() async {
      await db.update(db.salesTable).replace(
            SalesTableData(
              id: sale.id,
              invoiceNumber: sale.invoiceNumber,
              discountMinorUnits: sale.discount.minorUnits,
              taxMinorUnits: sale.tax.minorUnits,
              createdAt: sale.createdAt,
              soldAt: sale.soldAt,
              isSynced: existingRow.isSynced,
              syncedAt: existingRow.syncedAt,
            ),
          );

      await (db.delete(db.saleItemsTable)
            ..where((t) => t.saleId.equals(sale.id)))
          .go();

      for (var item in sale.items) {
        await db.into(db.saleItemsTable).insert(
              _itemCompanion(sale.id, item),
            );
      }
    });

    _cache[sale.id] = sale;
  }

  @override
  Future<void> deleteById(String id) async {
    await db.transaction(() async {
      await (db.delete(db.saleItemsTable)..where((t) => t.saleId.equals(id)))
          .go();
      await (db.delete(db.salesTable)..where((t) => t.id.equals(id))).go();
    });

    _cache.remove(id);
  }

  SaleItemsTableCompanion _itemCompanion(String saleId, SaleItem item) {
    return SaleItemsTableCompanion.insert(
      id: '${saleId}_${item.productId}',
      saleId: saleId,
      productId: item.productId,
      quantityValue: item.quantity.value.toInt(),
      quantityScale: d.Value(item.quantity.scale),
      productName: d.Value(item.productName),
      unit: d.Value(item.unit.name),
      unitPriceMinorUnits: item.unitPrice.minorUnits,
      unitCostMinorUnits: d.Value(item.unitCost?.minorUnits),
      unitCostCurrency: d.Value(item.unitCost?.currency),
    );
  }
}
