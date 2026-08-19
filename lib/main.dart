import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/security/auth_service.dart';
import 'features/auth/presentation/pin_screen.dart';

// Database
import 'core/database/app_database.dart';

// Tema
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';

// Repositories
import 'features/products/infrastructure/drift_product_repository.dart';
import 'features/customers/infrastructure/drift_customer_repository.dart';
import 'features/inventory/infrastructure/in_memory_cost_layer_repository.dart';
import 'features/inventory/infrastructure/in_memory_inventory_repository.dart';
import 'features/sales/infrastructure/in_memory_sale_repository.dart';

// Use Cases
import 'features/sales/application/process_sale_use_case.dart';
import 'features/dashboard/application/financial_analytics_use_case.dart';

// Controllers
import 'features/dashboard/presentation/dashboard_controller.dart';
import 'features/sales/presentation/pos_controller.dart';

// UI Shell
import 'app/main_navigation_shell.dart';

void main() async {
    final prefs = await SharedPreferences.getInstance();
  final authService = AuthService(prefs);

  
  final db = AppDatabase();

  final productRepo = DriftProductRepository(db);
  await productRepo.init(); 
  
  final customerRepo = DriftCustomerRepository(db);
  await customerRepo.init();

  final costLayerRepo = InMemoryCostLayerRepository();
  final inventoryRepo = InMemoryInventoryRepository();
  final saleRepo = InMemorySaleRepository();

  final processSaleUseCase = ProcessSaleUseCase(saleRepository: saleRepo, inventoryRepository: inventoryRepo);
  final financialAnalyticsUseCase = FinancialAnalyticsUseCase(saleRepository: saleRepo);

  final dashboardController = DashboardController(analyticsUseCase: financialAnalyticsUseCase, saleRepository: saleRepo);
  final posController = POSController(productRepository: productRepo, customerRepository: customerRepo, processSaleUseCase: processSaleUseCase);
  
  // Inisiasi Kontrol Tema
  final themeController = ThemeController();

  runApp(KasirApp(
    dashboardController: dashboardController,
    posController: posController,
    costLayerRepository: costLayerRepo,
    customerRepository: customerRepo,
    themeController: themeController,
    authService: authService,
  ));
}

class KasirApp extends StatefulWidget {
  final DashboardController dashboardController;
  final POSController posController;
  final InMemoryCostLayerRepository costLayerRepository;
  final DriftCustomerRepository customerRepository;
  final ThemeController themeController;
  final AuthService authService;

  const KasirApp({
    super.key,
    required this.dashboardController,
    required this.posController,
    required this.costLayerRepository,
    required this.customerRepository,
    required this.themeController,
    required this.authService,
  });

  @override
  State<KasirApp> createState() => _KasirAppState();
}

class _KasirAppState extends State<KasirApp> {
  @override
  void initState() {
    super.initState();
    widget.themeController.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    widget.themeController.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {}); // Rebuild aplikasi saat tema berganti
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir POS Warung',
      debugShowCheckedModeBanner: false,
      themeMode: widget.themeController.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: PinScreen(
        authService: widget.authService,
        child: MainNavigationShell(
        dashboardController: widget.dashboardController,
        posController: widget.posController,
        costLayerRepository: widget.costLayerRepository,
        customerRepository: widget.customerRepository,
        themeController: widget.themeController,
        ),
      ),
    );
  }
}
