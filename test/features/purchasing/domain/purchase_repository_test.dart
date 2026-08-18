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
  Purchase? getById(String id) => null;

  @override
  Purchase? getByReferenceNumber(String referenceNumber) => null;

  @override
  List<Purchase> getAll() => [];

  @override
  void save(Purchase purchase) {}

  @override
  void update(Purchase purchase) {}

  @override
  void deleteById(String id) {}
}
