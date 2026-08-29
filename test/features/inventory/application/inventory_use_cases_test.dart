import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/application/inventory_use_cases.dart';
import 'package:aplikasi_kasir/features/inventory/domain/inventory_repository.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_ledger.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';

void main() {
  group('InventoryUseCases', () {
    test('returns null for unknown ledger', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      expect(await useCases.getLedger('product-001'), isNull);
    });

    test('returns empty movements for unknown product', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      expect(await useCases.getMovements('product-001'), isEmpty);
    });

    test('returns zero balance when ledger does not exist', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      expect(await useCases.getBalance('product-001'), Quantity.zero());
    });

    test('receiveStock creates a ledger and records movement', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);
      final occurredAt = DateTime(2026, 1, 1);

      await useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 10),
        occurredAt: occurredAt,
      );

      expect(await useCases.getBalance('product-001'), Quantity(value: 10));
      expect(
        await useCases.getMovements('product-001'),
        hasLength(1),
      );
      expect(repository.recordedMovements, hasLength(1));
      expect(
        repository.recordedMovements.first.type,
        StockMovementType.purchase,
      );
    });

    test('sellStock decreases existing stock', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);
      final occurredAt = DateTime(2026, 1, 1);

      await useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 10),
        occurredAt: occurredAt,
      );

      await useCases.sellStock(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 3),
        occurredAt: occurredAt,
      );

      expect(await useCases.getBalance('product-001'), Quantity(value: 7));
      expect(repository.recordedMovements, hasLength(2));
    });

    test('adjustStockIncrease increases stock', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      await useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 5),
        occurredAt: DateTime(2026, 1, 1),
      );

      await useCases.adjustStockIncrease(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 2),
        occurredAt: DateTime(2026, 1, 2),
      );

      expect(await useCases.getBalance('product-001'), Quantity(value: 7));
    });

    test('adjustStockDecrease decreases stock', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      await useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 8),
        occurredAt: DateTime(2026, 1, 1),
      );

      await useCases.adjustStockDecrease(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 2),
        occurredAt: DateTime(2026, 1, 2),
      );

      expect(await useCases.getBalance('product-001'), Quantity(value: 6));
    });

    test('recordDamage decreases stock', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      await useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 8),
        occurredAt: DateTime(2026, 1, 1),
      );

      await useCases.recordDamage(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 1),
        occurredAt: DateTime(2026, 1, 2),
      );

      expect(await useCases.getBalance('product-001'), Quantity(value: 7));
    });

    test('returnStockIn increases stock', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      await useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 5),
        occurredAt: DateTime(2026, 1, 1),
      );

      await useCases.returnStockIn(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 2),
        occurredAt: DateTime(2026, 1, 2),
      );

      expect(await useCases.getBalance('product-001'), Quantity(value: 7));
    });

    test('returnStockOut decreases stock', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      await useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 5),
        occurredAt: DateTime(2026, 1, 1),
      );

      await useCases.returnStockOut(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 2),
        occurredAt: DateTime(2026, 1, 2),
      );

      expect(await useCases.getBalance('product-001'), Quantity(value: 3));
    });

    test('throws when selling without an existing ledger', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      expect(
        () => useCases.sellStock(
          productId: 'product-001',
          movementId: 'movement-001',
          quantity: Quantity(value: 1),
          occurredAt: DateTime(2026, 1, 1),
        ),
        throwsArgumentError,
      );
    });

    test('preserves reference id on recorded movement', () async {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      await useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 5),
        occurredAt: DateTime(2026, 1, 1),
        referenceId: 'purchase-001',
      );

      expect(
        repository.recordedMovements.first.referenceId,
        'purchase-001',
      );
    });
  });
}

class _FakeInventoryRepository implements InventoryRepository {
  final Map<String, StockLedger> _ledgers = {};
  final List<StockMovement> recordedMovements = [];

  @override
  Future<StockLedger?> getLedger(String productId) async {
    return _ledgers[productId];
  }

  @override
  Future<List<StockMovement>> getMovements(String productId) async {
    return List.unmodifiable(
      recordedMovements.where(
        (movement) => movement.productId == productId,
      ),
    );
  }

  @override
  Future<void> saveLedger(StockLedger ledger) async {
    _ledgers[ledger.productId] = ledger;
  }

  @override
  Future<void> recordMovement(StockMovement movement) async {
    recordedMovements.add(movement);
  }
}
