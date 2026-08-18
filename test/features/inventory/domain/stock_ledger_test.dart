import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_ledger.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';

void main() {
  group('StockLedger', () {
    const productId = 'product-001';
    final occurredAt = DateTime(2026, 8, 18, 10, 0);

    StockMovement movement({
      required String id,
      required int quantity,
      required StockMovementType type,
      String movementProductId = productId,
    }) {
      return StockMovement(
        id: id,
        productId: movementProductId,
        quantity: Quantity(
          value: quantity,
        ),
        type: type,
        occurredAt: occurredAt,
      );
    }

    test('empty ledger has zero balance', () {
      const ledger = StockLedger(
        productId: productId,
      );

      expect(
        ledger.calculateBalance(),
        Quantity.zero(),
      );
    });

    test('calculates stock from movements', () {
      var ledger = StockLedger(
        productId: productId,
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-001',
          quantity: 50,
          type: StockMovementType.purchase,
        ),
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-002',
          quantity: 10,
          type: StockMovementType.sale,
        ),
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-003',
          quantity: 2,
          type: StockMovementType.damage,
        ),
      );

      expect(
        ledger.calculateBalance(),
        Quantity(
          value: 38,
        ),
      );
    });

    test('supports stock adjustment', () {
      var ledger = StockLedger(
        productId: productId,
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-001',
          quantity: 20,
          type: StockMovementType.purchase,
        ),
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-002',
          quantity: 5,
          type: StockMovementType.adjustmentDecrease,
        ),
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-003',
          quantity: 3,
          type: StockMovementType.adjustmentIncrease,
        ),
      );

      expect(
        ledger.calculateBalance(),
        Quantity(
          value: 18,
        ),
      );
    });

    test('does not modify the original ledger', () {
      const original = StockLedger(
        productId: productId,
      );

      final updated = original.addMovement(
        movement(
          id: 'movement-001',
          quantity: 10,
          type: StockMovementType.purchase,
        ),
      );

      expect(original.movements, isEmpty);
      expect(updated.movements, hasLength(1));
      expect(updated.productId, productId);
    });

    test('rejects zero quantity movement', () {
      const ledger = StockLedger(
        productId: productId,
      );

      expect(
        () => ledger.addMovement(
          movement(
            id: 'movement-001',
            quantity: 0,
            type: StockMovementType.purchase,
          ),
        ),
        throwsArgumentError,
      );
    });

    test('supports quantities with different scales', () {
      var ledger = StockLedger(
        productId: productId,
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-001',
          quantity: 10,
          type: StockMovementType.purchase,
        ),
      );

      ledger = ledger.addMovement(
        StockMovement(
          id: 'movement-002',
          productId: productId,
          quantity: Quantity(
            value: 500,
            scale: 3,
          ),
          type: StockMovementType.sale,
          occurredAt: occurredAt,
        ),
      );

      expect(
        ledger.calculateBalance(),
        Quantity(
          value: 9500,
          scale: 3,
        ),
      );
    });

    test('rejects selling more stock than available', () {
      var ledger = StockLedger(
        productId: productId,
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-001',
          quantity: 5,
          type: StockMovementType.purchase,
        ),
      );

      expect(
        () => ledger.addMovement(
          movement(
            id: 'movement-002',
            quantity: 6,
            type: StockMovementType.sale,
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects empty ledger product id', () {
      expect(
        () => StockLedger(productId: ''),
        throwsArgumentError,
      );
    });

    test('rejects empty stock movement id', () {
      expect(
        () => StockMovement(
          id: '',
          productId: productId,
          quantity: Quantity(value: 1),
          type: StockMovementType.purchase,
          occurredAt: occurredAt,
        ),
        throwsArgumentError,
      );
    });

    test('rejects duplicate movement id', () {
      var ledger = StockLedger(
        productId: productId,
      );

      ledger = ledger.addMovement(
        movement(
          id: 'movement-001',
          quantity: 10,
          type: StockMovementType.purchase,
        ),
      );

      expect(
        () => ledger.addMovement(
          movement(
            id: 'movement-001',
            quantity: 5,
            type: StockMovementType.purchase,
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects movement from another product', () {
      const ledger = StockLedger(
        productId: productId,
      );

      expect(
        () => ledger.addMovement(
          movement(
            id: 'movement-001',
            quantity: 10,
            type: StockMovementType.purchase,
            movementProductId: 'product-002',
          ),
        ),
        throwsArgumentError,
      );
    });

    test('rejects mixed products already present in ledger', () {
      final ledger = StockLedger(
        productId: productId,
        movements: [
          movement(
            id: 'movement-001',
            quantity: 10,
            type: StockMovementType.purchase,
          ),
          movement(
            id: 'movement-002',
            quantity: 5,
            type: StockMovementType.sale,
            movementProductId: 'product-002',
          ),
        ],
      );

      expect(
        () => ledger.calculateBalance(),
        throwsArgumentError,
      );
    });
  });
}
