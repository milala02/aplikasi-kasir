import '../domain/sale.dart';
import '../domain/sale_repository.dart';

class InMemorySaleRepository implements SaleRepository {
  final Map<String, Sale> _sales = {};

  @override
  Sale? getById(String id) => _sales[id];

  @override
  Sale? getByInvoiceNumber(String invoiceNumber) {
    try {
      return _sales.values.firstWhere(
        (sale) => sale.invoiceNumber == invoiceNumber,
      );
    } catch (_) {
      return null;
    }
  }

  @override
  List<Sale> getAll() => _sales.values.toList();

  @override
  void save(Sale sale) {
    if (_sales.containsKey(sale.id)) {
      throw ArgumentError('Sale ID already exists.');
    }
    if (_sales.values.any((s) => s.invoiceNumber == sale.invoiceNumber)) {
      throw ArgumentError('Invoice number already exists.');
    }
    _sales[sale.id] = sale;
  }

  @override
  void update(Sale sale) {
    if (!_sales.containsKey(sale.id)) {
      throw ArgumentError('Sale not found.');
    }
    _sales[sale.id] = sale;
  }

  @override
  void deleteById(String id) {
    _sales.remove(id);
  }

  void clear() {
    _sales.clear();
  }
}
