import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase.dart';
import 'package:aplikasi_kasir/features/purchasing/domain/purchase_repository.dart';

void main() {
  test('PurchaseRepository can be implemented', () {
    final repository = _FakePurchaseRepository();

    expect(repository, isA<PurchaseRepository>());
  });
}

class _FakePurchaseRepository implements PurchaseRepository {
  @override
  Future<Purchase?> getById(String id) async => null;

  @override
  Future<Purchase?> getByReferenceNumber(String referenceNumber) async => null;

  @override
  Future<List<Purchase>> getAll() async => [];

  @override
  Future<void> save(Purchase purchase) async {}

  @override
  Future<void> update(Purchase purchase) async {}

  @override
  Future<void> deleteById(String id) async {}
}
