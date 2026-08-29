import 'product.dart';

abstract interface class ProductRepository {
  Product? getById(String id);

  Product? getBySku(String sku);

  List<Product> getAll();

  List<Product> getActive();

  Future<void> save(Product product);

  Future<void> update(Product product);

  Future<void> deleteById(String id);
}
