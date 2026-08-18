import 'package:test/test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';

void main() {
  group('InMemoryCostLayerRepository', () {
    test('saves and retrieves a cost layer by id', () {
      final repository = InMemoryCostLayerRepository();
      final layer = createLayer();

      repository.save(layer);

      expect(repository.getById(layer.id), layer);
    });

    test('returns null when cost layer does not exist', () {
      final repository = InMemoryCostLayerRepository();

      expect(repository.getById('missing'), isNull);
    });

    test('gets all cost layers for a product', () {
      final repository = InMemoryCostLayerRepository();

      final pepperOne = createLayer(id: 'layer-001', productId: 'pepper');
      final pepperTwo = createLayer(id: 'layer-002', productId: 'pepper');
      final onion = createLayer(id: 'layer-003', productId: 'onion');

      repository.save(pepperOne);
      repository.save(pepperTwo);
      repository.save(onion);

      expect(repository.getByProductId('pepper'), [pepperOne, pepperTwo]);
    });

    test('gets only available cost layers for a product', () {
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

      repository.save(available);
      repository.save(depleted);

      expect(repository.getAvailableByProductId('pepper'), [available]);
    });

    test('does not return layers from another product', () {
      final repository = InMemoryCostLayerRepository();

      final pepper = createLayer(id: 'layer-001', productId: 'pepper');

      final onion = createLayer(id: 'layer-002', productId: 'onion');

      repository.save(pepper);
      repository.save(onion);

      expect(repository.getAvailableByProductId('pepper'), [pepper]);
    });

    test('rejects duplicate cost layer id on save', () {
      final repository = InMemoryCostLayerRepository();

      repository.save(createLayer(id: 'layer-001'));

      expect(
        () => repository.save(createLayer(id: 'layer-001')),
        throwsStateError,
      );
    });

    test('updates an existing cost layer', () {
      final repository = InMemoryCostLayerRepository();

      final original = createLayer(
        id: 'layer-001',
        remainingQuantity: Quantity(value: 1),
      );

      repository.save(original);

      final updated = original.consume(Quantity(value: 250, scale: 3));

      repository.update(updated);

      expect(repository.getById('layer-001'), updated);
      expect(
        repository.getById('layer-001')!.remainingQuantity,
        Quantity(value: 750, scale: 3),
      );
    });

    test('rejects updating a missing cost layer', () {
      final repository = InMemoryCostLayerRepository();

      expect(
        () => repository.update(createLayer(id: 'missing')),
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
