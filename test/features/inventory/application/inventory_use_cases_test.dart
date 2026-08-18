import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/application/inventory_use_cases.dart';
import 'package:aplikasi_kasir/features/inventory/domain/inventory_repository.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_ledger.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';

void main() {
  group('InventoryUseCases', () {
    test('returns null for unknown ledger', () {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      expect(useCases.getLedger('product-001'), isNull);
    });

    test('returns empty movements for unknown product', () {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      expect(useCases.getMovements('product-001'), isEmpty);
    });

    test('returns zero balance when ledger does not exist', () {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      expect(useCases.getBalance('product-001'), Quantity.zero());
    });

    test('receiveStock creates a ledger and records movement', () {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);
      final occurredAt = DateTime(2026, 1, 1);

      useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 10),
        occurredAt: occurredAt,
      );

      expect(useCases.getBalance('product-001'), Quantity(value: 10));
      expect(
        useCases.getMovements('product-001'),
        hasLength(1),
      );
      expect(repository.recordedMovements, hasLength(1));
      expect(
        repository.recordedMovements.first.type,
        StockMovementType.purchase,
      );
    });

    test('sellStock decreases existing stock', () {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);
      final occurredAt = DateTime(2026, 1, 1);

      useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 10),
        occurredAt: occurredAt,
      );

      useCases.sellStock(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 3),
        occurredAt: occurredAt,
      );

      expect(useCases.getBalance('product-001'), Quantity(value: 7));
      expect(repository.recordedMovements, hasLength(2));
    });

    test('adjustStockIncrease increases stock', () {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 5),
        occurredAt: DateTime(2026, 1, 1),
      );

      useCases.adjustStockIncrease(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 2),
        occurredAt: DateTime(2026, 1, 2),
      );

      expect(useCases.getBalance('product-001'), Quantity(value: 7));
    });

    test('adjustStockDecrease decreases stock', () {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 8),
        occurredAt: DateTime(2026, 1, 1),
      );

      useCases.adjustStockDecrease(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 2),
        occurredAt: DateTime(2026, 1, 2),
      );

      expect(useCases.getBalance('product-001'), Quantity(value: 6));
    });

    test('recordDamage decreases stock', () {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 8),
        occurredAt: DateTime(2026, 1, 1),
      );

      useCases.recordDamage(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 1),
        occurredAt: DateTime(2026, 1, 2),
      );

      expect(useCases.getBalance('product-001'), Quantity(value: 7));
    });

    test('returnStockIn increases stock', () {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 5),
        occurredAt: DateTime(2026, 1, 1),
      );

      useCases.returnStockIn(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 2),
        occurredAt: DateTime(2026, 1, 2),
      );

      expect(useCases.getBalance('product-001'), Quantity(value: 7));
    });

    test('returnStockOut decreases stock', () {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      useCases.receiveStock(
        productId: 'product-001',
        movementId: 'movement-001',
        quantity: Quantity(value: 5),
        occurredAt: DateTime(2026, 1, 1),
      );

      useCases.returnStockOut(
        productId: 'product-001',
        movementId: 'movement-002',
        quantity: Quantity(value: 2),
        occurredAt: DateTime(2026, 1, 2),
      );

      expect(useCases.getBalance('product-001'), Quantity(value: 3));
    });

    test('throws when selling without an existing ledger', () {
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

    test('preserves reference id on recorded movement', () {
      final repository = _FakeInventoryRepository();
      final useCases = InventoryUseCases(repository: repository);

      useCases.receiveStock(
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
  StockLedger? getLedger(String productId) {
    return _ledgers[productId];
  }

  @override
  List<StockMovement> getMovements(String productId) {
    return List.unmodifiable(
      recordedMovements.where(
        (movement) => movement.productId == productId,
      ),
    );
  }

  @override
  void saveLedger(StockLedger ledger) {
    _ledgers[ledger.productId] = ledger;
  }

  @override
  void recordMovement(StockMovement movement) {
    recordedMovements.add(movement);
  }
}
