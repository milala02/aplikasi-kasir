import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/main_navigation_shell.dart';
import 'core/database/app_database.dart';
import 'core/security/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/presentation/pin_screen.dart';
import 'features/customers/domain/customer_repository.dart';
import 'features/customers/infrastructure/drift_customer_repository.dart';
import 'features/dashboard/application/financial_analytics_use_case.dart';
import 'features/dashboard/presentation/dashboard_controller.dart';
import 'features/inventory/domain/cost_layer_repository.dart';
import 'features/inventory/infrastructure/drift_cost_layer_repository.dart';
import 'features/inventory/infrastructure/drift_inventory_repository.dart';
import 'features/products/infrastructure/drift_product_repository.dart';
import 'features/sales/application/process_sale_use_case.dart';
import 'features/sales/infrastructure/drift_sale_repository.dart';
import 'features/sales/presentation/pos_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final authService = AuthService(prefs);

  // --- Composition Root: wire up the Clean Architecture stack ---
  final db = AppDatabase();

  final productRepo = DriftProductRepository(db);
  final saleRepo = DriftSaleRepository(db);
  final inventoryRepo = DriftInventoryRepository(db);
  final CostLayerRepository costLayerRepo = DriftCostLayerRepository(db);
  final driftCustomerRepo = DriftCustomerRepository(db);
  final CustomerRepository customerRepo = driftCustomerRepo;

  // Initialise repositories that pre-load from DB
  await productRepo.init();
  await driftCustomerRepo.init();

  final processSaleUseCase = ProcessSaleUseCase(
    saleRepository: saleRepo,
    inventoryRepository: inventoryRepo,
  );

  final analyticsUseCase = FinancialAnalyticsUseCase(saleRepository: saleRepo);

  final themeController = ThemeController();

  final dashboardController = DashboardController(
    analyticsUseCase: analyticsUseCase,
    saleRepository: saleRepo,
  );

  final posController = POSController(
    productRepository: productRepo,
    customerRepository: customerRepo,
    processSaleUseCase: processSaleUseCase,
  );

  runApp(
    MyApp(
      authService: authService,
      themeController: themeController,
      dashboardController: dashboardController,
      posController: posController,
      costLayerRepo: costLayerRepo,
      customerRepo: customerRepo,
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final ThemeController themeController;
  final DashboardController dashboardController;
  final POSController posController;
  final CostLayerRepository costLayerRepo;
  final CustomerRepository customerRepo;

  const MyApp({
    super.key,
    required this.authService,
    required this.themeController,
    required this.dashboardController,
    required this.posController,
    required this.costLayerRepo,
    required this.customerRepo,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: themeController,
      child: Consumer<ThemeController>(
        builder: (context, theme, _) {
          return MaterialApp(
            title: 'Smart Warung POS',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: theme.themeMode,
            home: PinScreen(
              authService: authService,
              child: MainNavigationShell(
                dashboardController: dashboardController,
                posController: posController,
                costLayerRepository: costLayerRepo,
                customerRepository: customerRepo,
                themeController: themeController,
              ),
            ),
          );
        },
      ),
    );
  }
}
