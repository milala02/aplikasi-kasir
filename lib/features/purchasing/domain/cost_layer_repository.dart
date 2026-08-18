import 'cost_layer.dart';

abstract interface class CostLayerRepository {
  CostLayer? getById(String id);

  List<CostLayer> getByProductId(String productId);

  List<CostLayer> getAvailableByProductId(String productId);

  void save(CostLayer layer);

  void update(CostLayer layer);
}
