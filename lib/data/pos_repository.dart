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
}
