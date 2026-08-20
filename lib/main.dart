import 'package:flutter/material.dart';
import 'features/inventory/infrastructure/drift_inventory_repository.dart';
import 'features/sales/infrastructure/drift_sale_repository.dart';
import 'features/inventory/infrastructure/drift_cost_layer_repository.dart';

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
import 'features/customers/domain/customer_repository.dart';
import 'features/inventory/domain/cost_layer_repository.dart';

// Use Cases
import 'features/sales/application/process_sale_use_case.dart';
import 'features/dashboard/application/financial_analytics_use_case.dart';

// Controllers
import 'features/dashboard/presentation/dashboard_controller.dart';
import 'features/sales/presentation/pos_controller.dart';

// UI Shell
import 'app/main_navigation_shell.dart';

void main() async {
  // 1. WAJIB: Inisialisasi binding native Flutter sebelum panggil plugin
  WidgetsFlutterBinding.ensureInitialized();

  try {
    final prefs = await SharedPreferences.getInstance();
    final authService = AuthService(prefs);

    final db = AppDatabase();

    final productRepo = DriftProductRepository(db);
    await productRepo.init(); 
    
    final customerRepo = DriftCustomerRepository(db);
    await customerRepo.init();

    final costLayerRepo = DriftCostLayerRepository(db);
    final inventoryRepo = DriftInventoryRepository(db);
    final saleRepo = DriftSaleRepository(db);

    final processSaleUseCase = ProcessSaleUseCase(saleRepository: saleRepo, inventoryRepository: inventoryRepo);
    final financialAnalyticsUseCase = FinancialAnalyticsUseCase(saleRepository: saleRepo);

    final dashboardController = DashboardController(analyticsUseCase: financialAnalyticsUseCase, saleRepository: saleRepo);
    final posController = POSController(productRepository: productRepo, customerRepository: customerRepo, processSaleUseCase: processSaleUseCase);
    
    final themeController = ThemeController();

    runApp(KasirApp(
      dashboardController: dashboardController,
      posController: posController,
      costLayerRepository: costLayerRepo,
      customerRepository: customerRepo,
      themeController: themeController,
      authService: authService,
    ));
  } catch (e, stack) {
    // 2. Tangkap error jika inisialisasi gagal dan tampilkan ke layar HP
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red.shade900,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("⚠️ GAGAL INISIALISASI APLIKASI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 10),
                  Text("Error: $e", style: const TextStyle(color: Colors.yellow, fontSize: 14)),
                  const SizedBox(height: 10),
                  Text("Stacktrace:\n$stack", style: const TextStyle(color: Colors.white70, fontSize: 10)),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}

class KasirApp extends StatefulWidget {
  final DashboardController dashboardController;
  final POSController posController;
  final CostLayerRepository costLayerRepository;
  final CustomerRepository customerRepository;
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
    setState(() {});
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
