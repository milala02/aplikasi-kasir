import 'recipe.dart';

abstract interface class RecipeRepository {
  Recipe? getById(String id);

  List<Recipe> getAll();

  Future<void> save(Recipe recipe);

  Future<void> update(Recipe recipe);
}
