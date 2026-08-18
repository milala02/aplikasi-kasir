import 'product.dart';

abstract interface class ProductRepository {
  Product? getById(String id);

  Product? getBySku(String sku);

  List<Product> getAll();

  List<Product> getActive();

  void save(Product product);

  void update(Product product);

  void deleteById(String id);
}
