import 'sale.dart';

abstract interface class SaleRepository {
  Sale? getById(String id);

  Sale? getByInvoiceNumber(String invoiceNumber);

  List<Sale> getAll();

  void save(Sale sale);

  void update(Sale sale);

  void deleteById(String id);
}
