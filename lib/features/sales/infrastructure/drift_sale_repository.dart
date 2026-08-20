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
  DriftSaleRepository(this.db);

  @override
  Sale? getById(String id) => null;

  @override
  Sale? getByInvoiceNumber(String invoiceNumber) => null;

  @override
  List<Sale> getAll() => [];

  @override
  void save(Sale sale) {
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
            quantityValue: item.quantity.value.toInt(), // Menggunakan .value
            unitPriceMinorUnits: item.unitPrice.minorUnits,
          ),
        );
      }
    });
  }

  @override
  void update(Sale sale) {}

  @override
  void deleteById(String id) {
    db.transaction(() async {
      await (db.delete(db.saleItemsTable)..where((t) => t.saleId.equals(id))).go();
      await (db.delete(db.salesTable)..where((t) => t.id.equals(id))).go();
    });
  }
}
