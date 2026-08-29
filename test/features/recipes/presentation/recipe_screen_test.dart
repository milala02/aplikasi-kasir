import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/in_memory_product_repository.dart';
import 'package:aplikasi_kasir/features/recipes/application/recipe_use_cases.dart';
import 'package:aplikasi_kasir/features/recipes/infrastructure/in_memory_recipe_repository.dart';
import 'package:aplikasi_kasir/features/recipes/presentation/recipe_screen.dart';

void main() {
  group('RecipeScreen - kelola resep', () {
    late InMemoryProductRepository productRepo;
    late InMemoryRecipeRepository recipeRepo;
    late RecipeUseCases useCases;

    setUp(() {
      productRepo = InMemoryProductRepository();
      recipeRepo = InMemoryRecipeRepository();
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

    Widget buildApp() {
      return MaterialApp(
        home: RecipeScreen(
          recipeUseCases: useCases,
          productRepository: productRepo,
        ),
      );
    }

    Future<void> fillOutput(WidgetTester tester) async {
      await tester.enterText(
          find.byKey(const Key('recipe_name_field')), 'Bumbu Utama');
      await tester.enterText(
          find.byKey(const Key('recipe_output_value_field')), '182');
    }

    Future<void> addItemRow(WidgetTester tester, int index) async {
      await tester.tap(find.byKey(const Key('recipe_add_item_button')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(Key('recipe_item_product_field_$index')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bawang Merah').last);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(Key('recipe_item_qty_field_$index')), '6');
    }

    testWidgets('membuat resep valid -> tersimpan dengan scale benar',
        (tester) async {
      await tester.pumpWidget(buildApp());

      await tester.tap(find.byKey(const Key('recipe_add_fab')));
      await tester.pumpAndSettle();

      await fillOutput(tester);
      await addItemRow(tester, 0);

      await tester.tap(find.byKey(const Key('recipe_save_button')));
      await tester.pumpAndSettle();

      expect(recipeRepo.getAll(), hasLength(1));
      final recipe = recipeRepo.getAll().first;
      expect(recipe.name, 'Bumbu Utama');
      expect(recipe.items.single.productId, 'prod_100');
      expect(recipe.items.single.quantityRequired.value, 6);
      expect(recipe.expectedOutputQuantity.value, 182);
      expect(recipe.expectedOutputQuantity.scale, 1);
    });

    testWidgets('dua bahan dengan produk sama -> ditolak dengan pesan error',
        (tester) async {
      await tester.pumpWidget(buildApp());

      await tester.tap(find.byKey(const Key('recipe_add_fab')));
      await tester.pumpAndSettle();

      await fillOutput(tester);
      await addItemRow(tester, 0);
      await addItemRow(tester, 1);

      await tester.tap(find.byKey(const Key('recipe_save_button')));
      await tester.pumpAndSettle();

      expect(find.textContaining('duplicate'), findsOneWidget);
      expect(recipeRepo.getAll(), isEmpty);
    });

    testWidgets('form tanpa bahan -> validasi UI menolak', (tester) async {
      await tester.pumpWidget(buildApp());

      await tester.tap(find.byKey(const Key('recipe_add_fab')));
      await tester.pumpAndSettle();

      await fillOutput(tester);

      await tester.tap(find.byKey(const Key('recipe_save_button')));
      await tester.pumpAndSettle();

      // Recipe tanpa bahan ditolak validasi UI.
      expect(find.textContaining('minimal memiliki satu bahan'), findsOneWidget);
      expect(recipeRepo.getAll(), isEmpty);
    });
  });
}
