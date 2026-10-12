import 'package:flutter/foundation.dart';

import '../application/financial_analytics_use_case.dart';
import '../../inventory/domain/cost_layer.dart';
import '../../inventory/domain/cost_layer_repository.dart';
import '../../products/domain/product.dart';
import '../../products/domain/product_repository.dart';
import '../../sales/domain/sale.dart';
import '../../sales/domain/sale_repository.dart';

enum DateRangeFilter { today, last7Days, last30Days, allTime }

class DashboardController extends ChangeNotifier {
  final FinancialAnalyticsUseCase analyticsUseCase;
  final SaleRepository saleRepository;
  final ProductRepository? productRepository;
  final CostLayerRepository? costLayerRepository;

  DateRangeFilter _selectedFilter = DateRangeFilter.last30Days;
  late FinancialSummary _summary;
  late FinancialSummary _todaySummary;
  List<Sale> _recentSales = [];
  List<Product> _products = [];
  List<CostLayer> _availableLayers = [];
  bool _stockLoading = false;

  DashboardController({
    required this.analyticsUseCase,
    required this.saleRepository,
    this.productRepository,
    this.costLayerRepository,
  });

  DateRangeFilter get selectedFilter => _selectedFilter;
  FinancialSummary get summary => _summary;
  FinancialSummary get todaySummary => _todaySummary;
  List<Sale> get recentSales => List.unmodifiable(_recentSales);
  bool get stockLoading => _stockLoading;
  List<MapEntry<String, int>> get stockAlerts {
    final names = {for (final product in _products) product.id: product.name};
    final quantities = <String, int>{};
    for (final layer in _availableLayers) {
      quantities.update(
        layer.productId,
        (value) => value + layer.remainingQuantity.value,
        ifAbsent: () => layer.remainingQuantity.value,
      );
    }
    return quantities.entries
        .where((entry) => entry.value <= 5)
        .map((entry) => MapEntry(names[entry.key] ?? entry.key, entry.value))
        .toList()
      ..sort((a, b) => a.value.compareTo(b.value));
  }

  List<MapEntry<String, double>> get lowestMarginProducts {
    final totals = <String, List<int>>{};
    final names = <String, String>{};
    for (final sale in _recentSales) {
      for (final item in sale.items) {
        names[item.productId] = item.productName;
        final values = totals.putIfAbsent(item.productId, () => [0, 0]);
        values[0] += item.subtotal.minorUnits;
        final unitCost = item.unitCost;
        if (unitCost != null) {
          values[1] += unitCost.multiply(item.quantity.value).minorUnits ~/ _quantityScale(item.quantity.scale);
        }
      }
    }
    final margins = <MapEntry<String, double>>[];
    for (final entry in totals.entries) {
      final revenue = entry.value[0];
      if (revenue <= 0) continue;
      margins.add(MapEntry(
        names[entry.key] ?? entry.key,
        (revenue - entry.value[1]) * 100 / revenue,
      ));
    }
    margins.sort((a, b) => a.value.compareTo(b.value));
    return margins.take(3).toList();
  }

  static int _quantityScale(int scale) {
    var factor = 1;
    for (var index = 0; index < scale; index++) {
      factor *= 10;
    }
    return factor;
  }

  double get marginPercentage {
    final revenue = _summary.totalOmset.minorUnits;
    return revenue == 0 ? 0 : _summary.grossProfit.minorUnits * 100 / revenue;
  }

  Future<void> refreshStock() async {
    final productsRepo = productRepository;
    final layersRepo = costLayerRepository;
    if (productsRepo == null || layersRepo == null) return;
    _products = productsRepo.getActive();
    _stockLoading = true;
    notifyListeners();
    try {
      final layers = await Future.wait(
        _products.map((product) => layersRepo.getAvailableByProductId(product.id)),
      );
      _availableLayers = [for (final productLayers in layers) ...productLayers];
    } finally {
      _stockLoading = false;
      notifyListeners();
    }
  }

  void init() {
    refreshData();
    refreshStock();
  }

  void setFilter(DateRangeFilter filter) {
    _selectedFilter = filter;
    refreshData();
  }

  void refreshData() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    DateTime? start;

    switch (_selectedFilter) {
      case DateRangeFilter.today:
        start = today;
      case DateRangeFilter.last7Days:
        start = today.subtract(const Duration(days: 6));
      case DateRangeFilter.last30Days:
        start = today.subtract(const Duration(days: 29));
      case DateRangeFilter.allTime:
        start = null;
    }

    _todaySummary = analyticsUseCase.calculateSummary(
      startDate: today,
      endDate: today.add(const Duration(days: 1)).subtract(const Duration(microseconds: 1)),
    );
    _summary = analyticsUseCase.calculateSummary(startDate: start);
    _recentSales = saleRepository.getAll();
    notifyListeners();
  }
}
