import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('pos_production.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';
    const integerType = 'INTEGER NOT NULL';

    // 1. Tabel Pengguna & Dual-PIN Keamanan (Hash Encrypted)
    await db.execute('''
      CREATE TABLE users (
        id $idType,
        name $textType,
        role $textType,
        app_pin_hash $textType,
        supervisor_pin_hash TEXT,
        is_active $integerType DEFAULT 1
      )
    ''');

    // 2. Tabel Katalog Produk & Barcode Indexing
    await db.execute('''
      CREATE TABLE products (
        id $idType,
        barcode TEXT UNIQUE,
        name $textType,
        base_price $realType,
        cost_price $realType,
        stock $integerType,
        category $textType,
        created_at $textType
      )
    ''');

    // 3. Tabel Harga Grosir Bertingkat (Wholesale Tiers)
    await db.execute('''
      CREATE TABLE wholesale_tiers (
        id $idType,
        product_id $textType,
        min_qty $integerType,
        discounted_price $realType,
        FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
      )
    ''');

    // 4. Tabel Log Shift & Laci Uang (Cash Float)
    await db.execute('''
      CREATE TABLE shifts (
        id $idType,
        user_id $textType,
        start_time $textType,
        end_time TEXT,
        initial_float $realType,
        total_cash_sales $realType DEFAULT 0,
        total_cash_out $realType DEFAULT 0,
        actual_cash $realType,
        difference $realType,
        status $textType
      )
    ''');

    // 5. Tabel Transaksi & Audit Void
    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        shift_id $textType,
        total_amount $realType,
        tax_amount $realType,
        discount_amount $realType,
        payment_method $textType,
        status $textType,
        supervisor_void_pin TEXT,
        created_at $textType,
        is_synced $integerType DEFAULT 0
      )
    ''');

    // 6. Tabel Detail Item Transaksi
    await db.execute('''
      CREATE TABLE transaction_items (
        id $idType,
        transaction_id $textType,
        product_id $textType,
        product_name $textType,
        qty $integerType,
        price_per_unit $realType,
        subtotal $realType,
        FOREIGN KEY (transaction_id) REFERENCES transactions (id) ON DELETE CASCADE
      )
    ''');

    // Indexing cepat untuk Barcode & Pencarian Nama pada 100.000+ data
    await db.execute('CREATE INDEX idx_products_barcode ON products(barcode);');
    await db.execute('CREATE INDEX idx_products_name ON products(name);');
  }

  Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }
}
