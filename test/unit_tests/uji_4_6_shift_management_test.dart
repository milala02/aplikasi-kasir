import 'package:flutter_test/flutter_test.dart';

// Service Logika Shift & Kas Laci
class ShiftService {
  bool isShiftActive = false;
  double initialCash = 0.0;
  double totalCashSales = 0.0;
  double totalCashOut = 0.0;

  void openShift(double startingFloat) {
    if (startingFloat < 0) throw ArgumentError('Modal awal tidak boleh negatif');
    initialCash = startingFloat;
    totalCashSales = 0.0;
    totalCashOut = 0.0;
    isShiftActive = true;
  }

  void recordCashSale(double amount) {
    if (!isShiftActive) throw StateError('Shift belum dibuka');
    totalCashSales += amount;
  }

  void recordCashOut(double amount) {
    if (!isShiftActive) throw StateError('Shift belum dibuka');
    if (amount > expectedCash) throw ArgumentError('Penarikan kas melebihi saldo saat ini');
    totalCashOut += amount;
  }

  double get expectedCash => (initialCash + totalCashSales) - totalCashOut;

  Map<String, dynamic> closeShift(double actualCashInDrawer) {
    if (!isShiftActive) throw StateError('Shift belum dibuka');
    double difference = actualCashInDrawer - expectedCash;
    isShiftActive = false;
    return {
      'initialCash': initialCash,
      'totalCashSales': totalCashSales,
      'totalCashOut': totalCashOut,
      'expectedCash': expectedCash,
      'actualCash': actualCashInDrawer,
      'difference': difference, // 0 = pas, >0 = selisih lebih, <0 = selisih kurang
    };
  }
}

void main() {
  group('Uji 4.6 - Shift Management & Cash Float Validation', () {
    late ShiftService shiftService;

    setUp(() {
      shiftService = ShiftService();
    });

    test('4.6.1 - Membuka shift menetapkan modal awal (cash float) dengan benar', () {
      shiftService.openShift(500000.0);

      expect(shiftService.isShiftActive, isTrue);
      expect(shiftService.initialCash, 500000.0);
      expect(shiftService.expectedCash, 500000.0);
    });

    test('4.6.2 - Penjualan tunai dan cash out memperbarui estimasi saldo kas', () {
      shiftService.openShift(500000.0);
      shiftService.recordCashSale(200000.0);
      shiftService.recordCashOut(50000.0);

      expect(shiftService.expectedCash, 650000.0);
    });

    test('4.6.3 - Penutupan shift menghitung selisih kas fisik vs sistem secara akurat', () {
      shiftService.openShift(500000.0);
      shiftService.recordCashSale(150000.0); // Expected: 650000.0

      // Simulasi kasir menghitung uang fisik di laci = 645000.0 (Selisih kurang 5000)
      final report = shiftService.closeShift(645000.0);

      expect(report['expectedCash'], 650000.0);
      expect(report['actualCash'], 645000.0);
      expect(report['difference'], -5000.0);
      expect(shiftService.isShiftActive, isFalse);
    });
  });
}
