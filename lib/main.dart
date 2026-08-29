import 'package:flutter/material.dart';
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
import 'features/products/domain/product_repository.dart';
import 'features/products/infrastructure/drift_product_repository.dart';
import 'features/purchasing/domain/purchase_repository.dart';
import 'features/purchasing/infrastructure/drift_purchase_repository.dart';
import 'features/receiving/application/receive_goods_use_case.dart';
import 'features/receiving/domain/receiving_repository.dart';
import 'features/receiving/infrastructure/drift_receiving_repository.dart';
import 'features/sales/application/process_sale_use_case.dart';
import 'features/sales/infrastructure/drift_sale_repository.dart';
import 'features/sales/presentation/pos_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi shared preferences dan database
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase();
  final authService = AuthService(prefs);

  // 2. Inisialisasi repositories yang berbasis Drift (persistensi SQLite)
  final productRepo = DriftProductRepository(db);
  await productRepo.init();

  final customerRepo = DriftCustomerRepository(db);
  await customerRepo.init();

  final saleRepo = DriftSaleRepository(db);
  await saleRepo.init();

  // 3. Repositories (Drift persistence)
  final inventoryRepo = DriftInventoryRepository(db);
  final costLayerRepo = DriftCostLayerRepository(db);
  final purchaseRepo = DriftPurchaseRepository(db);
  final receivingRepo = DriftReceivingRepository(db);

  // 4. Use cases
  final processSaleUseCase = ProcessSaleUseCase(
    saleRepository: saleRepo,
    inventoryRepository: inventoryRepo,
  );
  final receiveGoodsUseCase = ReceiveGoodsUseCase(
    receivingRepository: receivingRepo,
    inventoryRepository: inventoryRepo,
    costLayerRepository: costLayerRepo,
  );

  // 5. Controllers
  final themeController = ThemeController();
  final analyticsUseCase = FinancialAnalyticsUseCase(saleRepository: saleRepo);
  final dashboardController = DashboardController(
    analyticsUseCase: analyticsUseCase,
    saleRepository: saleRepo,
  );
  final posController = POSController(
    productRepository: productRepo,
    customerRepository: customerRepo,
    processSaleUseCase: processSaleUseCase,
  );

  runApp(MyApp(
    authService: authService,
    themeController: themeController,
    dashboardController: dashboardController,
    posController: posController,
    costLayerRepository: costLayerRepo,
    customerRepository: customerRepo,
    productRepository: productRepo,
    purchaseRepository: purchaseRepo,
    receivingRepository: receivingRepo,
    receiveGoodsUseCase: receiveGoodsUseCase,
  ));
}

class MyApp extends StatelessWidget {
  final AuthService authService;
  final ThemeController themeController;
  final DashboardController dashboardController;
  final POSController posController;
  final CostLayerRepository costLayerRepository;
  final CustomerRepository customerRepository;
  final ProductRepository productRepository;
  final PurchaseRepository purchaseRepository;
  final ReceivingRepository receivingRepository;
  final ReceiveGoodsUseCase receiveGoodsUseCase;

  const MyApp({
    super.key,
    required this.authService,
    required this.themeController,
    required this.dashboardController,
    required this.posController,
    required this.costLayerRepository,
    required this.customerRepository,
    required this.productRepository,
    required this.purchaseRepository,
    required this.receivingRepository,
    required this.receiveGoodsUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Smart Warung POS',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode,
          home: PinScreen(
            authService: authService,
            child: MainNavigationShell(
              authService: authService,
              themeController: themeController,
              dashboardController: dashboardController,
              posController: posController,
              costLayerRepository: costLayerRepository,
              customerRepository: customerRepository,
              productRepository: productRepository,
              purchaseRepository: purchaseRepository,
              receivingRepository: receivingRepository,
              receiveGoodsUseCase: receiveGoodsUseCase,
            ),
          ),
        );
      },
    );
  }
}
