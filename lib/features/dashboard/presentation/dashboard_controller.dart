import 'package:flutter/foundation.dart';
import '../application/financial_analytics_use_case.dart';
import '../../sales/domain/sale.dart';
import '../../sales/domain/sale_repository.dart';

enum DateRangeFilter { today, last7Days, last30Days, allTime }

class DashboardController extends ChangeNotifier {
  final FinancialAnalyticsUseCase analyticsUseCase;
  final SaleRepository saleRepository;

  DateRangeFilter _selectedFilter = DateRangeFilter.last30Days;
  late FinancialSummary _summary;
  List<Sale> _recentSales = [];

  DashboardController({
    required this.analyticsUseCase,
    required this.saleRepository,
  });

  DateRangeFilter get selectedFilter => _selectedFilter;
  FinancialSummary get summary => _summary;
  List<Sale> get recentSales => _recentSales;

  void init() {
    refreshData();
  }

  void setFilter(DateRangeFilter filter) {
    _selectedFilter = filter;
    refreshData();
  }

  void refreshData() {
    final now = DateTime.now();
    DateTime? start;

    switch (_selectedFilter) {
      case DateRangeFilter.today:
        start = DateTime(now.year, now.month, now.day);
        break;
      case DateRangeFilter.last7Days:
        start = now.subtract(const Duration(days: 7));
        break;
      case DateRangeFilter.last30Days:
        start = now.subtract(const Duration(days: 30));
        break;
      case DateRangeFilter.allTime:
        start = null;
        break;
    }

    _summary = analyticsUseCase.calculateSummary(startDate: start);
    _recentSales = saleRepository.getAll().reversed.take(10).toList();
    notifyListeners();
  }
}
