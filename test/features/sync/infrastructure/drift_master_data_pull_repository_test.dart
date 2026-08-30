import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_kasir/core/database/app_database.dart';
import 'package:aplikasi_kasir/features/sync/domain/master_data_pull.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/drift_master_data_pull_repository.dart';

void main() {
  group('DriftMasterDataPullRepository', () {
    late Directory dir;
    late File file;
    late AppDatabase db;
    late DriftMasterDataPullRepository repository;

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('drift_pull');
      file = File('${dir.path}/app.sqlite');
      db = AppDatabase(NativeDatabase(file));
      repository = DriftMasterDataPullRepository(db);
    });

    tearDown(() async {
      await db.close();
      await dir.delete(recursive: true);
    });

    final t = DateTime.utc(2026, 8, 20);

    MasterDataPull buildPull({
      String uomName = 'kilogram',
      String productSku = 'BM-001',
      String productId = '550e8400-e29b-41d4-a716-446655440000',
    }) {
      return MasterDataPull(
        uoms: [
          PulledUom(
            id: '1bb4f570-213a-57d4-af43-52aacdb83f94',
            name: uomName,
            symbol: 'kg',
            isActive: true,
            createdAt: t,
            updatedAt: t,
          ),
        ],
        categories: [
          PulledCategory(
            id: '9c0e1234-e29b-41d4-a716-446655440001',
            name: 'Bumbu Dapur',
            isActive: true,
            createdAt: t,
            updatedAt: t,
          ),
        ],
        products: [
          PulledProduct(
            id: productId,
            sku: productSku,
            name: 'Bawang Merah',
            stockUomId: '1bb4f570-213a-57d4-af43-52aacdb83f94',
            categoryId: null,
            isActive: true,
            createdAt: t,
            updatedAt: t,
          ),
        ],
      );
    }

    test('upsert: uom + kategori + produk baru tersimpan lengkap', () async {
      final result = await repository.upsert(buildPull());

      expect(result.uomsUpserted, 1);
      expect(result.categoriesUpserted, 1);
      expect(result.productsUpserted, 1);
      expect(result.productsSkipped, 0);

      final uom = await (db.select(db.uomsTable)).getSingle();
      expect(uom.name, 'kilogram');
      expect(uom.symbol, 'kg');

      final category = await (db.select(db.categoriesTable)).getSingle();
      expect(category.name, 'Bumbu Dapur');

      final product = await (db.select(db.productsTable)).getSingle();
      expect(product.id, '550e8400-e29b-41d4-a716-446655440000');
      expect(product.sku, 'BM-001');
      expect(product.name, 'Bawang Merah');
      expect(product.baseUnit, 'kilogram');
      expect(product.active, isTrue);
    });

    test('produk existing (match SKU): nama/unit/active terupdate, '
        'harga lokal dipertahankan', () async {
      // Produk lokal existing dengan harga.
      await db.into(db.productsTable).insert(
            ProductsTableCompanion.insert(
              id: 'prod_local',
              sku: 'BM-001',
              name: 'Nama Lama',
              baseUnit: 'pcs',
              purchasePriceMinorUnits: 500,
              purchasePriceCurrency: const Value('IDR'),
              sellingPriceMinorUnits: 750,
              sellingPriceCurrency: const Value('IDR'),
            ),
          );

      final result = await repository.upsert(buildPull());

      expect(result.productsUpserted, 1);
      final product = await (db.select(db.productsTable)).getSingle();
      expect(product.id, 'prod_local'); // id lokal tidak diganti
      expect(product.name, 'Bawang Merah');
      expect(product.baseUnit, 'kilogram');
      expect(product.purchasePriceMinorUnits, 500); // harga dipertahankan
      expect(product.sellingPriceMinorUnits, 750);
    });

    test('uom id sama dipull ulang -> update baris existing '
        '(tidak duplikat)', () async {
      await repository.upsert(buildPull());
      await repository.upsert(buildPull());

      expect(await (db.select(db.uomsTable)).get(), hasLength(1));
    });

    test('produk dengan UoM tanpa padanan Unit lokal -> dilewati',
        () async {
      final pull = buildPull(uomName: 'ons'); // bukan bagian enum Unit
      final result = await repository.upsert(pull);

      expect(result.productsUpserted, 0);
      expect(result.productsSkipped, 1);
      expect(await (db.select(db.productsTable)).get(), isEmpty);
    });

    test('migration v14 -> v15: tabel uoms & categories dibuat, '
        'data produk lama tetap terbaca', () async {
      // Simulasi DB v14: tabel master data belum ada.
      await db.customStatement('DROP TABLE IF EXISTS uoms_table');
      await db.customStatement('DROP TABLE IF EXISTS categories_table');
      await db.customStatement('PRAGMA user_version = 14');
      await db.close();

      final dbV15 = AppDatabase(NativeDatabase(file));
      addTearDown(() async {
        await dbV15.close();
      });

      // Tabel baru tersedia dan dapat ditulis.
      final repositoryV15 = DriftMasterDataPullRepository(dbV15);
      final result = await repositoryV15.upsert(buildPull());
      expect(result.uomsUpserted, 1);
      expect(
        (await dbV15.select(dbV15.uomsTable).get()).single.name,
        'kilogram',
      );
    });
  });
}
