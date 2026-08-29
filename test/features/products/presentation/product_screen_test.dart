import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/features/products/application/product_use_cases.dart';
import 'package:aplikasi_kasir/features/products/domain/product.dart';
import 'package:aplikasi_kasir/features/products/domain/product_repository.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/in_memory_product_repository.dart';
import 'package:aplikasi_kasir/features/products/presentation/product_screen.dart';

void main() {
  group('ProductScreen - pembuatan produk', () {
    testWidgets('produk valid -> tersimpan melalui ProductUseCases',
        (tester) async {
      final repo = InMemoryProductRepository();
      final useCases = ProductUseCases(repository: repo);

      await tester.pumpWidget(
        MaterialApp(home: ProductScreen(productUseCases: useCases)),
      );

      expect(find.text('Belum ada produk.'), findsOneWidget);

      await tester.tap(find.byKey(const Key('product_add_fab')));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('product_name_field')), 'Bawang Merah');
      await tester.enterText(
          find.byKey(const Key('product_sku_field')), 'BM-001');
      await tester.enterText(
          find.byKey(const Key('product_purchase_field')), '25000');
      await tester.enterText(
          find.byKey(const Key('product_selling_field')), '30000');

      await tester.tap(find.byKey(const Key('product_save_button')));
      await tester.pumpAndSettle();

      expect(repo.getAll(), hasLength(1));
      final product = repo.getAll().first;
      expect(product.name, 'Bawang Merah');
      expect(product.sku, 'BM-001');
      expect(product.purchasePrice.minorUnits, 2500000);
      expect(product.sellingPrice.minorUnits, 3000000);

      // List ter-refresh.
      expect(find.text('Bawang Merah'), findsOneWidget);
    });

    testWidgets('input tidak valid -> gagal tanpa persistence',
        (tester) async {
      final repo = InMemoryProductRepository();
      final useCases = ProductUseCases(repository: repo);

      await tester.pumpWidget(
        MaterialApp(home: ProductScreen(productUseCases: useCases)),
      );

      await tester.tap(find.byKey(const Key('product_add_fab')));
      await tester.pumpAndSettle();

      // Hanya isi nama; SKU kosong dan harga kosong -> tidak valid.
      await tester.enterText(
          find.byKey(const Key('product_name_field')), 'Jahe');

      await tester.tap(find.byKey(const Key('product_save_button')));
      await tester.pumpAndSettle();

      expect(find.textContaining('wajib diisi'), findsOneWidget);
      expect(repo.getAll(), isEmpty);
      // Dialog tetap terbuka.
      expect(find.byKey(const Key('product_save_button')), findsOneWidget);
    });

    testWidgets('persistence failure -> error terlihat dan tidak tersimpan',
        (tester) async {
      final useCases = ProductUseCases(repository: _ThrowingProductRepository());

      await tester.pumpWidget(
        MaterialApp(home: ProductScreen(productUseCases: useCases)),
      );

      await tester.tap(find.byKey(const Key('product_add_fab')));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('product_name_field')), 'Sereh');
      await tester.enterText(
          find.byKey(const Key('product_sku_field')), 'SR-001');
      await tester.enterText(
          find.byKey(const Key('product_purchase_field')), '10000');
      await tester.enterText(
          find.byKey(const Key('product_selling_field')), '15000');

      await tester.tap(find.byKey(const Key('product_save_button')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Gagal menyimpan produk'), findsOneWidget);
      // Dialog tetap terbuka agar user dapat memperbaiki/mengulang.
      expect(find.byKey(const Key('product_save_button')), findsOneWidget);
    });
  });
}

class _ThrowingProductRepository implements ProductRepository {
  @override
  Product? getById(String id) => null;

  @override
  Product? getBySku(String sku) => null;

  @override
  List<Product> getAll() => const [];

  @override
  List<Product> getActive() => const [];

  @override
  Future<void> save(Product product) async {
    throw StateError('DB failure simulated.');
  }

  @override
  Future<void> update(Product product) async {}

  @override
  Future<void> deleteById(String id) async {}
}
