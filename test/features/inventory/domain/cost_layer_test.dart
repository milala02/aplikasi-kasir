import 'package:test/test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';

void main() {
  group('CostLayer', () {
    test('creates an available cost layer', () {
      final layer = createLayer();

      expect(layer.id, 'layer-001');
      expect(layer.productId, 'pepper');
      expect(layer.originalQuantity, Quantity(value: 1));
      expect(layer.remainingQuantity, Quantity(value: 1));
      expect(layer.unitCost, const Money(minorUnits: 160000, currency: 'IDR'));
      expect(layer.isAvailable, isTrue);
      expect(layer.isDepleted, isFalse);
    });

    test('rejects remaining quantity greater than original quantity', () {
      expect(
        () => CostLayer(
          id: 'layer-invalid',
          productId: 'pepper',
          originalQuantity: Quantity(value: 1),
          remainingQuantity: Quantity(value: 2),
          unitCost: const Money(minorUnits: 160000, currency: 'IDR'),
          acquiredAt: DateTime(2026, 8, 18),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('calculates original total cost', () {
      final layer = createLayer(
        originalQuantity: Quantity(value: 500, scale: 3),
      );

      expect(
        layer.originalTotalCost,
        const Money(minorUnits: 80000, currency: 'IDR'),
      );
    });

    test('calculates remaining value', () {
      final layer = createLayer(
        originalQuantity: Quantity(value: 1),
        remainingQuantity: Quantity(value: 500, scale: 3),
      );

      expect(
        layer.remainingValue,
        const Money(minorUnits: 80000, currency: 'IDR'),
      );
    });

    test('consume returns a new layer with reduced quantity', () {
      final layer = createLayer(
        originalQuantity: Quantity(value: 1),
        remainingQuantity: Quantity(value: 1),
      );

      final consumed = layer.consume(Quantity(value: 250, scale: 3));

      expect(consumed.remainingQuantity, Quantity(value: 750, scale: 3));

      expect(consumed.originalQuantity, Quantity(value: 1));

      expect(consumed.id, layer.id);
      expect(consumed.productId, layer.productId);
      expect(consumed.unitCost, layer.unitCost);
      expect(consumed.acquiredAt, layer.acquiredAt);
      expect(consumed.purchaseId, layer.purchaseId);

      expect(layer.remainingQuantity, Quantity(value: 1));
    });

    test('can consume the entire remaining quantity', () {
      final layer = createLayer(
        originalQuantity: Quantity(value: 500, scale: 3),
        remainingQuantity: Quantity(value: 500, scale: 3),
      );

      final consumed = layer.consume(Quantity(value: 500, scale: 3));

      expect(consumed.remainingQuantity.isZero, isTrue);
      expect(consumed.isDepleted, isTrue);
      expect(consumed.isAvailable, isFalse);
    });

    test('supports quantities with different scales', () {
      final layer = createLayer(
        originalQuantity: Quantity(value: 1),
        remainingQuantity: Quantity(value: 1),
      );

      final consumed = layer.consume(Quantity(value: 500, scale: 3));

      expect(consumed.remainingQuantity, Quantity(value: 500, scale: 3));
    });

    test('rejects zero consumption', () {
      final layer = createLayer();

      expect(() => layer.consume(Quantity.zero()), throwsArgumentError);
    });

    test('rejects consumption greater than remaining quantity', () {
      final layer = createLayer(
        remainingQuantity: Quantity(value: 250, scale: 3),
      );

      expect(
        () => layer.consume(Quantity(value: 500, scale: 3)),
        throwsArgumentError,
      );
    });

    test('rejects an empty layer id through assertion', () {
      expect(
        () => CostLayer(
          id: '',
          productId: 'pepper',
          originalQuantity: Quantity(value: 1),
          remainingQuantity: Quantity(value: 1),
          unitCost: const Money(minorUnits: 160000, currency: 'IDR'),
          acquiredAt: DateTime(2026, 8, 18),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects an empty product id through assertion', () {
      expect(
        () => CostLayer(
          id: 'layer-001',
          productId: '',
          originalQuantity: Quantity(value: 1),
          remainingQuantity: Quantity(value: 1),
          unitCost: const Money(minorUnits: 160000, currency: 'IDR'),
          acquiredAt: DateTime(2026, 8, 18),
        ),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects zero original quantity through assertion', () {
      expect(
        () => CostLayer(
          id: 'layer-001',
          productId: 'pepper',
          originalQuantity: Quantity.zero(),
          remainingQuantity: Quantity.zero(),
          unitCost: const Money(minorUnits: 160000, currency: 'IDR'),
          acquiredAt: DateTime(2026, 8, 18),
        ),
        throwsA(isA<AssertionError>()),
      );
    });
  });
}

CostLayer createLayer({
  Quantity? originalQuantity,
  Quantity? remainingQuantity,
}) {
  return CostLayer(
    id: 'layer-001',
    productId: 'pepper',
    originalQuantity: originalQuantity ?? Quantity(value: 1),
    remainingQuantity:
        remainingQuantity ?? originalQuantity ?? Quantity(value: 1),
    unitCost: const Money(minorUnits: 160000, currency: 'IDR'),
    acquiredAt: DateTime(2026, 8, 18),
    purchaseId: 'purchase-001',
  );
}
