import 'package:drift/drift.dart' as d;

import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../../../core/unit/unit.dart';
import '../domain/receiving.dart';
import '../domain/receiving_repository.dart';

class DriftReceivingRepository implements ReceivingRepository {
  final AppDatabase db;

  DriftReceivingRepository(this.db);

  @override
  Future<Receiving?> getById(String id) async {
    final row = await (db.select(db.receivingsTable)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();

    if (row == null) {
      return null;
    }

    return _toDomain(row, await _loadItems(row.id));
  }

  @override
  Future<List<Receiving>> getAll() async {
    final rows = await db.select(db.receivingsTable).get();
    final items = await db.select(db.receivingItemsTable).get();

    return rows
        .map(
          (row) => _toDomain(
            row,
            items.where((item) => item.receivingId == row.id).toList(),
          ),
        )
        .toList();
  }

  @override
  Future<List<Receiving>> getByPurchaseId(String purchaseId) async {
    final rows = await (db.select(db.receivingsTable)
          ..where((table) => table.purchaseId.equals(purchaseId)))
        .get();
    final items = await db.select(db.receivingItemsTable).get();

    return rows
        .map(
          (row) => _toDomain(
            row,
            items.where((item) => item.receivingId == row.id).toList(),
          ),
        )
        .toList();
  }

  @override
  Future<void> save(Receiving receiving) async {
    await db.transaction(() async {
      await db.into(db.receivingsTable).insert(
            ReceivingsTableCompanion.insert(
              id: receiving.id,
              purchaseId: receiving.purchaseId,
              receivedAt: receiving.receivedAt,
            ),
          );

      for (final item in receiving.items) {
        await db.into(db.receivingItemsTable).insert(
              ReceivingItemsTableCompanion.insert(
                id: item.id,
                receivingId: receiving.id,
                productId: item.productId,
                quantityValue: item.quantityReceived.value,
                quantityScale: d.Value(item.quantityReceived.scale),
                unit: d.Value(item.unit.name),
                unitCostMinorUnits: item.unitCost.minorUnits,
                unitCostCurrency: d.Value(item.unitCost.currency),
              ),
            );
      }
    });
  }

  Future<List<ReceivingItemsTableData>> _loadItems(String receivingId) async {
    return (db.select(db.receivingItemsTable)
          ..where((table) => table.receivingId.equals(receivingId)))
        .get();
  }

  Receiving _toDomain(
    ReceivingsTableData row,
    List<ReceivingItemsTableData> itemRows,
  ) {
    return Receiving(
      id: row.id,
      purchaseId: row.purchaseId,
      receivedAt: row.receivedAt,
      items: itemRows.map(_itemToDomain).toList(),
    );
  }

  ReceivingItem _itemToDomain(ReceivingItemsTableData row) {
    return ReceivingItem(
      id: row.id,
      productId: row.productId,
      quantityReceived: Quantity(
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
