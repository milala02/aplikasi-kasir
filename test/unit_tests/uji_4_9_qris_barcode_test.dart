import 'package:flutter_test/flutter_test.dart';

// Service Parser QRIS & Barcode LookUp
class QrisBarcodeService {
  final Map<String, Map<String, dynamic>> _productCatalogByBarcode = {
    '8999999000012': {'id': 'P01', 'name': 'Kopi Kemasan 250ml', 'price': 15000.0},
    '8999999000029': {'id': 'P02', 'name': 'Roti Tawar Wheat', 'price': 20000.0},
  };

  // Parsing sederhana Payload String QRIS Dinamis
  Map<String, String> parseQrisPayload(String payload) {
    if (!payload.startsWith('000201')) {
      throw FormatException('Format QRIS tidak valid');
    }
    
    // Simulasi ekstraksi tag sederhana
    String merchantName = 'UNKNOWN';
    double amount = 0.0;

    if (payload.contains('MERCHANT=')) {
      final parts = payload.split(';');
      for (var p in parts) {
        if (p.startsWith('MERCHANT=')) merchantName = p.split('=')[1];
        if (p.startsWith('AMOUNT=')) amount = double.tryParse(p.split('=')[1]) ?? 0.0;
      }
    }

    return {
      'merchant': merchantName,
      'amount': amount.toStringAsFixed(0),
    };
  }

  // Lookup Produk via Barcode Scanner
  Map<String, dynamic>? findProductByBarcode(String barcode) {
    if (!_productCatalogByBarcode.containsKey(barcode)) {
      return null;
    }
    return _productCatalogByBarcode[barcode];
  }
}

void main() {
  group('Uji 4.9 - Dynamic QRIS & Barcode Scanner Lookup Validation', () {
    late QrisBarcodeService service;

    setUp(() {
      service = QrisBarcodeService();
    });

    test('4.9.1 - Parsing payload QRIS valid berhasil mengekstrak detail merchant & nominal', () {
      const mockQris = '000201;MERCHANT=Toko Berkah;AMOUNT=45000;5303360';
      final result = service.parseQrisPayload(mockQris);

      expect(result['merchant'], 'Toko Berkah');
      expect(result['amount'], '45000');
    });

    test('4.9.2 - Menolak string QRIS dengan header tidak valid', () {
      const invalidQris = 'INVALID_HEADER_12345';
      expect(
        () => service.parseQrisPayload(invalidQris),
        throwsA(isA<FormatException>()),
      );
    });

    test('4.9.3 - Barcode scanner menemukan produk secara tepat berdasarkan SKU/Barcode', () {
      final product = service.findProductByBarcode('8999999000012');
      expect(product, isNotNull);
      expect(product!['name'], 'Kopi Kemasan 250ml');
      expect(product['price'], 15000.0);
    });

    test('4.9.4 - Barcode tidak terdaftar mengembalikan nilai null (Not Found)', () {
      final product = service.findProductByBarcode('0000000000000');
      expect(product, isNull);
    });
  });
}
