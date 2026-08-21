import 'package:flutter/foundation.dart';
import 'database_helper.dart';

class PosRepository {
  final dbHelper = DatabaseHelper.instance;

  // --- HAK AKSES & VERIFIKASI DUAL-PIN ---
  
  // Verifikasi PIN Harian Kasir
  Future<bool> verifyAppPin(String userId, String inputPinHash) async {
    final db = await dbHelper.database;
    final res = await db.query(
      'users',
      where: 'id = ? AND app_pin_hash = ? AND is_active = 1',
      whereArgs: [userId, inputPinHash],
    );
    return res.isNotEmpty;
  }

  // Verifikasi PIN Otorisasi Supervisor / Owner (Void & Diskon Khusus)
  Future<bool> verifySupervisorPin(String inputPinHash) async {
    final db = await dbHelper.database;
    final res = await db.query(
      'users',
      where: '(role = "supervisor" OR role = "admin") AND supervisor_pin_hash = ? AND is_active = 1',
      whereArgs: [inputPinHash],
    );
    return res.isNotEmpty;
  }

  // --- OPERASI PRODUK (TAMBAH, EDIT, STOK) ---

  Future<int> insertProduct(Map<String, dynamic> productData) async {
    final db = await dbHelper.database;
    return await db.insert('products', productData);
  }

  Future<int> updateProductStock(String productId, int newStock) async {
    final db = await dbHelper.database;
    return await db.update(
      'products',
      {'stock': newStock},
      where: 'id = ?',
      whereArgs: [productId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    final db = await dbHelper.database;
    return await db.query('products', orderBy: 'name ASC');
  }

  // Search Cepat via Index Barcode O(1)
  Future<Map<String, dynamic>?> getProductByBarcode(String barcode) async {
    final db = await dbHelper.database;
    final res = await db.query(
      'products',
      where: 'barcode = ?',
      whereArgs: [barcode],
      limit: 1,
    );
    return res.isNotEmpty ? res.first : null;
  }

  // =========================================================================
  // ATOMIC TRANSACTION: Checkout & Pengurangan Stok
  // Garansi ACID (Atomicity, Consistency, Isolation, Durability)
  // =========================================================================
  Future<bool> processSaleAtomically(Map<String, dynamic> transactionData, List<Map<String, dynamic>> cartItems) async {
    final db = await dbHelper.database;
    
    try {
      // db.transaction menjamin jika ada 1 error, SEMUA perubahan akan di-Rollback
      await db.transaction((txn) async {
        
        // 1. Catat Nota Penjualan Induk
        await txn.insert('transactions', transactionData);
        
        // 2. Catat Item Pembelian & Kurangi Stok
        for (var item in cartItems) {
          // A. Simpan ke tabel detail transaksi
          await txn.insert('transaction_items', {
            'transaction_id': transactionData['id'],
            'product_id': item['id'],
            'quantity': item['qty'],
            'price': item['base_price'] ?? item['price'] ?? 0.0,
          });
          
          // B. Kurangi stok di katalog (Raw SQL lebih aman dari race condition)
          await txn.rawUpdate(
            'UPDATE products SET stock = stock - ? WHERE id = ?',
            [item['qty'], item['id']]
          );
          
          // C. (Di masa depan, logika pengurangan Cost Layer / FIFO bisa dimasukkan ke sini)
        }
      });
      
      return true; // Transaksi sukses 100%
      
    } catch (e) {
      debugPrint('🚨 ATOMIC TRANSACTION GAGAL & DI-ROLLBACK: $e');
      return false;
    }
  }

}
