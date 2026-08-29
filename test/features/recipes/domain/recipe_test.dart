import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/recipes/domain/recipe.dart';

void main() {
  group('Recipe - validasi domain', () {
    RecipeItem item(String productId, {int value = 1, int scale = 0}) {
      return RecipeItem(
        productId: productId,
        quantityRequired: Quantity(value: value, scale: scale),
      );
    }

    Recipe buildRecipe({List<RecipeItem>? items}) {
      return Recipe(
        id: 'rec_1',
        name: 'Bumbu Utama',
        items: items ?? [item('bawang_merah', value: 6)],
        expectedOutputQuantity: Quantity(value: 182, scale: 1),
      );
    }

    test('recipe valid dengan scale bahan campuran', () {
      final recipe = buildRecipe(items: [
        item('bawang_merah', value: 6, scale: 0),
        item('bawang_putih', value: 24, scale: 1),
        item('ajinomoto', value: 60, scale: 3),
      ]);

      expect(recipe.items, hasLength(3));
      expect(recipe.items[0].quantityRequired, Quantity(value: 6, scale: 0));
      expect(recipe.items[1].quantityRequired, Quantity(value: 24, scale: 1));
      expect(recipe.items[2].quantityRequired, Quantity(value: 60, scale: 3));
      expect(recipe.expectedOutputQuantity, Quantity(value: 182, scale: 1));
    });

    test('dua bahan dengan productId sama ditolak', () {
      expect(
        () => buildRecipe(items: [
          item('bawang_merah'),
          item('bawang_merah'),
        ]),
        throwsArgumentError,
      );
    });

    test('item kosong / output nol ditolak', () {
      expect(() => buildRecipe(items: []), throwsArgumentError);
      expect(
        () => Recipe(
          id: 'rec_1',
          name: 'X',
          items: [item('a')],
          expectedOutputQuantity: Quantity.zero(),
        ),
        throwsArgumentError,
      );
    });
  });
}
