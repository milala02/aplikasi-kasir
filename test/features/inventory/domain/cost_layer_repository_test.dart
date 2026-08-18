import 'package:test/test.dart';
import 'package:aplikasi_kasir/features/inventory/domain/cost_layer_repository.dart';

void main() {
  test('repository contract can be referenced', () {
    expect(CostLayerRepository, isNotNull);
  });
}
