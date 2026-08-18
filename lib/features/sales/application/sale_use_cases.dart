import '../../../core/money/money.dart';
import '../domain/sale.dart';
import '../domain/sale_item.dart';
import '../domain/sale_repository.dart';
import '../domain/sale_service.dart';

class SaleUseCases {
  final SaleRepository repository;

  const SaleUseCases({
    required this.repository,
  });

  Sale? getById(String id) {
    return repository.getById(id);
  }

  List<Sale> getAll() {
    return List.unmodifiable(repository.getAll());
  }

  void create(Sale sale) {
    repository.save(sale.id, sale);
  }

  void addItem({
    required String saleId,
    required SaleItem item,
  }) {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).addItem(item);
    repository.update(sale.id, updated.sale);
  }

  void removeItemAt({
    required String saleId,
    required int index,
  }) {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).removeItemAt(index);
    repository.update(sale.id, updated.sale);
  }

  void applyDiscount({
    required String saleId,
    required Money discount,
  }) {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).withDiscount(discount);
    repository.update(sale.id, updated.sale);
  }

  void applyTax({
    required String saleId,
    required Money tax,
  }) {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).withTax(tax);
    repository.update(sale.id, updated.sale);
  }

  void delete(String saleId) {
    _getRequiredSale(saleId);
    repository.deleteById(saleId);
  }

  Sale _getRequiredSale(String saleId) {
    if (saleId.isEmpty) {
      throw ArgumentError('Sale ID cannot be empty.');
    }

    final sale = repository.getById(saleId);

    if (sale == null) {
      throw ArgumentError('Sale not found.');
    }

    return sale;
  }
}
