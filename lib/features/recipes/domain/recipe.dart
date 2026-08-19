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

  Recipe({
    required this.id,
    required this.name,
    required this.items,
    required this.expectedOutputQuantity,
  }) {
    if (id.isEmpty) throw ArgumentError('Recipe ID cannot be empty.');
    if (name.isEmpty) throw ArgumentError('Recipe name cannot be empty.');
    if (items.isEmpty) throw ArgumentError('Recipe items cannot be empty.');
    if (expectedOutputQuantity.isZero) {
      throw ArgumentError('Recipe expected output quantity cannot be zero.');
    }
  }
}
