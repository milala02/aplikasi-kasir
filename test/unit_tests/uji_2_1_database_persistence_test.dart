import 'package:flutter_test/flutter_test.dart';

// Helper Repository Simulasi Penyimpanan Database Lokal
class LocalDatabaseHelper {
  final List<Map<String, dynamic>> _productTable = [];
  final List<Map<String, dynamic>> _transactionTable = [];

  Future<void> insertProduct(Map<String, dynamic> product) async {
    _productTable.add(product);
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    return List.from(_productTable);
  }

  Future<bool> createTransaction({
    required String id,
    required String productId,
    required int qty,
    required double total,
  }) async {
    final productIndex = _productTable.indexWhere((p) => p['id'] == productId);
    if (productIndex == -1) return false;

    int currentStock = _productTable[productIndex]['stock'];
    if (currentStock < qty) return false; // Proteksi stok tidak mencukupi

    // Kurangi stok & catat transaksi
    _productTable[productIndex]['stock'] = currentStock - qty;
    _transactionTable.add({
      'id': id,
      'productId': productId,
      'qty': qty,
      'total': total,
      'timestamp': DateTime.now().toIso8601String(),
    });
    return true;
  }

  Future<List<Map<String, dynamic>>> getTransactions() async {
    return List.from(_transactionTable);
  }
}

void main() {
  group('Uji 2.1 - Local Database & Persistence Logic Validation', () {
    late LocalDatabaseHelper dbHelper;

    setUp(() {
      dbHelper = LocalDatabaseHelper();
    });

    test('2.1.1 - Menyimpan dan membaca produk dari penyimpanan lokal', () async {
      await dbHelper.insertProduct({
        'id': 'P01',
        'name': 'Kopi Espresso',
        'price': 18000.0,
        'stock': 10
      });

      final products = await dbHelper.getProducts();

      expect(products.length, 1);
      expect(products.first['name'], 'Kopi Espresso');
      expect(products.first['stock'], 10);
    });

    test('2.1.2 - Transaksi berhasil mengurangi stok lokal & mencatat riwayat', () async {
      await dbHelper.insertProduct({
        'id': 'P01',
        'name': 'Kopi Espresso',
        'price': 18000.0,
        'stock': 10
      });

      bool success = await dbHelper.createTransaction(
        id: 'TRX-001',
        productId: 'P01',
        qty: 2,
        total: 36000.0,
      );

      expect(success, isTrue);

      final products = await dbHelper.getProducts();
      expect(products.first['stock'], 8); // Stok berkurang dari 10 ke 8

      final transactions = await dbHelper.getTransactions();
      expect(transactions.length, 1);
      expect(transactions.first['id'], 'TRX-001');
    });

    test('2.1.3 - Transaksi ditolak jika stok lokal tidak mencukupi', () async {
      await dbHelper.insertProduct({
        'id': 'P02',
        'name': 'Teh Manis',
        'price': 5000.0,
        'stock': 1
      });

      bool success = await dbHelper.createTransaction(
        id: 'TRX-002',
        productId: 'P02',
        qty: 5, // Minta 5, stok hanya 1
        total: 25000.0,
      );

      expect(success, isFalse);

      final products = await dbHelper.getProducts();
      expect(products.first['stock'], 1); // Stok tidak boleh berubah
    });
  });
}
