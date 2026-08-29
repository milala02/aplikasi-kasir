import 'package:flutter_test/flutter_test.dart';
import 'package:aplikasi_kasir/core/money/money.dart';
import 'package:aplikasi_kasir/core/quantity/quantity.dart';
import 'package:aplikasi_kasir/core/unit/unit.dart';
import 'package:aplikasi_kasir/features/dashboard/application/financial_analytics_use_case.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale.dart';
import 'package:aplikasi_kasir/features/sales/domain/sale_item.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/in_memory_sale_repository.dart';

void main() {
  group('FinancialAnalyticsUseCase - HPP FIFO aktual', () {
    late InMemorySaleRepository saleRepo;
    late FinancialAnalyticsUseCase useCase;

    setUp(() {
      saleRepo = InMemorySaleRepository();
      useCase = FinancialAnalyticsUseCase(saleRepository: saleRepo);
    });

    SaleItem buildItem({
      String productId = 'pepper',
      int quantity = 2,
      int unitPriceMinor = 3000000,
      int? unitCostMinor,
    }) {
      return SaleItem(
        productId: productId,
        productName: 'Lada',
        unit: Unit.kilogram,
        quantity: Quantity(value: quantity, scale: 0),
        unitPrice: Money(minorUnits: unitPriceMinor, currency: 'IDR'),
        unitCost: unitCostMinor == null
            ? null
            : Money(minorUnits: unitCostMinor, currency: 'IDR'),
      );
    }

    Sale buildSale({
      required String id,
      required List<SaleItem> items,
      required DateTime createdAt,
    }) {
      return Sale(
        id: id,
        invoiceNumber: 'INV-$id',
        items: items,
        createdAt: createdAt,
      );
    }

    test('HPP memakai SaleItem.unitCost FIFO, bukan estimasi', () async {
      // Sale 1: 2 kg @ harga 30.000, HPP unit 10.000 -> HPP 20.000
      await saleRepo.save(buildSale(
        id: 's1',
        items: [buildItem(quantity: 2, unitPriceMinor: 3000000, unitCostMinor: 1000000)],
        createdAt: DateTime(2026, 8, 20),
      ));
      // Sale 2: 3 kg @ harga 30.000, HPP unit 12.000 -> HPP 36.000
      await saleRepo.save(buildSale(
        id: 's2',
        items: [buildItem(quantity: 3, unitPriceMinor: 3000000, unitCostMinor: 1200000)],
        createdAt: DateTime(2026, 8, 21),
      ));

      final summary = useCase.calculateSummary();

      // Omset: (2*30.000) + (3*30.000) = 150.000
      expect(summary.totalOmset.minorUnits, equals(15000000));
      // HPP FIFO: 20.000 + 36.000 = 56.000
      expect(summary.totalHppFifo.minorUnits, equals(5600000));
      // Profit: 150.000 - 56.000 = 94.000
      expect(summary.grossProfit.minorUnits, equals(9400000));
      expect(summary.marginPercentage, closeTo(62.67, 0.01));
      expect(summary.totalTransactions, equals(2));
    });

    test('item legacy tanpa unitCost tidak menyumbang HPP (fallback eksplisit)',
        () async {
      await saleRepo.save(buildSale(
        id: 's1',
        items: [buildItem(quantity: 2)], // unitCost null
        createdAt: DateTime(2026, 8, 20),
      ));

      final summary = useCase.calculateSummary();

      expect(summary.totalOmset.minorUnits, equals(6000000));
      expect(summary.totalHppFifo.minorUnits, equals(0));
      expect(summary.grossProfit.minorUnits, equals(6000000));
    });

    test('filter rentang tanggal hanya menghitung sale dalam rentang',
        () async {
      await saleRepo.save(buildSale(
        id: 's1',
        items: [buildItem(quantity: 1, unitCostMinor: 1000000)],
        createdAt: DateTime(2026, 8, 10),
      ));
      await saleRepo.save(buildSale(
        id: 's2',
        items: [buildItem(quantity: 1, unitCostMinor: 1000000)],
        createdAt: DateTime(2026, 8, 20),
      ));

      final summary = useCase.calculateSummary(
        startDate: DateTime(2026, 8, 15),
        endDate: DateTime(2026, 8, 31),
      );

      expect(summary.totalTransactions, equals(1));
      expect(summary.totalOmset.minorUnits, equals(3000000));
      expect(summary.totalHppFifo.minorUnits, equals(1000000));
    });

    test('tanpa penjualan menghasilkan nol dan margin 0', () {
      final summary = useCase.calculateSummary();

      expect(summary.totalOmset.minorUnits, equals(0));
      expect(summary.totalHppFifo.minorUnits, equals(0));
      expect(summary.grossProfit.minorUnits, equals(0));
      expect(summary.marginPercentage, equals(0.0));
      expect(summary.totalTransactions, equals(0));
    });
  });
}
