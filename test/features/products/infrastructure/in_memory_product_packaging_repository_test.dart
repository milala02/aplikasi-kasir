import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/products/domain/product_packaging.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/in_memory_product_packaging_repository.dart';

void main() {
  group('InMemoryProductPackagingRepository', () {
    test('save dan filter by productId', () async {
      final repository = InMemoryProductPackagingRepository();

      await repository.save(
        ProductPackaging(
          id: 'pack_001',
          productId: 'prod_100',
          fromUnit: Unit.box,
          toUnit: Unit.pcs,
          multiplierValue: 24,
          divisorValue: 1,
        ),
      );
      await repository.save(
        ProductPackaging(
          id: 'pack_002',
          productId: 'prod_200',
          fromUnit: Unit.carton,
          toUnit: Unit.box,
          multiplierValue: 10,
          divisorValue: 1,
        ),
      );

      expect(repository.getAll(), hasLength(2));
      expect(repository.getByProductId('prod_100'), hasLength(1));
      expect(repository.getByProductId('prod_200').single.fromUnit,
          Unit.carton);
    });

    test('id duplikat ditolak', () async {
      final repository = InMemoryProductPackagingRepository();
      final packaging = ProductPackaging(
        id: 'pack_001',
        productId: 'prod_100',
        fromUnit: Unit.box,
        toUnit: Unit.pcs,
        multiplierValue: 24,
        divisorValue: 1,
      );

      await repository.save(packaging);
      await expectLater(
        repository.save(packaging),
        throwsArgumentError,
      );
    });
  });
}
