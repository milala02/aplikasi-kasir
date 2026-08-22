import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/providers/pos_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PosProvider State & Logic Tests', () {
    late PosProvider provider;

    setUp(() {
      provider = PosProvider();
    });

    test('Inisialisasi PosProvider harus dalam keadaan bersih', () {
      expect(provider.isLoading, isFalse);
      expect(provider.cart, isNotNull);
      expect(provider.cart, isEmpty);
    });

    // SUPER MAP: Mencakup seluruh kombinasi key yang mungkin digunakan oleh legacy PosProvider
    final Map<String, dynamic> sampleItem = {
      'id': 'prod_101',
      'product_id': 'prod_101',
      'name': 'Kopi Susu Aren',
      'product_name': 'Kopi Susu Aren',
      'price': 18000,
      'base_price': 18000,
      'cost_price': 10000,
      'selling_price': 18000,
      'price_per_unit': 18000,
      'qty': 1,
      'quantity': 1,
      'stock': 100,
      'subtotal': 18000,
    };

    test('Menambahkan produk ke keranjang via PosProvider memperbarui item cart', () {
      provider.addToCart(sampleItem);
      expect(provider.cart.length, equals(1));
    });

    test('Mengosongkan keranjang via PosProvider (clearCart) mereset daftar barang', () {
      provider.addToCart(sampleItem);
      expect(provider.cart, isNotEmpty);

      provider.clearCart();
      expect(provider.cart, isEmpty);
    });
  });
}
