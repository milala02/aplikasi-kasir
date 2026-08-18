import '../domain/sale.dart';
import '../domain/sale_repository.dart';

class InMemorySaleRepository implements SaleRepository {
  final Map<String, Sale> _sales = {};

  @override
  Sale? getById(String id) => _sales[id];

  @override
  Sale? getByInvoiceNumber(String invoiceNumber) {
    for (final sale in _sales.values) {
      if (sale.invoiceNumber == invoiceNumber) {
        return sale;
      }
    }

    return null;
  }

  @override
  List<Sale> getAll() {
    return List.unmodifiable(_sales.values);
  }

  @override
  void save(Sale sale) {
    if (_sales.containsKey(sale.id)) {
      throw ArgumentError('Sale ID already exists.');
    }

    if (getByInvoiceNumber(sale.invoiceNumber) != null) {
      throw ArgumentError('Invoice number already exists.');
    }

    _sales[sale.id] = sale;
  }

  @override
  void update(Sale sale) {
    if (!_sales.containsKey(sale.id)) {
      throw ArgumentError('Sale not found.');
    }

    final existingInvoiceOwner = getByInvoiceNumber(
      sale.invoiceNumber,
    );

    if (existingInvoiceOwner != null &&
        existingInvoiceOwner.id != sale.id) {
      throw ArgumentError('Invoice number already exists.');
    }

    _sales[sale.id] = sale;
  }

  @override
  void deleteById(String id) {
    _sales.remove(id);
  }
}
