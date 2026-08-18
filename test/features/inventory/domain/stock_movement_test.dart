import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/stock_movement.dart';

void main() {
  group('StockMovement', () {
    final occurredAt = DateTime(2026, 8, 18, 10, 0);

    test('purchase increases stock', () {
      final movement = StockMovement(
        id: 'movement-001',
        productId: 'product-001',
        quantity: Quantity(
          value: 10,
        ),
        type: StockMovementType.purchase,
        occurredAt: occurredAt,
      );

      expect(movement.isIncrease, isTrue);
    });

    test('sale decreases stock', () {
      final movement = StockMovement(
        id: 'movement-002',
        productId: 'product-001',
        quantity: Quantity(
          value: 3,
        ),
        type: StockMovementType.sale,
        occurredAt: occurredAt,
      );

      expect(movement.isIncrease, isFalse);
    });

    test('damage decreases stock', () {
      final movement = StockMovement(
        id: 'movement-003',
        productId: 'product-001',
        quantity: Quantity(
          value: 2,
        ),
        type: StockMovementType.damage,
        occurredAt: occurredAt,
      );

      expect(movement.isIncrease, isFalse);
    });

    test('return in increases stock', () {
      final movement = StockMovement(
        id: 'movement-004',
        productId: 'product-001',
        quantity: Quantity(
          value: 1,
        ),
        type: StockMovementType.returnIn,
        occurredAt: occurredAt,
      );

      expect(movement.isIncrease, isTrue);
    });
  });
}
