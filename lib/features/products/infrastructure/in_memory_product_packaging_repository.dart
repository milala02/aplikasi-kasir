import '../domain/product_packaging.dart';
import '../domain/product_packaging_repository.dart';

class InMemoryProductPackagingRepository
    implements ProductPackagingRepository {
  final Map<String, ProductPackaging> _packagings = {};

  @override
  List<ProductPackaging> getByProductId(String productId) {
    return List.unmodifiable(
      _packagings.values.where((p) => p.productId == productId),
    );
  }

  @override
  List<ProductPackaging> getAll() =>
      List.unmodifiable(_packagings.values);

  @override
  Future<void> save(ProductPackaging packaging) async {
    if (_packagings.containsKey(packaging.id)) {
      throw ArgumentError('Packaging ID already exists.');
    }
    _packagings[packaging.id] = packaging;
  }
}
