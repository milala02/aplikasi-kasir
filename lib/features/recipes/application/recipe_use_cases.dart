import '../../products/domain/product_repository.dart';
import '../domain/recipe.dart';
import '../domain/recipe_repository.dart';

/// Pengelolaan resep (owner). Recipe hanya menyimpan komposisi bahan
/// (productId + quantity) dan expected output — TANPA harga.
class RecipeUseCases {
  final RecipeRepository repository;
  final ProductRepository productRepository;

  const RecipeUseCases({
    required this.repository,
    required this.productRepository,
  });

  Recipe? getById(String id) {
    if (id.isEmpty) {
      throw ArgumentError('Recipe ID cannot be empty.');
    }
    return repository.getById(id);
  }

  List<Recipe> getAll() {
    return List.unmodifiable(repository.getAll());
  }

  /// Simpan resep. Seluruh productId bahan harus merujuk Product nyata.
  Future<void> create(Recipe recipe) async {
    _validateProductReferences(recipe);
    await repository.save(recipe);
  }

  /// Perbarui resep (menggantikan seluruh komposisi).
  Future<void> update(Recipe recipe) async {
    _validateProductReferences(recipe);
    await repository.update(recipe);
  }

  void _validateProductReferences(Recipe recipe) {
    for (final item in recipe.items) {
      if (productRepository.getById(item.productId) == null) {
        throw ArgumentError(
            'Product tidak ditemukan: ${item.productId}.');
      }
    }

    final outputProductId = recipe.outputProductId;
    if (outputProductId != null &&
        productRepository.getById(outputProductId) == null) {
      throw ArgumentError(
          'Produk hasil tidak ditemukan: $outputProductId.');
    }
  }
}
