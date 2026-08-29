import '../../../core/quantity/quantity.dart';

class RecipeItem {
  final String productId;
  final Quantity quantityRequired;

  RecipeItem({
    required this.productId,
    required this.quantityRequired,
  }) {
    if (productId.isEmpty) {
      throw ArgumentError('Recipe item product ID cannot be empty.');
    }
    if (quantityRequired.isZero) {
      throw ArgumentError('Recipe item quantity required cannot be zero.');
    }
  }
}

class Recipe {
  final String id;
  final String name;
  final List<RecipeItem> items;
  final Quantity expectedOutputQuantity;

  /// Produk hasil produksi (Product nyata). Null untuk resep lama/komposisi
  /// tanpa produk hasil — resep tersebut tidak dapat dieksekusi produksi.
  final String? outputProductId;

  Recipe({
    required this.id,
    required this.name,
    required this.items,
    required this.expectedOutputQuantity,
    this.outputProductId,
  }) {
    if (id.isEmpty) throw ArgumentError('Recipe ID cannot be empty.');
    if (name.isEmpty) throw ArgumentError('Recipe name cannot be empty.');
    if (items.isEmpty) throw ArgumentError('Recipe items cannot be empty.');
    if (expectedOutputQuantity.isZero) {
      throw ArgumentError('Recipe expected output quantity cannot be zero.');
    }
    if (outputProductId != null && outputProductId!.isEmpty) {
      throw ArgumentError(
          'Recipe output product ID cannot be empty when provided.');
    }

    // Satu resep tidak boleh memuat dua item dengan productId sama
    // (konsisten dengan validasi Receiving/Order).
    final seenProductIds = <String>{};
    for (final item in items) {
      if (!seenProductIds.add(item.productId)) {
        throw ArgumentError(
            'Recipe cannot contain duplicate products (${item.productId}).');
      }
    }
  }
}
