import '../domain/product.dart';
import '../domain/product_repository.dart';

class InMemoryProductRepository implements ProductRepository {
  final Map<String, Product> _products = {};

  @override
  Product? getById(String id) => _products[id];

  @override
  Product? getBySku(String sku) {
    for (final product in _products.values) {
      if (product.sku == sku) {
        return product;
      }
    }

    return null;
  }

  @override
  List<Product> getAll() {
    return List.unmodifiable(_products.values);
  }

  @override
  List<Product> getActive() {
    return List.unmodifiable(
      _products.values.where((product) => product.active),
    );
  }

  @override
  Future<void> save(Product product) async {
    if (_products.containsKey(product.id)) {
      throw ArgumentError('Product ID already exists.');
    }

    if (getBySku(product.sku) != null) {
      throw ArgumentError('Product SKU already exists.');
    }

    _products[product.id] = product;
  }

  @override
  Future<void> update(Product product) async {
    if (!_products.containsKey(product.id)) {
      throw ArgumentError('Product not found.');
    }

    final existingSkuOwner = getBySku(product.sku);

    if (existingSkuOwner != null && existingSkuOwner.id != product.id) {
      throw ArgumentError('Product SKU already exists.');
    }

    _products[product.id] = product;
  }

  @override
  Future<void> deleteById(String id) async {
    _products.remove(id);
  }
}
