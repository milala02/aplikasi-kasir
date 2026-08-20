import 'package:flutter_test/flutter_test.dart';

// Service Logika Multi-Payment, Grosir & Split Bill
class AdvancedCheckoutService {
  // Hitung harga grosir bertingkat
  double calculateItemPrice(double basePrice, int qty, List<Map<String, dynamic>> wholesaleTiers) {
    double pricePerUnit = basePrice;
    for (var tier in wholesaleTiers) {
      if (qty >= (tier['minQty'] as int)) {
        pricePerUnit = tier['discountedPrice'] as double;
      }
    }
    return pricePerUnit * qty;
  }

  // Validasi pembayaran gabungan (Multi-Payment)
  bool validateMultiPayment(double totalBill, Map<String, double> paymentMethods) {
    double totalPaid = paymentMethods.values.fold(0.0, (sum, val) => sum + val);
    return totalPaid >= totalBill;
  }

  // Split Bill berdasarkan jumlah orang
  List<double> splitBillEqually(double totalBill, int numberOfPeople) {
    if (numberOfPeople <= 0) throw ArgumentError('Jumlah orang harus lebih dari 0');
    double splitAmount = (totalBill / numberOfPeople).roundToDouble();
    List<double> splits = List.filled(numberOfPeople, splitAmount);
    return splits;
  }
}

void main() {
  group('Uji 4.7 - Split Bill, Multi-Payment & Wholesale Pricing Validation', () {
    late AdvancedCheckoutService checkoutService;

    setUp(() {
      checkoutService = AdvancedCheckoutService();
    });

    test('4.7.1 - Kalkulasi harga grosir otomatis menerapkan diskon bertingkat', () {
      final wholesaleTiers = [
        {'minQty': 10, 'discountedPrice': 8500.0}, // e.g. Beli >= 10 pcs @Rp 8.500
        {'minQty': 50, 'discountedPrice': 7500.0}, // e.g. Beli >= 50 pcs @Rp 7.500
      ];

      // Eceran (< 10)
      double priceEceran = checkoutService.calculateItemPrice(10000.0, 5, wholesaleTiers);
      expect(priceEceran, 50000.0); // 5 * 10.000

      // Grosir Tier 1 (10-49)
      double priceTier1 = checkoutService.calculateItemPrice(10000.0, 12, wholesaleTiers);
      expect(priceTier1, 102000.0); // 12 * 8.500

      // Grosir Tier 2 (>= 50)
      double priceTier2 = checkoutService.calculateItemPrice(10000.0, 50, wholesaleTiers);
      expect(priceTier2, 375000.0); // 50 * 7.500
    });

    test('4.7.2 - Multi-payment memvalidasi kombinasi Tunai + QRIS secara akurat', () {
      double totalBill = 100000.0;
      
      Map<String, double> validPayments = {
        'Cash': 50000.0,
        'QRIS': 50000.0,
      };

      Map<String, double> invalidPayments = {
        'Cash': 30000.0,
        'QRIS': 50000.0,
      };

      expect(checkoutService.validateMultiPayment(totalBill, validPayments), isTrue);
      expect(checkoutService.validateMultiPayment(totalBill, invalidPayments), isFalse);
    });

    test('4.7.3 - Pembagian tagihan (Split Bill) membagi total bayar dengan rata', () {
      double totalBill = 150000.0;
      List<double> splitResults = checkoutService.splitBillEqually(totalBill, 3);

      expect(splitResults.length, 3);
      expect(splitResults.every((val) => val == 50000.0), isTrue);
    });
  });
}
