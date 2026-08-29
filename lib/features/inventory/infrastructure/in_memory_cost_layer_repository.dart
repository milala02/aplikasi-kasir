import '../domain/cost_layer.dart';
import '../domain/cost_layer_repository.dart';

class InMemoryCostLayerRepository implements CostLayerRepository {
  final Map<String, CostLayer> _layers = {};

  @override
  Future<CostLayer?> getById(String id) async {
    return _layers[id];
  }

  @override
  Future<List<CostLayer>> getByProductId(String productId) async {
    return _layers.values
        .where((layer) => layer.productId == productId)
        .toList();
  }

  @override
  Future<List<CostLayer>> getAvailableByProductId(String productId) async {
    return _layers.values
        .where(
          (layer) => layer.productId == productId && layer.isAvailable,
        )
        .toList();
  }

  @override
  Future<void> save(CostLayer layer) async {
    if (_layers.containsKey(layer.id)) {
      throw StateError(
        'Cost layer with id "${layer.id}" already exists.',
      );
    }

    _layers[layer.id] = layer;
  }

  @override
  Future<void> update(CostLayer layer) async {
    if (!_layers.containsKey(layer.id)) {
      throw StateError(
        'Cost layer with id "${layer.id}" does not exist.',
      );
    }

    _layers[layer.id] = layer;
  }
}
