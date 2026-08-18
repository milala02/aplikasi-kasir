import '../../../core/money/money.dart';
import 'product.dart';

class ProductService {
  const ProductService();

  Product updatePrices({
    required Product product,
    required Money purchasePrice,
    required Money sellingPrice,
  }) {
    return product.copyWith(
      purchasePrice: purchasePrice,
      sellingPrice: sellingPrice,
    );
  }

  Product activate(Product product) {
    return product.copyWith(active: true);
  }

  Product deactivate(Product product) {
    return product.copyWith(active: false);
  }
}
