import '../domain/receiving.dart';
import '../domain/receiving_repository.dart';

class InMemoryReceivingRepository implements ReceivingRepository {
  final Map<String, Receiving> _receivings = {};

  @override
  Future<Receiving?> getById(String id) async {
    return _receivings[id];
  }

  @override
  Future<List<Receiving>> getAll() async => _receivings.values.toList();

  @override
  Future<List<Receiving>> getByPurchaseId(String purchaseId) async {
    return _receivings.values
        .where((receiving) => receiving.purchaseId == purchaseId)
        .toList();
  }

  @override
  Future<void> save(Receiving receiving) async {
    _receivings[receiving.id] = receiving;
  }

  void clear() {
    _receivings.clear();
  }
}
