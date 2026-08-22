import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
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


  // =========================================================================
  // SALTED SHA-256 SECURITY ENGINE (Anti-Rainbow Table)
  // =========================================================================
  static String generateSalt([int length = 16]) {
    final rand = Random.secure();
    final values = List<int>.generate(length, (i) => rand.nextInt(256));
    return base64Url.encode(values).substring(0, length);
  }

  static String hashPinWithSalt(String pin, String salt) {
    final bytes = utf8.encode(salt + pin);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Verifikasi PIN App / Kasir dengan Salt
  Future<bool> verifyAppPinSalted(String userId, String rawInputPin) async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> res = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
        limit: 1,
      );

      if (res.isEmpty) return false;

      final userData = res.first;
      final storedHash = userData['app_pin_hash']?.toString() ?? '';
      final storedSalt = userData['app_pin_salt']?.toString() ?? '';

      // Jika user belum punya salt (fallback legacy), hitung sha256 biasa
      if (storedSalt.isEmpty) {
        final legacyHash = sha256.convert(utf8.encode(rawInputPin)).toString();
        return storedHash == legacyHash || storedHash == rawInputPin;
      }

      final computedHash = hashPinWithSalt(rawInputPin, storedSalt);
      return storedHash == computedHash;
    } catch (e) {
      debugPrint("Error verifyAppPinSalted: $e");
      return false;
    }
  }

  // Verifikasi PIN Supervisor dengan Salt
  Future<bool> verifySupervisorPinSalted(String rawInputPin) async {
    try {
      final db = await dbHelper.database;
      final List<Map<String, dynamic>> res = await db.query(
        'users',
        where: 'role = ?',
        whereArgs: ['SUPERVISOR'],
        limit: 1,
      );

      if (res.isEmpty) return false;

      final supervisorData = res.first;
      final storedHash = supervisorData['supervisor_pin_hash']?.toString() ?? '';
      final storedSalt = supervisorData['supervisor_pin_salt']?.toString() ?? '';

      if (storedSalt.isEmpty) {
        final legacyHash = sha256.convert(utf8.encode(rawInputPin)).toString();
        return storedHash == legacyHash || storedHash == rawInputPin;
      }

      final computedHash = hashPinWithSalt(rawInputPin, storedSalt);
      return storedHash == computedHash;
    } catch (e) {
      debugPrint("Error verifySupervisorPinSalted: $e");
      return false;
    }
  }


  // =========================================================================
  // MEMORY-EFFICIENT FIFO HPP ENGINE (SQL-Level Execution)
  // =========================================================================
  Future<double> deductStockAndCalculateFifoHpp(dynamic txn, String productId, int qtyToDeduct) async {
    int remainingToDeduct = qtyToDeduct;
    double totalHppCost = 0.0;

    // Fetch batch barang berdasarkan urutan masuk tertua (First In, First Out)
    final List<Map<String, dynamic>> layers = await txn.query(
      'product_cost_layers',
      where: 'product_id = ? AND remaining_qty > 0',
      whereArgs: [productId],
      orderBy: 'created_at ASC',
    );

    for (var layer in layers) {
      if (remainingToDeduct <= 0) break;

      final String layerId = layer['id'].toString();
      final int layerQty = int.tryParse(layer['remaining_qty'].toString()) ?? 0;
      final double costPrice = double.tryParse(layer['cost_price'].toString()) ?? 0.0;

      if (layerQty <= remainingToDeduct) {
        // Habiskan seluruh kuantitas di batch tertua ini
        totalHppCost += (layerQty * costPrice);
        remainingToDeduct -= layerQty;

        await txn.update(
          'product_cost_layers',
          {'remaining_qty': 0},
          where: 'id = ?',
          whereArgs: [layerId],
        );
      } else {
        // Potong sebagian dari batch ini
        totalHppCost += (remainingToDeduct * costPrice);
        final int newRemaining = layerQty - remainingToDeduct;
        remainingToDeduct = 0;

        await txn.update(
          'product_cost_layers',
          {'remaining_qty': newRemaining},
          where: 'id = ?',
          whereArgs: [layerId],
        );
      }
    }

    // Backup Fallback: Jika barang masuk tidak mencukupi di layer (legacy product), gunakan cost_price produk utama
    if (remainingToDeduct > 0) {
      final List<Map<String, dynamic>> prod = await txn.query(
        'products',
        columns: ['cost_price'],
        where: 'id = ?',
        whereArgs: [productId],
        limit: 1,
      );
      if (prod.isNotEmpty) {
        final double fallbackCost = double.tryParse(prod.first['cost_price'].toString()) ?? 0.0;
        totalHppCost += (remainingToDeduct * fallbackCost);
      }
    }

    return totalHppCost;
  }

}
