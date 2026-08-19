import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_kasir/main.dart';
import 'package:aplikasi_kasir/core/security/auth_service.dart';
import 'package:aplikasi_kasir/core/theme/theme_controller.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'package:aplikasi_kasir/features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'package:aplikasi_kasir/features/sales/infrastructure/in_memory_sale_repository.dart';
import 'package:aplikasi_kasir/features/products/infrastructure/in_memory_product_repository.dart';
import 'package:aplikasi_kasir/features/customers/infrastructure/in_memory_customer_repository.dart';
import 'package:aplikasi_kasir/features/sales/application/process_sale_use_case.dart';
import 'package:aplikasi_kasir/features/dashboard/application/financial_analytics_use_case.dart';
import 'package:aplikasi_kasir/features/dashboard/presentation/dashboard_controller.dart';
import 'package:aplikasi_kasir/features/sales/presentation/pos_controller.dart';

void main() {
  testWidgets('Smoke test: Inisialisasi KasirApp', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final authService = AuthService(prefs);

    final costLayerRepo = InMemoryCostLayerRepository();
    final inventoryRepo = InMemoryInventoryRepository();
    final saleRepo = InMemorySaleRepository();
    final productRepo = InMemoryProductRepository();
    final customerRepo = InMemoryCustomerRepository();

    final processSaleUseCase = ProcessSaleUseCase(saleRepository: saleRepo, inventoryRepository: inventoryRepo);
    final financialAnalyticsUseCase = FinancialAnalyticsUseCase(saleRepository: saleRepo);

    final dashboardController = DashboardController(analyticsUseCase: financialAnalyticsUseCase, saleRepository: saleRepo);
    final posController = POSController(productRepository: productRepo, customerRepository: customerRepo, processSaleUseCase: processSaleUseCase);
    final themeController = ThemeController();

    await tester.pumpWidget(KasirApp(
      dashboardController: dashboardController,
      posController: posController,
      costLayerRepository: costLayerRepo,
      customerRepository: customerRepo,
      themeController: themeController,
      authService: authService,
    ));

    expect(find.byType(KasirApp), findsOneWidget);
  });
}
