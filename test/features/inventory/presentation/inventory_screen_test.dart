import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/presentation/inventory_screen.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/in_memory_product_repository.dart';

void main() {
  group('InventoryScreen - selektor produk nyata', () {
    late InMemoryCostLayerRepository costLayerRepo;
    late InMemoryProductRepository productRepo;

    setUp(() {
      costLayerRepo = InMemoryCostLayerRepository();
      productRepo = InMemoryProductRepository();

      productRepo.save(
        const Product(
          id: 'prod_100',
          sku: 'BM-001',
          name: 'Bawang Merah',
          baseUnit: Unit.kilogram,
          purchasePrice: Money(minorUnits: 0, currency: 'IDR'),
          sellingPrice: Money(minorUnits: 0, currency: 'IDR'),
        ),
      );
      productRepo.save(
        const Product(
          id: 'prod_200',
          sku: 'BP-001',
          name: 'Bawang Putih',
          baseUnit: Unit.kilogram,
          purchasePrice: Money(minorUnits: 0, currency: 'IDR'),
          sellingPrice: Money(minorUnits: 0, currency: 'IDR'),
        ),
      );
    });

    Widget buildApp() {
      return MaterialApp(
        home: InventoryScreen(
          costLayerRepository: costLayerRepo,
          productRepository: productRepo,
        ),
      );
    }

    testWidgets('tanpa produk/fallback ID buatan — tidak crash, tampil kosong',
        (tester) async {
      await tester.pumpWidget(buildApp());

      // Tidak ada hardcoded 'lada_biji'; produk pertama terpilih dan
      // empty-state ditampilkan.
      expect(find.textContaining('Bawang Merah'), findsWidgets);
      expect(
        find.text('Belum ada stok layer aktif untuk produk ini.'),
        findsOneWidget,
      );
    });

    testWidgets('ganti produk di dropdown memuat layer produk tersebut',
        (tester) async {
      await tester.pumpWidget(buildApp());

      await tester.tap(find.byKey(const Key('inventory_product_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bawang Putih').last);
      await tester.pumpAndSettle();

      expect(find.textContaining('Bawang Putih'), findsWidgets);
    });
  });
}
