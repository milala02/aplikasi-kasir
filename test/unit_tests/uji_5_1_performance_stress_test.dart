import 'package:flutter_test/flutter_test.dart';

class MassiveCatalogService {
  final List<Map<String, dynamic>> _catalog = [];
  final Map<String, Map<String, dynamic>> _barcodeIndex = {};

  // Generate 100.000 mock items & create HashMap index
  void populateMassiveCatalog(int count) {
    _catalog.clear();
    _barcodeIndex.clear();
    
    for (int i = 1; i <= count; i++) {
      final barcode = '89900000${i.toString().padLeft(6, '0')}';
      final item = {
        'id': 'PROD_$i',
        'name': 'Produk Makanan Minuman Varian $i',
        'barcode': barcode,
        'price': 10000.0 + (i % 50) * 500,
        'stock': 100,
      };
      
      _catalog.add(item);
      _barcodeIndex[barcode] = item;
    }
  }

  int get catalogLength => _catalog.length;

  // Search Text Linear Scan (Optimized string matching)
  List<Map<String, dynamic>> searchProductsByName(String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return _catalog.where((item) {
      final name = item['name'] as String;
      return name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  // Fast O(1) Barcode Lookup via Map Index
  Map<String, dynamic>? searchByBarcodeIndexed(String barcode) {
    return _barcodeIndex[barcode];
  }
}

void main() {
  group('Uji 5.1 - Massive Stress & Performance Load Test (100.000 Data)', () {
    late MassiveCatalogService catalogService;

    setUp(() {
      catalogService = MassiveCatalogService();
      catalogService.populateMassiveCatalog(100000);
    });

    test('5.1.1 - Inisialisasi 100.000 data produk masif berhasil dimuat', () {
      expect(catalogService.catalogLength, 100000);
    });

    test('5.1.2 - Pencarian nama produk pada 100.000 data harus selesai di bawah 150ms', () {
      final stopwatch = Stopwatch()..start();
      
      final results = catalogService.searchProductsByName('Varian 99999');
      
      stopwatch.stop();

      expect(results.length, greaterThan(0));
      expect(stopwatch.elapsedMilliseconds, lessThan(150),
          reason: 'Pencarian nama terlalu lambat (${stopwatch.elapsedMilliseconds}ms), target < 150ms');
    });

    test('5.1.3 - Lookup Barcode via Index O(1) pada 100.000 data harus hampir instan (< 10ms)', () {
      final stopwatch = Stopwatch()..start();
      
      final result = catalogService.searchByBarcodeIndexed('89900000099999');
      
      stopwatch.stop();

      expect(result, isNotNull);
      expect(result!['id'], 'PROD_99999');
      expect(stopwatch.elapsedMilliseconds, lessThan(10),
          reason: 'Indexed lookup barcode terlalu lambat (${stopwatch.elapsedMilliseconds}ms)');
    });
  });
}
