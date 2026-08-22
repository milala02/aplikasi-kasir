import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:aplikasi_kasir/data/pos_repository.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('PosRepository SQLite FFI Unit Tests', () {
    late PosRepository repository;
    late Database db;

    setUp(() async {
      db = await openDatabase(
        inMemoryDatabasePath,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE users (
              id TEXT PRIMARY KEY,
              role TEXT,
              app_pin_hash TEXT,
              app_pin_salt TEXT,
              supervisor_pin_hash TEXT,
              supervisor_pin_salt TEXT
            )
          ''');
          await db.execute('''
            CREATE TABLE products (
              id TEXT PRIMARY KEY,
              name TEXT,
              cost_price REAL,
              stock INTEGER
            )
          ''');
          await db.execute('''
            CREATE TABLE product_cost_layers (
              id TEXT PRIMARY KEY,
              product_id TEXT,
              cost_price REAL,
              remaining_qty INTEGER,
              created_at TEXT
            )
          ''');
        },
      );
      
      repository = PosRepository();
    });

    tearDown(() async {
      await db.close();
    });

    test('generateSalt and hashPinWithSalt should produce deterministic hash', () {
      final salt = PosRepository.generateSalt(16);
      final hash1 = PosRepository.hashPinWithSalt('123456', salt);
      final hash2 = PosRepository.hashPinWithSalt('123456', salt);
      
      expect(hash1, equals(hash2));
      expect(hash1.length, equals(64));
    });

    test('hashPinWithSalt produces different outputs for different PINs', () {
      final salt = PosRepository.generateSalt(16);
      final hash1 = PosRepository.hashPinWithSalt('123456', salt);
      final hash2 = PosRepository.hashPinWithSalt('654321', salt);

      expect(hash1, isNot(equals(hash2)));
    });

    test('deductStockAndCalculateFifoHpp should correctly deduct FIFO layers', () async {
      await db.insert('product_cost_layers', {
        'id': 'layer_1',
        'product_id': 'prod_a',
        'cost_price': 10000.0,
        'remaining_qty': 5,
        'created_at': '2026-01-01T00:00:00Z',
      });
      await db.insert('product_cost_layers', {
        'id': 'layer_2',
        'product_id': 'prod_a',
        'cost_price': 12000.0,
        'remaining_qty': 10,
        'created_at': '2026-01-02T00:00:00Z',
      });

      double totalHpp = 0.0;
      await db.transaction((txn) async {
        totalHpp = await repository.deductStockAndCalculateFifoHpp(txn, 'prod_a', 7);
      });

      // 7 unit = (5 unit @ 10.000) + (2 unit @ 12.000) = 50.000 + 24.000 = 74.000
      expect(totalHpp, equals(74000.0));

      final layer1 = await db.query('product_cost_layers', where: 'id = ?', whereArgs: ['layer_1']);
      final layer2 = await db.query('product_cost_layers', where: 'id = ?', whereArgs: ['layer_2']);

      expect(layer1.first['remaining_qty'], equals(0));
      expect(layer2.first['remaining_qty'], equals(8));
    });
  });
}
