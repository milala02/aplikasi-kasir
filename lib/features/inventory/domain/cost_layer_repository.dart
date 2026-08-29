import 'cost_layer.dart';

abstract interface class CostLayerRepository {
  Future<CostLayer?> getById(String id);

  Future<List<CostLayer>> getByProductId(String productId);

  Future<List<CostLayer>> getAvailableByProductId(String productId);

  Future<void> save(CostLayer layer);

  Future<void> update(CostLayer layer);
}
