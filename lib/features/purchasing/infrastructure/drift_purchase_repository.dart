import 'package:drift/drift.dart' as d;

import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../../core/unit/unit.dart';
import '../domain/purchase.dart';
import '../domain/purchase_item.dart';
import '../domain/purchase_repository.dart';

class DriftPurchaseRepository implements PurchaseRepository {
  final AppDatabase db;

  DriftPurchaseRepository(this.db);

  @override
  Future<Purchase?> getById(String id) async {
    final row = await (db.select(db.purchasesTable)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();

    if (row == null) {
      return null;
    }

    return _toDomain(row, await _loadItems(row.id));
  }

  @override
  Future<Purchase?> getByReferenceNumber(String referenceNumber) async {
    final row = await (db.select(db.purchasesTable)
          ..where((table) => table.referenceNumber.equals(referenceNumber)))
        .getSingleOrNull();

    if (row == null) {
      return null;
    }

    return _toDomain(row, await _loadItems(row.id));
  }

  @override
  Future<List<Purchase>> getAll() async {
    final rows = await db.select(db.purchasesTable).get();
    final items = await db.select(db.purchaseItemsTable).get();

    return rows
        .map(
          (row) => _toDomain(
            row,
            items.where((item) => item.purchaseId == row.id).toList(),
          ),
        )
        .toList();
  }

  @override
  Future<void> save(Purchase purchase) async {
    final existing = await (db.select(db.purchasesTable)
          ..where((table) => table.id.equals(purchase.id)))
        .getSingleOrNull();

    if (existing != null) {
      throw StateError(
        'Purchase with id "${purchase.id}" already exists.',
      );
    }

    await db.transaction(() async {
      await db.into(db.purchasesTable).insert(
            PurchasesTableCompanion.insert(
              id: purchase.id,
              purchasedAt: purchase.purchasedAt,
              supplierId: d.Value(purchase.supplierId),
              referenceNumber: d.Value(purchase.referenceNumber),
            ),
          );

      for (final item in purchase.items) {
        await db.into(db.purchaseItemsTable).insert(
              PurchaseItemsTableCompanion.insert(
                id: item.id,
                purchaseId: purchase.id,
                productId: item.productId,
                quantityValue: item.quantity.value,
                quantityScale: d.Value(item.quantity.scale),
                unit: d.Value(item.unit.name),
                unitCostMinorUnits: item.unitCost.minorUnits,
                unitCostCurrency: d.Value(item.unitCost.currency),
              ),
            );
      }
    });
  }

  @override
  Future<void> update(Purchase purchase) async {
    final existing = await (db.select(db.purchasesTable)
          ..where((table) => table.id.equals(purchase.id)))
        .getSingleOrNull();

    if (existing == null) {
      throw StateError(
        'Purchase with id "${purchase.id}" does not exist.',
      );
    }

    await db.transaction(() async {
      await db.update(db.purchasesTable).replace(
            PurchasesTableData(
              id: purchase.id,
              purchasedAt: purchase.purchasedAt,
              supplierId: purchase.supplierId,
              referenceNumber: purchase.referenceNumber,
              // Pertahankan flag CDC saat update.
              isSynced: existing.isSynced,
              syncedAt: existing.syncedAt,
            ),
          );

      await (db.delete(db.purchaseItemsTable)
            ..where((table) => table.purchaseId.equals(purchase.id)))
          .go();

      for (final item in purchase.items) {
        await db.into(db.purchaseItemsTable).insert(
              PurchaseItemsTableCompanion.insert(
                id: item.id,
                purchaseId: purchase.id,
                productId: item.productId,
                quantityValue: item.quantity.value,
                quantityScale: d.Value(item.quantity.scale),
                unit: d.Value(item.unit.name),
                unitCostMinorUnits: item.unitCost.minorUnits,
                unitCostCurrency: d.Value(item.unitCost.currency),
              ),
            );
      }
    });
  }

  @override
  Future<void> deleteById(String id) async {
    final existing = await (db.select(db.purchasesTable)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();

    if (existing == null) {
      throw StateError(
        'Purchase with id "$id" does not exist.',
      );
    }

    await db.transaction(() async {
      await (db.delete(db.purchaseItemsTable)
            ..where((table) => table.purchaseId.equals(id)))
          .go();
      await (db.delete(db.purchasesTable)
            ..where((table) => table.id.equals(id)))
          .go();
    });
  }

  Future<List<PurchaseItemsTableData>> _loadItems(String purchaseId) async {
    return (db.select(db.purchaseItemsTable)
          ..where((table) => table.purchaseId.equals(purchaseId)))
        .get();
  }

  Purchase _toDomain(
    PurchasesTableData row,
    List<PurchaseItemsTableData> itemRows,
  ) {
    return Purchase(
      id: row.id,
      purchasedAt: row.purchasedAt,
      supplierId: row.supplierId,
      referenceNumber: row.referenceNumber,
      items: itemRows.map(_itemToDomain).toList(),
    );
  }

  PurchaseItem _itemToDomain(PurchaseItemsTableData row) {
    return PurchaseItem(
      id: row.id,
      productId: row.productId,
      quantity: Quantity(
        value: row.quantityValue,
        scale: row.quantityScale,
      ),
      // Fallback eksplisit untuk baris legacy tanpa kolom unit.
      unit: row.unit == null
          ? Unit.pcs
          : Unit.values.firstWhere(
              (u) => u.name == row.unit,
              orElse: () =>
                  throw StateError('Unknown unit: ${row.unit}'),
            ),
      unitCost: Money(
        minorUnits: row.unitCostMinorUnits,
        currency: row.unitCostCurrency,
      ),
    );
  }
}
