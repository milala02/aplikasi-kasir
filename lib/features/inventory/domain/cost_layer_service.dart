import '../../../core/money/money.dart';
import '../../../core/quantity/quantity.dart';
import 'cost_layer.dart';
import 'cost_layer_repository.dart';

class CostLayerService {
  final CostLayerRepository repository;

  const CostLayerService({required this.repository});

  CostConsumption consume({
    required String productId,
    required Quantity quantity,
  }) {
    if (productId.isEmpty) {
      throw ArgumentError('Product ID cannot be empty.');
    }

    if (quantity.isZero) {
      throw ArgumentError('Consumed quantity must be positive.');
    }

    final layers =
        List<CostLayer>.from(repository.getAvailableByProductId(productId))
          ..sort((a, b) {
            final acquired = a.acquiredAt.compareTo(b.acquiredAt);

            if (acquired != 0) {
              return acquired;
            }

            return a.id.compareTo(b.id);
          });

    if (layers.isEmpty) {
      throw StateError('No available cost layer for product "$productId".');
    }

    var remaining = quantity;
    Money? totalCost;
    final updates = <CostLayer>[];
    final consumptions = <CostLayerConsumption>[];

    for (final layer in layers) {
      if (remaining.isZero) {
        break;
      }

      final commonScale = _maxScale(
        remaining.scale,
        layer.remainingQuantity.scale,
      );

      final requestedValue = _scaleTo(remaining, commonScale);

      final availableValue = _scaleTo(layer.remainingQuantity, commonScale);

      final consumedValue = requestedValue < availableValue
          ? requestedValue
          : availableValue;

      if (consumedValue <= 0) {
        continue;
      }

      final consumedQuantity = Quantity(
        value: consumedValue,
        scale: commonScale,
      );

      final updatedLayer = layer.consume(consumedQuantity);

      final layerCost = Money(
        minorUnits:
            layer.unitCost.minorUnits *
            consumedQuantity.value ~/
            _scaleFactor(consumedQuantity.scale),
        currency: layer.unitCost.currency,
      );

      totalCost = totalCost == null ? layerCost : totalCost.add(layerCost);

      updates.add(updatedLayer);
      consumptions.add(
        CostLayerConsumption(
          layerId: layer.id,
          quantity: consumedQuantity,
          unitCost: layer.unitCost,
          cost: layerCost,
        ),
      );

      remaining = Quantity(
        value: requestedValue - consumedValue,
        scale: commonScale,
      );
    }

    if (!remaining.isZero) {
      throw ArgumentError(
        'Insufficient stock in cost layers for product "$productId".',
      );
    }

    // All validation and costing has completed successfully.
    // Only now mutate the repository.
    for (final updatedLayer in updates) {
      repository.update(updatedLayer);
    }

    return CostConsumption(
      quantity: quantity,
      totalCost: totalCost!,
      consumptions: List.unmodifiable(consumptions),
    );
  }

  static int _maxScale(int first, int second) {
    return first > second ? first : second;
  }

  static int _scaleTo(Quantity quantity, int targetScale) {
    if (quantity.scale == targetScale) {
      return quantity.value;
    }

    return quantity.value * _scaleFactor(targetScale - quantity.scale);
  }

  static int _scaleFactor(int scale) {
    var result = 1;

    for (var i = 0; i < scale; i++) {
      result *= 10;
    }

    return result;
  }
}

class CostConsumption {
  final Quantity quantity;
  final Money totalCost;
  final List<CostLayerConsumption> consumptions;

  const CostConsumption({
    required this.quantity,
    required this.totalCost,
    required this.consumptions,
  });

  List<String> get consumedLayerIds {
    return consumptions.map((item) => item.layerId).toList();
  }
}

class CostLayerConsumption {
  final String layerId;
  final Quantity quantity;
  final Money unitCost;
  final Money cost;

  const CostLayerConsumption({
    required this.layerId,
    required this.quantity,
    required this.unitCost,
    required this.cost,
  });
}
