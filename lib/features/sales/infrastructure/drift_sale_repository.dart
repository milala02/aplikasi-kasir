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
                productName:
                    i.productId, // nama produk tidak tersimpan di tabel
                unit: Unit.pcs,
                quantity: Quantity(value: i.quantityValue, scale: 0),
                unitPrice:
                    Money(minorUnits: i.unitPriceMinorUnits, currency: 'IDR'),
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
  void save(Sale sale) {
    if (_cache.containsKey(sale.id)) {
      throw ArgumentError('Sale ID already exists.');
    }
    if (_cache.values.any((s) => s.invoiceNumber == sale.invoiceNumber)) {
      throw ArgumentError('Invoice number already exists.');
    }
    _cache[sale.id] = sale;

    db.transaction(() async {
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
              SaleItemsTableCompanion.insert(
                id: '${sale.id}_${item.productId}',
                saleId: sale.id,
                productId: item.productId,
                quantityValue: item.quantity.value.toInt(),
                unitPriceMinorUnits: item.unitPrice.minorUnits,
              ),
            );
      }
    });
  }

  @override
  void update(Sale sale) {
    if (!_cache.containsKey(sale.id)) {
      throw ArgumentError('Sale not found.');
    }
    _cache[sale.id] = sale;
  }

  @override
  void deleteById(String id) {
    _cache.remove(id);
    db.transaction(() async {
      await (db.delete(db.saleItemsTable)..where((t) => t.saleId.equals(id)))
          .go();
      await (db.delete(db.salesTable)..where((t) => t.id.equals(id))).go();
    });
  }
}
