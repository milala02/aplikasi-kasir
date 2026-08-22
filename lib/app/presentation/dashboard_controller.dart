import 'package:flutter/material.dart';
import '../../features/sales/application/sales_use_cases.dart';
import '../../features/sales/domain/sale.dart';

class DashboardController extends ChangeNotifier {
  final SalesUseCases _salesUseCases;

  DashboardController({required SalesUseCases salesUseCases})
      : _salesUseCases = salesUseCases;

  // State
  List<Sale> _todaySales = [];
  double _totalRevenue = 0.0;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Sale> get todaySales => _todaySales;
  double get totalRevenue => _totalRevenue;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load today's sales
  Future<void> loadTodaysSales() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    final today = DateTime.now();
    final result = await _salesUseCases.getSalesByDate(today);

    result.fold(
      (failure) {
        _error = failure.toString();
        _isLoading = false;
        notifyListeners();
      },
      (sales) {
        _todaySales = sales;
        _totalRevenue = sales.fold<double>(
          0,
          (sum, sale) => sum + sale.totalAmount.minorUnits / 100,
        );
        _isLoading = false;
        notifyListeners();
      },
    );
  }

  // Refresh dashboard
  Future<void> refresh() async {
    await loadTodaysSales();
  }
}
