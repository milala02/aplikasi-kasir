import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/dashboard/application/financial_analytics_use_case.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/in_memory_sale_repository.dart';

void main() {
  group('🔥 POS & Financial Engine Stress Test', () {
    late InMemorySaleRepository saleRepo;
    late FinancialAnalyticsUseCase analyticsUseCase;

    setUp(() {
      saleRepo = InMemorySaleRepository();
      analyticsUseCase = FinancialAnalyticsUseCase(saleRepository: saleRepo);
    });

    test('Harus mampu memproses 10.000 transaksi dan menghitung analitik dalam waktu di bawah 1 detik', () {
      print('Suntik 10.000 data transaksi...');
      
      final startDate = DateTime(2026, 1, 1);
      
      // 1. Injeksi 10.000 transaksi secara brutal ke dalam memori
      for (var i = 0; i < 10000; i++) {
        final sale = Sale(
          id: 'sale_$i',
          invoiceNumber: 'INV-STRESS-$i',
          items: [
            SaleItem(
              productId: 'bumbu_merah',
              productName: 'Bumbu Merah',
              unit: Unit.pcs,
              quantity: Quantity(value: 2, scale: 0),
              unitPrice: const Money(minorUnits: 5000000, currency: 'IDR'), // Rp 50.000
            ),
            SaleItem(
              productId: 'lada_ketengan',
              productName: 'Lada Ketengan 5k',
              unit: Unit.pcs,
              quantity: Quantity(value: 5, scale: 0),
              unitPrice: const Money(minorUnits: 500000, currency: 'IDR'), // Rp 5.000
            ),
          ],
          createdAt: startDate.add(Duration(hours: i)),
        );
        saleRepo.save(sale);
      }

      expect(saleRepo.getAll().length, equals(10000));
      print('✅ 10.000 transaksi berhasil masuk ke memori.');

      // 2. Mulai pengukur waktu (Stopwatch)
      print('Memulai kalkulasi analitik keuangan (Omset, HPP FIFO, Margin)...');
      final stopwatch = Stopwatch()..start();

      // Eksekusi perhitungan berat
      final summary = analyticsUseCase.calculateSummary();

      stopwatch.stop();
      final executionTime = stopwatch.elapsedMilliseconds;

      // 3. Verifikasi Logika Akuntansi & Kecepatan
      // Omset per struk: (2 * 50.000) + (5 * 5.000) = Rp 125.000
      // 10.000 struk * Rp 125.000 = Rp 1.250.000.000 (1.25 Miliar)
      final expectedOmsetMinor = 12500000 * 10000; 

      print('⏱️ Waktu Eksekusi Analitik: $executionTime milidetik');
      print('💰 Total Omset Terhitung: Rp ${summary.totalOmset.minorUnits ~/ 100}');
      print('📈 Total Transaksi Terhitung: ${summary.totalTransactions}');

      expect(summary.totalOmset.minorUnits, equals(expectedOmsetMinor));
      expect(summary.totalTransactions, equals(10000));
      
      // Aplikasi gagal jika proses memakan waktu lebih dari 1000 milidetik (1 detik)
      expect(executionTime, lessThan(1000), reason: 'Performa analitik terlalu lambat! Harus di bawah 1 detik.');
    });
  });
}
