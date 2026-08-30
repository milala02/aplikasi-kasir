import 'package:drift/drift.dart' as d;

import '../../../core/database/app_database.dart';
import '../../../core/unit/unit.dart';
import '../domain/master_data_pull.dart';
import '../domain/master_data_pull_repository.dart';

/// Upsert master data pull ke SQLite:
/// - UoM & kategori: match by id (PK backend), insert/update.
/// - Produk: match by SKU (unique), insert baru / update nama, baseUnit,
///   active. Harga lokal (purchase/selling) tidak ditimpa untuk produk
///   existing dan default 0 untuk produk baru (backend tidak memuat
///   harga).
/// - Produk dengan UoM tanpa padanan Unit lokal dilewati (dihitung
///   di `productsSkipped`).
class DriftMasterDataPullRepository implements MasterDataPullRepository {
  final AppDatabase db;

  DriftMasterDataPullRepository(this.db);

  @override
  Future<MasterDataUpsertResult> upsert(MasterDataPull pull) async {
    var uomsUpserted = 0;
    var categoriesUpserted = 0;
    var productsUpserted = 0;
    var productsSkipped = 0;

    await db.transaction(() async {
      final uomById = <String, PulledUom>{};
      for (final uom in pull.uoms) {
        uomById[uom.id] = uom;
        await _upsertUom(uom);
        uomsUpserted++;
      }
      for (final category in pull.categories) {
        await _upsertCategory(category);
        categoriesUpserted++;
      }
      for (final product in pull.products) {
        final uom = uomById[product.stockUomId];
        final unit = _unitFor(uom?.name);
        if (unit == null) {
          // UoM tidak dikenal (bukan bagian dari enum Unit lokal):
          // lewati agar tidak mengarang satuan.
          productsSkipped++;
          continue;
        }
        await _upsertProduct(product, unit);
        productsUpserted++;
      }
    });

    return MasterDataUpsertResult(
      uomsUpserted: uomsUpserted,
      categoriesUpserted: categoriesUpserted,
      productsUpserted: productsUpserted,
      productsSkipped: productsSkipped,
    );
  }

  Future<void> _upsertUom(PulledUom uom) async {
    final existing = await (db.select(db.uomsTable)
          ..where((t) => t.id.equals(uom.id)))
        .getSingleOrNull();
    if (existing == null) {
      await db.into(db.uomsTable).insert(
            UomsTableCompanion.insert(
              id: uom.id,
              name: uom.name,
              symbol: uom.symbol,
              isActive: d.Value(uom.isActive),
              createdAt: uom.createdAt,
              updatedAt: uom.updatedAt,
            ),
          );
    } else {
      await db.update(db.uomsTable).replace(
            existing.copyWith(
              name: uom.name,
              symbol: uom.symbol,
              isActive: uom.isActive,
              updatedAt: uom.updatedAt,
            ),
          );
    }
  }

  Future<void> _upsertCategory(PulledCategory category) async {
    final existing = await (db.select(db.categoriesTable)
          ..where((t) => t.id.equals(category.id)))
        .getSingleOrNull();
    if (existing == null) {
      await db.into(db.categoriesTable).insert(
            CategoriesTableCompanion.insert(
              id: category.id,
              name: category.name,
              isActive: d.Value(category.isActive),
              createdAt: category.createdAt,
              updatedAt: category.updatedAt,
            ),
          );
    } else {
      await db.update(db.categoriesTable).replace(
            existing.copyWith(
              name: category.name,
              isActive: category.isActive,
              updatedAt: category.updatedAt,
            ),
          );
    }
  }

  Future<void> _upsertProduct(PulledProduct product, Unit unit) async {
    final existing = await (db.select(db.productsTable)
          ..where((t) => t.sku.equals(product.sku)))
        .getSingleOrNull();
    if (existing == null) {
      // Produk baru dari backend: id memakai UUID backend (passthrough
      // SyncUuid.entity) agar push berikutnya tetap stabil. Harga default
      // 0 (backend tidak memuat harga) — diisi pemilik secara lokal.
      await db.into(db.productsTable).insert(
            ProductsTableCompanion.insert(
              id: product.id,
              sku: product.sku,
              name: product.name,
              baseUnit: unit.name,
              purchasePriceMinorUnits: 0,
              purchasePriceCurrency: const d.Value('IDR'),
              sellingPriceMinorUnits: 0,
              sellingPriceCurrency: const d.Value('IDR'),
              active: d.Value(product.isActive),
            ),
          );
    } else {
      // Harga lokal dipertahankan; identitas master data mengikuti backend.
      await db.update(db.productsTable).replace(
            existing.copyWith(
              name: product.name,
              baseUnit: unit.name,
              active: product.isActive,
            ),
          );
    }
  }

  static Unit? _unitFor(String? uomName) {
    if (uomName == null) {
      return null;
    }
    for (final unit in Unit.values) {
      if (unit.name == uomName) {
        return unit;
      }
    }
    return null;
  }
}
