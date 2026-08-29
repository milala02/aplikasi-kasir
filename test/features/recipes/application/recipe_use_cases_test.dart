import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/in_memory_product_repository.dart';
import 'package:aplikasi_kasir/features/recipes/application/recipe_use_cases.dart';
import 'package:aplikasi_kasir/features/recipes/domain/recipe.dart';
import 'package:aplikasi_kasir/features/recipes/infrastructure/in_memory_recipe_repository.dart';

void main() {
  group('RecipeUseCases', () {
    late InMemoryRecipeRepository recipeRepo;
    late InMemoryProductRepository productRepo;
    late RecipeUseCases useCases;

    setUp(() {
      recipeRepo = InMemoryRecipeRepository();
      productRepo = InMemoryProductRepository();
      useCases = RecipeUseCases(
        repository: recipeRepo,
        productRepository: productRepo,
      );

      productRepo.save(
        const Product(
          id: 'prod_100',
          sku: 'BM-001',
          name: 'Bawang Merah',
          baseUnit: Unit.kilogram,
          purchasePrice: Money(minorUnits: 1000000, currency: 'IDR'),
          sellingPrice: Money(minorUnits: 1500000, currency: 'IDR'),
        ),
      );
      productRepo.save(
        const Product(
          id: 'prod_200',
          sku: 'BP-001',
          name: 'Bawang Putih',
          baseUnit: Unit.kilogram,
          purchasePrice: Money(minorUnits: 1000000, currency: 'IDR'),
          sellingPrice: Money(minorUnits: 1500000, currency: 'IDR'),
        ),
      );
    });

    Recipe buildRecipe({List<RecipeItem>? items}) {
      return Recipe(
        id: 'rec_1',
        name: 'Bumbu Utama',
        items: items ??
            [
              RecipeItem(
                productId: 'prod_100',
                quantityRequired: Quantity(value: 6, scale: 0),
              ),
            ],
        expectedOutputQuantity: Quantity(value: 182, scale: 1),
      );
    }

    test('create resep valid dengan productId nyata tersimpan', () async {
      await useCases.create(buildRecipe());

      expect(recipeRepo.getById('rec_1'), isNotNull);
      expect(recipeRepo.getById('rec_1')!.items.single.productId, 'prod_100');
    });

    test('productId bahan tidak dikenal ditolak dan tidak tersimpan',
        () async {
      final invalid = buildRecipe(items: [
        RecipeItem(
          productId: 'ghost_product',
          quantityRequired: Quantity(value: 6, scale: 0),
        ),
      ]);

      await expectLater(
        useCases.create(invalid),
        throwsArgumentError,
      );

      expect(recipeRepo.getAll(), isEmpty);
    });

    test('update menggantikan komposisi dan tersimpan', () async {
      await useCases.create(buildRecipe());

      final updated = Recipe(
        id: 'rec_1',
        name: 'Bumbu Utama',
        items: [
          RecipeItem(
            productId: 'prod_200',
            quantityRequired: Quantity(value: 24, scale: 1),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 182, scale: 1),
      );
      await useCases.update(updated);

      expect(recipeRepo.getById('rec_1')!.items.single.productId, 'prod_200');
      expect(
        recipeRepo.getById('rec_1')!.items.single.quantityRequired,
        Quantity(value: 24, scale: 1),
      );
    });

    test('outputProductId valid tersimpan', () async {
      final recipe = Recipe(
        id: 'rec_2',
        name: 'Bumbu Utama',
        items: [
          RecipeItem(
            productId: 'prod_100',
            quantityRequired: Quantity(value: 6, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 182, scale: 1),
        outputProductId: 'prod_200',
      );

      await useCases.create(recipe);

      expect(recipeRepo.getById('rec_2')!.outputProductId, 'prod_200');
    });

    test('outputProductId tak dikenal ditolak dan tidak tersimpan',
        () async {
      final recipe = Recipe(
        id: 'rec_3',
        name: 'Bumbu Utama',
        items: [
          RecipeItem(
            productId: 'prod_100',
            quantityRequired: Quantity(value: 6, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 182, scale: 1),
        outputProductId: 'ghost_output',
      );

      await expectLater(
        useCases.create(recipe),
        throwsArgumentError,
      );

      expect(recipeRepo.getById('rec_3'), isNull);
    });
  });
}
