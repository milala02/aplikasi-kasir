import '../domain/product.dart';
import '../domain/product_repository.dart';
import '../domain/product_service.dart';
import '../../../core/money/money.dart';

class ProductUseCases {
  final ProductRepository repository;
  final ProductService service;

  const ProductUseCases({
    required this.repository,
    this.service = const ProductService(),
  });

  Product? getById(String id) {
    return repository.getById(id);
  }

  Product? getBySku(String sku) {
    return repository.getBySku(sku);
  }

  List<Product> getAll() {
    return repository.getAll();
  }

  List<Product> getActive() {
    return repository.getActive();
  }

  Future<void> create(Product product) async {
    if (repository.getById(product.id) != null) {
      throw ArgumentError('Product ID already exists.');
    }

    if (repository.getBySku(product.sku) != null) {
      throw ArgumentError('Product SKU already exists.');
    }

    await repository.save(product);
  }

  Future<void> updatePrices({
    required String productId,
    required Money purchasePrice,
    required Money sellingPrice,
  }) async {
    final product = repository.getById(productId);

    if (product == null) {
      throw ArgumentError('Product not found.');
    }

    await repository.update(
      service.updatePrices(
        product: product,
        purchasePrice: purchasePrice,
        sellingPrice: sellingPrice,
      ),
    );
  }

  Future<void> activate(String productId) async {
    final product = repository.getById(productId);

    if (product == null) {
      throw ArgumentError('Product not found.');
    }

    await repository.update(service.activate(product));
  }

  Future<void> deactivate(String productId) async {
    final product = repository.getById(productId);

    if (product == null) {
      throw ArgumentError('Product not found.');
    }

    await repository.update(service.deactivate(product));
  }

  Future<void> delete(String productId) async {
    if (repository.getById(productId) == null) {
      throw ArgumentError('Product not found.');
    }

    await repository.deleteById(productId);
  }
}
