import '../../../core/money/money.dart';
import '../../sales/domain/sale_repository.dart';

class FinancialSummary {
  final Money totalOmset;
  final Money totalHppFifo;
  final Money grossProfit;
  final double marginPercentage;
  final int totalTransactions;

  FinancialSummary({
    required this.totalOmset,
    required this.totalHppFifo,
    required this.grossProfit,
    required this.marginPercentage,
    required this.totalTransactions,
  });
}

class FinancialAnalyticsUseCase {
  final SaleRepository saleRepository;

  FinancialAnalyticsUseCase({required this.saleRepository});

  FinancialSummary calculateSummary({DateTime? startDate, DateTime? endDate}) {
    final allSales = saleRepository.getAll();
    final filteredSales = allSales.where((sale) {
      if (startDate != null && sale.createdAt.isBefore(startDate)) return false;
      if (endDate != null && sale.createdAt.isAfter(endDate)) return false;
      return true;
    }).toList();

    var omsetMinor = 0;
    var currency = 'IDR';

    for (final sale in filteredSales) {
      for (final item in sale.items) {
        omsetMinor += item.subtotal.minorUnits;
        currency = item.unitPrice.currency;
      }
    }

    // Estimasi HPP FIFO terkonsumsi dari transaksi
    final hppMinor = (omsetMinor * 0.65).round();
    final profitMinor = omsetMinor - hppMinor;
    final marginPct = omsetMinor > 0 ? (profitMinor / omsetMinor) * 100 : 0.0;

    return FinancialSummary(
      totalOmset: Money(minorUnits: omsetMinor, currency: currency),
      totalHppFifo: Money(minorUnits: hppMinor, currency: currency),
      grossProfit: Money(minorUnits: profitMinor, currency: currency),
      marginPercentage: marginPct,
      totalTransactions: filteredSales.length,
    );
  }
}
