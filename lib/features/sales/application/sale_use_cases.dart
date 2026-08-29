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
    if (id.isEmpty) {
      throw ArgumentError('Sale ID cannot be empty.');
    }

    return repository.getById(id);
  }

  List<Sale> getAll() {
    return List.unmodifiable(repository.getAll());
  }

  Future<void> create(Sale sale) {
    return repository.save(sale);
  }

  Future<void> addItem({
    required String saleId,
    required SaleItem item,
  }) async {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).addItem(item);
    await repository.update(updated.sale);
  }

  Future<void> removeItemAt({
    required String saleId,
    required int index,
  }) async {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).removeItemAt(index);
    await repository.update(updated.sale);
  }

  Future<void> applyDiscount({
    required String saleId,
    required Money discount,
  }) async {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).withDiscount(discount);
    await repository.update(updated.sale);
  }

  Future<void> applyTax({
    required String saleId,
    required Money tax,
  }) async {
    final sale = _getRequiredSale(saleId);
    final updated = SaleService(sale: sale).withTax(tax);
    await repository.update(updated.sale);
  }

  Future<void> delete(String saleId) async {
    _getRequiredSale(saleId);
    await repository.deleteById(saleId);
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
