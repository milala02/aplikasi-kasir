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
  Future<void> save(Sale sale) async {
    if (_sales.containsKey(sale.id)) {
      throw ArgumentError('Sale ID already exists.');
    }
    if (_sales.values.any((s) => s.invoiceNumber == sale.invoiceNumber)) {
      throw ArgumentError('Invoice number already exists.');
    }
    _sales[sale.id] = sale;
  }

  @override
  Future<void> update(Sale sale) async {
    if (!_sales.containsKey(sale.id)) {
      throw ArgumentError('Sale not found.');
    }
    _sales[sale.id] = sale;
  }

  @override
  Future<void> deleteById(String id) async {
    _sales.remove(id);
  }

  void clear() {
    _sales.clear();
  }
}
