import 'package:flutter_test/flutter_test.dart';

// Service Agregasi Laporan Penjualan
class SalesReportService {
  final List<Map<String, dynamic>> _transactions = [
    {'id': 'TRX-01', 'total': 50000.0, 'modal': 30000.0, 'date': '2026-04-01'},
    {'id': 'TRX-02', 'total': 100000.0, 'modal': 60000.0, 'date': '2026-04-01'},
    {'id': 'TRX-03', 'total': 75000.0, 'modal': 45000.0, 'date': '2026-04-02'},
  ];

  double calculateTotalOmzet({String? filterDate}) {
    return _transactions
        .where((t) => filterDate == null || t['date'] == filterDate)
        .fold(0.0, (sum, item) => sum + (item['total'] as double));
  }

  double calculateTotalProfit({String? filterDate}) {
    return _transactions
        .where((t) => filterDate == null || t['date'] == filterDate)
        .fold(0.0, (sum, item) => sum + ((item['total'] as double) - (item['modal'] as double)));
  }

  String generateCsvReport() {
    StringBuffer csv = StringBuffer();
    csv.writeln('ID_Transaksi,Tanggal,Total_Omzet,Modal,Laba_Kotor');
    for (var t in _transactions) {
      double profit = (t['total'] as double) - (t['modal'] as double);
      csv.writeln('${t['id']},${t['date']},${t['total']},${t['modal']},$profit');
    }
    return csv.toString();
  }
}

void main() {
  group('Uji 4.4 - Sales Report Analytics & CSV Export Validation', () {
    late SalesReportService reportService;

    setUp(() {
      reportService = SalesReportService();
    });

    test('4.4.1 - Kalkulasi total omzet dan laba kotor harian dengan akurat', () {
      double omzet01 = reportService.calculateTotalOmzet(filterDate: '2026-04-01');
      double profit01 = reportService.calculateTotalProfit(filterDate: '2026-04-01');

      expect(omzet01, 150000.0);
      expect(profit01, 60000.0);
    });

    test('4.4.2 - Kalkulasi akumulasi total omzet seluruh periode', () {
      double totalOmzet = reportService.calculateTotalOmzet();
      double totalProfit = reportService.calculateTotalProfit();

      expect(totalOmzet, 225000.0);
      expect(totalProfit, 90000.0);
    });

    test('4.4.3 - Format file ekspor CSV sesuai header dan baris data transaksi', () {
      String csvData = reportService.generateCsvReport();

      expect(csvData, contains('ID_Transaksi,Tanggal,Total_Omzet,Modal,Laba_Kotor'));
      expect(csvData, contains('TRX-01,2026-04-01,50000.0,30000.0,20000.0'));
      expect(csvData, contains('TRX-03,2026-04-02,75000.0,45000.0,30000.0'));
    });
  });
}
