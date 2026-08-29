import 'package:drift/drift.dart' as d;

import '../../../core/database/app_database.dart';
import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import '../domain/cost_layer.dart';
import '../domain/cost_layer_repository.dart';

class DriftCostLayerRepository implements CostLayerRepository {
  final AppDatabase db;

  DriftCostLayerRepository(this.db);

  @override
  Future<CostLayer?> getById(String id) async {
    final row = await (db.select(db.costLayersTable)
          ..where((table) => table.id.equals(id)))
        .getSingleOrNull();

    return row == null ? null : _toDomain(row);
  }

  @override
  Future<List<CostLayer>> getByProductId(String productId) async {
    final rows = await (db.select(db.costLayersTable)
          ..where((table) => table.productId.equals(productId)))
        .get();

    return rows.map(_toDomain).toList();
  }

  @override
  Future<List<CostLayer>> getAvailableByProductId(
    String productId,
  ) async {
    final rows = await (db.select(db.costLayersTable)
          ..where(
            (table) =>
                table.productId.equals(productId) &
                table.remainingQuantityValue.isBiggerThanValue(0),
          ))
        .get();

    return rows.map(_toDomain).toList();
  }

  @override
  Future<void> save(CostLayer layer) async {
    await db.into(db.costLayersTable).insertOnConflictUpdate(
          CostLayersTableCompanion.insert(
            id: layer.id,
            productId: layer.productId,
            originalQuantityValue: layer.originalQuantity.value,
            originalQuantityScale: layer.originalQuantity.scale,
            remainingQuantityValue: layer.remainingQuantity.value,
            remainingQuantityScale: layer.remainingQuantity.scale,
            unitCostMinorUnits: layer.unitCost.minorUnits,
            unitCostCurrency: d.Value(layer.unitCost.currency),
            acquiredAt: layer.acquiredAt,
            purchaseId: d.Value(layer.purchaseId),
          ),
        );
  }

  @override
  Future<void> update(CostLayer layer) async {
    await db.update(db.costLayersTable).replace(
          CostLayersTableData(
            id: layer.id,
            productId: layer.productId,
            originalQuantityValue: layer.originalQuantity.value,
            originalQuantityScale: layer.originalQuantity.scale,
            remainingQuantityValue: layer.remainingQuantity.value,
            remainingQuantityScale: layer.remainingQuantity.scale,
            unitCostMinorUnits: layer.unitCost.minorUnits,
            unitCostCurrency: layer.unitCost.currency,
            acquiredAt: layer.acquiredAt,
            purchaseId: layer.purchaseId,
          ),
        );
  }

  CostLayer _toDomain(CostLayersTableData row) {
    return CostLayer(
      id: row.id,
      productId: row.productId,
      originalQuantity: Quantity(
        value: row.originalQuantityValue,
        scale: row.originalQuantityScale,
      ),
      remainingQuantity: Quantity(
        value: row.remainingQuantityValue,
        scale: row.remainingQuantityScale,
      ),
      unitCost: Money(
        minorUnits: row.unitCostMinorUnits,
        currency: row.unitCostCurrency,
      ),
      acquiredAt: row.acquiredAt,
      purchaseId: row.purchaseId,
    );
  }
}
