import 'package:drift/drift.dart' as d;

import '../../../core/database/app_database.dart';
import '../../../core/quantity/quantity.dart';
import '../domain/recipe.dart';
import '../domain/recipe_repository.dart';

class DriftRecipeRepository implements RecipeRepository {
  final AppDatabase db;
  final Map<String, Recipe> _cache = {};

  DriftRecipeRepository(this.db);

  /// Muat semua resep + item dari DB ke dalam cache.
  Future<void> init() async {
    final recipeRows = await db.select(db.recipesTable).get();
    final itemRows = await db.select(db.recipeItemsTable).get();

    _cache.clear();
    for (final row in recipeRows) {
      final items = itemRows
          .where((i) => i.recipeId == row.id)
          .map(
            (i) => RecipeItem(
              productId: i.productId,
              quantityRequired: Quantity(
                value: i.quantityValue,
                scale: i.quantityScale,
              ),
            ),
          )
          .toList();

      if (items.isEmpty) continue; // Recipe tanpa item tidak valid.

      final recipe = Recipe(
        id: row.id,
        name: row.name,
        items: items,
        expectedOutputQuantity: Quantity(
          value: row.expectedOutputValue,
          scale: row.expectedOutputScale,
        ),
      );
      _cache[recipe.id] = recipe;
    }
  }

  @override
  Recipe? getById(String id) => _cache[id];

  @override
  List<Recipe> getAll() => List.unmodifiable(_cache.values);

  @override
  Future<void> save(Recipe recipe) async {
    if (_cache.containsKey(recipe.id)) {
      throw ArgumentError('Recipe ID already exists.');
    }

    await db.transaction(() async {
      await db.into(db.recipesTable).insert(
            RecipesTableCompanion.insert(
              id: recipe.id,
              name: recipe.name,
              expectedOutputValue: recipe.expectedOutputQuantity.value,
              expectedOutputScale: d.Value(recipe.expectedOutputQuantity.scale),
            ),
          );

      for (final item in recipe.items) {
        await db.into(db.recipeItemsTable).insert(
              _itemCompanion(recipe.id, item),
            );
      }
    });

    _cache[recipe.id] = recipe;
  }

  @override
  Future<void> update(Recipe recipe) async {
    if (!_cache.containsKey(recipe.id)) {
      throw ArgumentError('Recipe not found.');
    }

    await db.transaction(() async {
      await db.update(db.recipesTable).replace(
            RecipesTableData(
              id: recipe.id,
              name: recipe.name,
              expectedOutputValue: recipe.expectedOutputQuantity.value,
              expectedOutputScale: recipe.expectedOutputQuantity.scale,
            ),
          );

      await (db.delete(db.recipeItemsTable)
            ..where((t) => t.recipeId.equals(recipe.id)))
          .go();

      for (final item in recipe.items) {
        await db.into(db.recipeItemsTable).insert(
              _itemCompanion(recipe.id, item),
            );
      }
    });

    _cache[recipe.id] = recipe;
  }

  RecipeItemsTableCompanion _itemCompanion(String recipeId, RecipeItem item) {
    return RecipeItemsTableCompanion.insert(
      id: '${recipeId}_${item.productId}',
      recipeId: recipeId,
      productId: item.productId,
      quantityValue: item.quantityRequired.value,
      quantityScale: d.Value(item.quantityRequired.scale),
    );
  }
}
