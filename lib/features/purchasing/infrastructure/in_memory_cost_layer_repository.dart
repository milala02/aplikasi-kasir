import '../domain/cost_layer.dart';
import '../domain/cost_layer_repository.dart';

class InMemoryCostLayerRepository implements CostLayerRepository {
  final Map<String, CostLayer> _layers = {};

  @override
  CostLayer? getById(String id) {
    return _layers[id];
  }

  @override
  List<CostLayer> getByProductId(String productId) {
    return _layers.values
        .where((layer) => layer.productId == productId)
        .toList();
  }

  @override
  List<CostLayer> getAvailableByProductId(String productId) {
    return _layers.values
        .where(
          (layer) =>
              layer.productId == productId && layer.isAvailable,
        )
        .toList();
  }

  @override
  void save(CostLayer layer) {
    if (_layers.containsKey(layer.id)) {
      throw StateError(
        'Cost layer with id "${layer.id}" already exists.',
      );
    }

    _layers[layer.id] = layer;
  }

  @override
  void update(CostLayer layer) {
    if (!_layers.containsKey(layer.id)) {
      throw StateError(
        'Cost layer with id "${layer.id}" does not exist.',
      );
    }

    _layers[layer.id] = layer;
  }
}
