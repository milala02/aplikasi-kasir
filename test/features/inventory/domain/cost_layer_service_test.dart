import 'package:test/test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer_service.dart';

void main() {
  group('CostLayerService', () {
    test('consumes cost layers using FIFO order', () {
      final repository = _FakeCostLayerRepository();

      final first = createLayer(
        id: 'layer-001',
        acquiredAt: DateTime(2026, 8, 1),
        quantity: Quantity(value: 10),
        unitCost: const Money(minorUnits: 10000, currency: 'IDR'),
      );

      final second = createLayer(
        id: 'layer-002',
        acquiredAt: DateTime(2026, 8, 2),
        quantity: Quantity(value: 5),
        unitCost: const Money(minorUnits: 12000, currency: 'IDR'),
      );

      repository.save(first);
      repository.save(second);

      final result = CostLayerService(repository: repository)
          .consume(productId: 'pepper', quantity: Quantity(value: 12));

      expect(
        result.totalCost,
        const Money(minorUnits: 124000, currency: 'IDR'),
      );

      expect(result.consumptions.map((item) => item.layerId), [
        'layer-001',
        'layer-002',
      ]);

      expect(result.consumptions.first.quantity, Quantity(value: 10));

      expect(result.consumptions.last.quantity, Quantity(value: 2));

      expect(
        repository.getById('layer-001')!.remainingQuantity,
        Quantity.zero(),
      );

      expect(
        repository.getById('layer-002')!.remainingQuantity,
        Quantity(value: 3),
      );
    });

    test('consumes fractional quantities across layers', () {
      final repository = _FakeCostLayerRepository();

      repository.save(
        createLayer(
          id: 'layer-001',
          acquiredAt: DateTime(2026, 8, 1),
          quantity: Quantity(value: 500, scale: 3),
          unitCost: const Money(minorUnits: 10000, currency: 'IDR'),
        ),
      );

      repository.save(
        createLayer(
          id: 'layer-002',
          acquiredAt: DateTime(2026, 8, 2),
          quantity: Quantity(value: 500, scale: 3),
          unitCost: const Money(minorUnits: 12000, currency: 'IDR'),
        ),
      );

      final result = CostLayerService(
        repository: repository,
      ).consume(productId: 'pepper', quantity: Quantity(value: 750, scale: 3));

      expect(result.totalCost, const Money(minorUnits: 8000, currency: 'IDR'));

      expect(
        result.consumptions.first.quantity,
        Quantity(value: 500, scale: 3),
      );

      expect(result.consumptions.last.quantity, Quantity(value: 250, scale: 3));

      expect(
        repository.getById('layer-001')!.remainingQuantity,
        Quantity.zero(scale: 3),
      );

      expect(
        repository.getById('layer-002')!.remainingQuantity,
        Quantity(value: 250, scale: 3),
      );
    });

    test('does not mutate any layer when stock is insufficient', () {
      final repository = _FakeCostLayerRepository();

      final first = createLayer(
        id: 'layer-001',
        acquiredAt: DateTime(2026, 8, 1),
        quantity: Quantity(value: 5),
        unitCost: const Money(minorUnits: 10000, currency: 'IDR'),
      );

      final second = createLayer(
        id: 'layer-002',
        acquiredAt: DateTime(2026, 8, 2),
        quantity: Quantity(value: 3),
        unitCost: const Money(minorUnits: 12000, currency: 'IDR'),
      );

      repository.save(first);
      repository.save(second);

      expect(
        () =>
            CostLayerService(repository: repository)
                .consume(productId: 'pepper', quantity: Quantity(value: 10)),
        throwsArgumentError,
      );

      expect(
        repository.getById('layer-001')!.remainingQuantity,
        Quantity(value: 5),
      );

      expect(
        repository.getById('layer-002')!.remainingQuantity,
        Quantity(value: 3),
      );
    });

    test('does not mutate any layer when currencies are incompatible', () {
      final repository = _FakeCostLayerRepository();

      final first = createLayer(
        id: 'layer-001',
        acquiredAt: DateTime(2026, 8, 1),
        quantity: Quantity(value: 5),
        unitCost: const Money(minorUnits: 10000, currency: 'IDR'),
      );

      final second = createLayer(
        id: 'layer-002',
        acquiredAt: DateTime(2026, 8, 2),
        quantity: Quantity(value: 5),
        unitCost: const Money(minorUnits: 2, currency: 'USD'),
      );

      repository.save(first);
      repository.save(second);

      expect(
        () =>
            CostLayerService(repository: repository)
                .consume(productId: 'pepper', quantity: Quantity(value: 6)),
        throwsArgumentError,
      );

      expect(
        repository.getById('layer-001')!.remainingQuantity,
        Quantity(value: 5),
      );

      expect(
        repository.getById('layer-002')!.remainingQuantity,
        Quantity(value: 5),
      );
    });

    test('uses layer id as deterministic FIFO tie breaker', () {
      final repository = _FakeCostLayerRepository();

      final laterId = createLayer(
        id: 'layer-002',
        acquiredAt: DateTime(2026, 8, 1),
        quantity: Quantity(value: 5),
        unitCost: const Money(minorUnits: 12000, currency: 'IDR'),
      );

      final earlierId = createLayer(
        id: 'layer-001',
        acquiredAt: DateTime(2026, 8, 1),
        quantity: Quantity(value: 5),
        unitCost: const Money(minorUnits: 10000, currency: 'IDR'),
      );

      repository.save(laterId);
      repository.save(earlierId);

      final result = CostLayerService(repository: repository)
          .consume(productId: 'pepper', quantity: Quantity(value: 3));

      expect(result.consumptions.first.layerId, 'layer-001');

      expect(result.totalCost, const Money(minorUnits: 30000, currency: 'IDR'));
    });

    test('rejects empty product id', () {
      expect(
        () =>
            CostLayerService(repository: _FakeCostLayerRepository())
                .consume(productId: '', quantity: Quantity(value: 1)),
        throwsArgumentError,
      );
    });

    test('rejects zero quantity', () {
      expect(
        () =>
            CostLayerService(repository: _FakeCostLayerRepository())
                .consume(productId: 'pepper', quantity: Quantity.zero()),
        throwsArgumentError,
      );
    });

    test('rejects consumption when no layer is available', () {
      expect(
        () =>
            CostLayerService(repository: _FakeCostLayerRepository())
                .consume(productId: 'pepper', quantity: Quantity(value: 1)),
        throwsStateError,
      );
    });
  });
}

CostLayer createLayer({
  required String id,
  required DateTime acquiredAt,
  required Quantity quantity,
  required Money unitCost,
}) {
  return CostLayer(
    id: id,
    productId: 'pepper',
    originalQuantity: quantity,
    remainingQuantity: quantity,
    unitCost: unitCost,
    acquiredAt: acquiredAt,
  );
}

class _FakeCostLayerRepository implements CostLayerRepository {
  final Map<String, CostLayer> _layers = {};

  @override
  CostLayer? getById(String id) => _layers[id];

  @override
  List<CostLayer> getByProductId(String productId) {
    return _layers.values
        .where((layer) => layer.productId == productId)
        .toList();
  }

  @override
  List<CostLayer> getAvailableByProductId(String productId) {
    return _layers.values
        .where((layer) => layer.productId == productId && layer.isAvailable)
        .toList();
  }

  @override
  void save(CostLayer layer) {
    _layers[layer.id] = layer;
  }

  @override
  void update(CostLayer layer) {
    _layers[layer.id] = layer;
  }
}
