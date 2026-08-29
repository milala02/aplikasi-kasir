import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_kasir/core/database/app_database.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/recipes/domain/recipe.dart';
import 'package:aplikasi_kasir/features/recipes/infrastructure/drift_recipe_repository.dart';

void main() {
  group('DriftRecipeRepository', () {
    Recipe buildRecipe({String id = 'rec_1'}) {
      return Recipe(
        id: id,
        name: 'Bumbu Utama',
        items: [
          RecipeItem(
            productId: 'prod_bawang_merah',
            quantityRequired: Quantity(value: 6, scale: 0),
          ),
          RecipeItem(
            productId: 'prod_bawang_putih',
            quantityRequired: Quantity(value: 24, scale: 1), // 2,4 kg
          ),
          RecipeItem(
            productId: 'prod_ajinomoto',
            quantityRequired: Quantity(value: 60, scale: 3), // 60 g
          ),
        ],
        expectedOutputQuantity: Quantity(value: 182, scale: 1), // 18,2 kg
      );
    }

    test('save -> getById round-trip dengan scale kg/g utuh', () async {
      final dir = await Directory.systemTemp.createTemp('drift_recipe');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final repository = DriftRecipeRepository(db);
      await repository.init();
      await repository.save(buildRecipe());

      final fetched = repository.getById('rec_1');
      expect(fetched, isNotNull);
      expect(fetched!.name, 'Bumbu Utama');
      expect(fetched.items, hasLength(3));
      expect(fetched.items[0].quantityRequired, Quantity(value: 6, scale: 0));
      expect(fetched.items[1].quantityRequired, Quantity(value: 24, scale: 1));
      expect(fetched.items[2].quantityRequired, Quantity(value: 60, scale: 3));
      expect(
          fetched.expectedOutputQuantity, Quantity(value: 182, scale: 1));
    });

    test('update menggantikan komposisi dan persist', () async {
      final dir = await Directory.systemTemp.createTemp('drift_recipe_upd');
      final file = File('${dir.path}/app.sqlite');
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
        await dir.delete(recursive: true);
      });

      final repository = DriftRecipeRepository(db);
      await repository.init();
      await repository.save(buildRecipe());

      final updated = Recipe(
        id: 'rec_1',
        name: 'Bumbu Utama v2',
        items: [
          RecipeItem(
            productId: 'prod_bawang_merah',
            quantityRequired: Quantity(value: 7, scale: 0),
          ),
        ],
        expectedOutputQuantity: Quantity(value: 182, scale: 1),
      );
      await repository.update(updated);

      final reloaded = DriftRecipeRepository(db);
      await reloaded.init();

      final fetched = reloaded.getById('rec_1');
      expect(fetched!.name, 'Bumbu Utama v2');
      expect(fetched.items, hasLength(1));
      expect(fetched.items.single.quantityRequired, Quantity(value: 7, scale: 0));
    });

    test('migration v8 -> v9 membuat tabel resep', () async {
      final dir = await Directory.systemTemp.createTemp('drift_recipe_mig');
      final file = File('${dir.path}/app.sqlite');
      addTearDown(() async {
        await dir.delete(recursive: true);
      });

      // Simulasi DB v8: tanpa tabel resep.
      final initialDb = AppDatabase(NativeDatabase(file));
      await initialDb.customStatement('DROP TABLE IF EXISTS recipe_items_table');
      await initialDb.customStatement('DROP TABLE IF EXISTS recipes_table');
      await initialDb.customStatement('PRAGMA user_version = 8');
      await initialDb.close();

      // Buka ulang: migrasi v8 -> v9 membuat tabel resep.
      final db = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await db.close();
      });

      final repository = DriftRecipeRepository(db);
      await repository.init();
      await repository.save(buildRecipe());

      expect(repository.getById('rec_1'), isNotNull);
      expect(repository.getById('rec_1')!.items, hasLength(3));
    });
  });
}
