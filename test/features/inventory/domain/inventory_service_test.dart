import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/inventory_service.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_ledger.dart';

void main() {
  group('InventoryService', () {
    const productId = 'product-001';
    final occurredAt = DateTime(2026, 8, 18, 10, 0);

    InventoryService createService() {
      return InventoryService(
        ledger: StockLedger(
          productId: productId,
        ),
      );
    }

    test('starts with zero balance', () {
      final service = createService();

      expect(service.balance, Quantity.zero());
    });

    test('receives stock and increases balance', () {
      final service = createService();

      final updated = service.receiveStock(
        movementId: 'movement-001',
        quantity: Quantity(value: 10),
        occurredAt: occurredAt,
      );

      expect(updated.balance, Quantity(value: 10));
      expect(service.balance, Quantity.zero());
    });

    test('sells stock and decreases balance', () {
      final service = createService()
          .receiveStock(
            movementId: 'movement-001',
            quantity: Quantity(value: 10),
            occurredAt: occurredAt,
          );

      final updated = service.sellStock(
        movementId: 'movement-002',
        quantity: Quantity(value: 3),
        occurredAt: occurredAt,
      );

      expect(updated.balance, Quantity(value: 7));
      expect(service.balance, Quantity(value: 10));
    });

    test('rejects selling more stock than available', () {
      final service = createService()
          .receiveStock(
            movementId: 'movement-001',
            quantity: Quantity(value: 5),
            occurredAt: occurredAt,
          );

      expect(
        () => service.sellStock(
          movementId: 'movement-002',
          quantity: Quantity(value: 6),
          occurredAt: occurredAt,
        ),
        throwsArgumentError,
      );
    });

    test('rejects zero quantity when receiving stock', () {
      final service = createService();

      expect(
        () => service.receiveStock(
          movementId: 'movement-001',
          quantity: Quantity.zero(),
          occurredAt: occurredAt,
        ),
        throwsArgumentError,
      );
    });

    test('rejects zero quantity when selling stock', () {
      final service = createService();

      expect(
        () => service.sellStock(
          movementId: 'movement-001',
          quantity: Quantity.zero(),
          occurredAt: occurredAt,
        ),
        throwsArgumentError,
      );
    });

    test('preserves reference id on received movement', () {
      final service = createService();

      final updated = service.receiveStock(
        movementId: 'movement-001',
        quantity: Quantity(value: 10),
        occurredAt: occurredAt,
        referenceId: 'purchase-001',
      );

      expect(
        updated.ledger.movements.single.referenceId,
        'purchase-001',
      );
    });

    test('preserves reference id on sold movement', () {
      final service = createService()
          .receiveStock(
            movementId: 'movement-001',
            quantity: Quantity(value: 10),
            occurredAt: occurredAt,
          );

      final updated = service.sellStock(
        movementId: 'movement-002',
        quantity: Quantity(value: 3),
        occurredAt: occurredAt,
        referenceId: 'sale-001',
      );

      expect(
        updated.ledger.movements.last.referenceId,
        'sale-001',
      );
    });

    test('rejects duplicate movement id', () {
      final service = createService()
          .receiveStock(
            movementId: 'movement-001',
            quantity: Quantity(value: 10),
            occurredAt: occurredAt,
          );

      expect(
        () => service.receiveStock(
          movementId: 'movement-001',
          quantity: Quantity(value: 5),
          occurredAt: occurredAt,
        ),
        throwsArgumentError,
      );
    });


    test('adjusts stock upward', () {
      final service = createService();

      final updated = service.adjustStockIncrease(
        movementId: 'movement-adjust-in',
        quantity: Quantity(value: 7),
        occurredAt: occurredAt,
        referenceId: 'adjustment-001',
      );

      expect(updated.balance, Quantity(value: 7));
      expect(
        updated.ledger.movements.single.type,
        StockMovementType.adjustmentIncrease,
      );
      expect(
        updated.ledger.movements.single.referenceId,
        'adjustment-001',
      );
    });

    test('adjusts stock downward', () {
      final service = createService().receiveStock(
        movementId: 'movement-001',
        quantity: Quantity(value: 10),
        occurredAt: occurredAt,
      );

      final updated = service.adjustStockDecrease(
        movementId: 'movement-002',
        quantity: Quantity(value: 4),
        occurredAt: occurredAt,
        referenceId: 'adjustment-002',
      );

      expect(updated.balance, Quantity(value: 6));
      expect(
        updated.ledger.movements.last.type,
        StockMovementType.adjustmentDecrease,
      );
    });

    test('records damaged stock as a decrease', () {
      final service = createService().receiveStock(
        movementId: 'movement-001',
        quantity: Quantity(value: 10),
        occurredAt: occurredAt,
      );

      final updated = service.recordDamage(
        movementId: 'movement-002',
        quantity: Quantity(value: 2),
        occurredAt: occurredAt,
        referenceId: 'damage-001',
      );

      expect(updated.balance, Quantity(value: 8));
      expect(
        updated.ledger.movements.last.type,
        StockMovementType.damage,
      );
      expect(
        updated.ledger.movements.last.referenceId,
        'damage-001',
      );
    });

    test('records stock return in as an increase', () {
      final service = createService();

      final updated = service.returnStockIn(
        movementId: 'movement-return-in',
        quantity: Quantity(value: 3),
        occurredAt: occurredAt,
        referenceId: 'return-001',
      );

      expect(updated.balance, Quantity(value: 3));
      expect(
        updated.ledger.movements.single.type,
        StockMovementType.returnIn,
      );
    });

    test('records stock return out as a decrease', () {
      final service = createService().receiveStock(
        movementId: 'movement-001',
        quantity: Quantity(value: 10),
        occurredAt: occurredAt,
      );

      final updated = service.returnStockOut(
        movementId: 'movement-002',
        quantity: Quantity(value: 3),
        occurredAt: occurredAt,
        referenceId: 'return-002',
      );

      expect(updated.balance, Quantity(value: 7));
      expect(
        updated.ledger.movements.last.type,
        StockMovementType.returnOut,
      );
    });

    test('rejects decreasing stock below zero', () {
      final service = createService().receiveStock(
        movementId: 'movement-001',
        quantity: Quantity(value: 5),
        occurredAt: occurredAt,
      );

      expect(
        () => service.adjustStockDecrease(
          movementId: 'movement-002',
          quantity: Quantity(value: 6),
          occurredAt: occurredAt,
        ),
        throwsArgumentError,
      );
    });

    test('does not modify the original service', () {
      final service = createService();

      final updated = service.adjustStockIncrease(
        movementId: 'movement-001',
        quantity: Quantity(value: 5),
        occurredAt: occurredAt,
      );

      expect(service.balance, Quantity.zero());
      expect(service.ledger.movements, isEmpty);
      expect(updated.balance, Quantity(value: 5));
    });

    test('supports quantities with different scales', () {
      final service = createService()
          .receiveStock(
            movementId: 'movement-001',
            quantity: Quantity(value: 1),
            occurredAt: occurredAt,
          );

      final updated = service.sellStock(
        movementId: 'movement-002',
        quantity: Quantity(
          value: 500,
          scale: 3,
        ),
        occurredAt: occurredAt,
      );

      expect(
        updated.balance,
        Quantity(
          value: 500,
          scale: 3,
        ),
      );
    });
  });
}
