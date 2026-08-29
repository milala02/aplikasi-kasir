import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';

void main() {
  group('InMemoryCostLayerRepository', () {
    test('saves and retrieves a cost layer by id', () async {
      final repository = InMemoryCostLayerRepository();
      final layer = createLayer();

      await repository.save(layer);

      expect(await repository.getById(layer.id), layer);
    });

    test('returns null when cost layer does not exist', () async {
      final repository = InMemoryCostLayerRepository();

      expect(await repository.getById('missing'), isNull);
    });

    test('gets all cost layers for a product', () async {
      final repository = InMemoryCostLayerRepository();

      final pepperOne = createLayer(id: 'layer-001', productId: 'pepper');
      final pepperTwo = createLayer(id: 'layer-002', productId: 'pepper');
      final onion = createLayer(id: 'layer-003', productId: 'onion');

      await repository.save(pepperOne);
      await repository.save(pepperTwo);
      await repository.save(onion);

      expect(await repository.getByProductId('pepper'), [pepperOne, pepperTwo]);
    });

    test('gets only available cost layers for a product', () async {
      final repository = InMemoryCostLayerRepository();

      final available = createLayer(
        id: 'layer-001',
        productId: 'pepper',
        remainingQuantity: Quantity(value: 1),
      );

      final depleted = createLayer(
        id: 'layer-002',
        productId: 'pepper',
        remainingQuantity: Quantity.zero(),
      );

      await repository.save(available);
      await repository.save(depleted);

      expect(await repository.getAvailableByProductId('pepper'), [available]);
    });

    test('does not return layers from another product', () async {
      final repository = InMemoryCostLayerRepository();

      final pepper = createLayer(id: 'layer-001', productId: 'pepper');

      final onion = createLayer(id: 'layer-002', productId: 'onion');

      await repository.save(pepper);
      await repository.save(onion);

      expect(await repository.getAvailableByProductId('pepper'), [pepper]);
    });

    test('rejects duplicate cost layer id on save', () async {
      final repository = InMemoryCostLayerRepository();

      await repository.save(createLayer(id: 'layer-001'));

      expect(
        () async => repository.save(createLayer(id: 'layer-001')),
        throwsStateError,
      );
    });

    test('updates an existing cost layer', () async {
      final repository = InMemoryCostLayerRepository();

      final original = createLayer(
        id: 'layer-001',
        remainingQuantity: Quantity(value: 1),
      );

      await repository.save(original);

      final updated = original.consume(Quantity(value: 250, scale: 3));

      await repository.update(updated);

      expect(await repository.getById('layer-001'), updated);
      expect(
        (await repository.getById('layer-001'))!.remainingQuantity,
        Quantity(value: 750, scale: 3),
      );
    });

    test('rejects updating a missing cost layer', () async {
      final repository = InMemoryCostLayerRepository();

      expect(
        () async => repository.update(createLayer(id: 'missing')),
        throwsStateError,
      );
    });
  });
}

CostLayer createLayer({
  String id = 'layer-001',
  String productId = 'pepper',
  Quantity? originalQuantity,
  Quantity? remainingQuantity,
}) {
  final original = originalQuantity ?? Quantity(value: 1);

  return CostLayer(
    id: id,
    productId: productId,
    originalQuantity: original,
    remainingQuantity: remainingQuantity ?? original,
    unitCost: const Money(minorUnits: 160000, currency: 'IDR'),
    acquiredAt: DateTime(2026, 8, 18),
    purchaseId: 'purchase-001',
  );
}
