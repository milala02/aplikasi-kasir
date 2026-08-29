import '../domain/recipe.dart';
import '../domain/recipe_repository.dart';

class InMemoryRecipeRepository implements RecipeRepository {
  final Map<String, Recipe> _recipes = {};

  @override
  Recipe? getById(String id) => _recipes[id];

  @override
  List<Recipe> getAll() => List.unmodifiable(_recipes.values);

  @override
  Future<void> save(Recipe recipe) async {
    if (_recipes.containsKey(recipe.id)) {
      throw ArgumentError('Recipe ID already exists.');
    }
    _recipes[recipe.id] = recipe;
  }

  @override
  Future<void> update(Recipe recipe) async {
    if (!_recipes.containsKey(recipe.id)) {
      throw ArgumentError('Recipe not found.');
    }
    _recipes[recipe.id] = recipe;
  }
}
