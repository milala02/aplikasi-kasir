import 'sale.dart';

abstract interface class SaleRepository {
  Sale? getById(String id);
  Sale? getByInvoiceNumber(String invoiceNumber);
  List<Sale> getAll();
  Future<void> save(Sale sale);
  Future<void> update(Sale sale);
  Future<void> deleteById(String id);
}
