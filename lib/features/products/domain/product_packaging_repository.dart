import 'product_packaging.dart';

abstract interface class ProductPackagingRepository {
  List<ProductPackaging> getByProductId(String productId);

  List<ProductPackaging> getAll();

  Future<void> save(ProductPackaging packaging);
}
