import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/main_navigation_shell.dart';
import 'core/config/api_config.dart';
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
import 'features/inventory/domain/cost_layer_service.dart';
import 'features/inventory/infrastructure/drift_cost_layer_repository.dart';
import 'features/orders/application/fulfill_order_use_case.dart';
import 'features/orders/application/order_payment_use_case.dart';
import 'features/orders/application/process_stock_out_use_case.dart';
import 'features/orders/application/submit_order_use_case.dart';
import 'features/orders/infrastructure/drift_order_repository.dart';
import 'features/inventory/infrastructure/drift_inventory_repository.dart';
import 'features/products/application/product_use_cases.dart';
import 'features/products/domain/product_repository.dart';
import 'features/products/infrastructure/drift_product_repository.dart';
import 'features/production/application/execute_production_use_case.dart';
import 'features/production/application/process_production_batch_use_case.dart';
import 'features/production/application/record_production_output_use_case.dart';
import 'features/purchasing/domain/purchase_repository.dart';
import 'features/purchasing/infrastructure/drift_purchase_repository.dart';
import 'features/receiving/application/receive_goods_use_case.dart';
import 'features/receiving/domain/receiving_repository.dart';
import 'features/receiving/infrastructure/drift_receiving_repository.dart';
import 'features/recipes/application/recipe_use_cases.dart';
import 'features/recipes/domain/recipe_repository.dart';
import 'features/recipes/infrastructure/drift_recipe_repository.dart';
import 'features/sales/application/process_sale_use_case.dart';
import 'features/sales/infrastructure/drift_sale_repository.dart';
import 'features/sales/presentation/pos_controller.dart';
import 'features/sync/application/auto_sync_worker.dart';
import 'features/sync/application/sync_enqueue_service.dart';
import 'features/sync/application/sync_orchestrator.dart';
import 'features/sync/domain/auth_repository.dart';
import 'features/sync/infrastructure/drift_master_data_pull_repository.dart';
import 'features/sync/infrastructure/drift_sync_queue_repository.dart';
import 'features/sync/infrastructure/drift_sync_state_repository.dart';
import 'features/sync/infrastructure/http_sync_api_client.dart';
import 'features/sync/infrastructure/local_pull_state_repository.dart';
import 'features/sync/infrastructure/local_auth_repository.dart';
import 'features/sync/infrastructure/remote_auth_repository.dart';

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

  final syncQueueRepository = DriftSyncQueueRepository(db);
  final syncEnqueueService = SyncEnqueueService(
    repository: syncQueueRepository,
  );

  // Sinkronisasi offline-first: orchestrator + worker otomatis saat online.
  final syncOrchestrator = SyncOrchestrator(
    queueRepository: syncQueueRepository,
    apiClient: HttpSyncApiClient(baseUri: Uri.parse(ApiConfig.baseUrl)),
    syncStateRepository: DriftSyncStateRepository(db),
    masterDataRepository: DriftMasterDataPullRepository(db),
    pullStateRepository: LocalPullStateRepository(prefs),
  );
  final authRepository = LocalAuthRepository(prefs);
  final remoteAuthRepository = RemoteAuthRepository(
    baseUri: Uri.parse(ApiConfig.baseUrl),
  );
  final autoSyncWorker = AutoSyncWorker(
    orchestrator: syncOrchestrator,
    queueRepository: syncQueueRepository,
    authRepository: authRepository,
    connectivityStream: Connectivity().onConnectivityChanged,
  );
  autoSyncWorker.start();

  final productUseCases = ProductUseCases(
    repository: productRepo,
    syncEnqueueService: syncEnqueueService,
  );

  final recipeRepo = DriftRecipeRepository(db);
  await recipeRepo.init();
  final recipeUseCases = RecipeUseCases(
    repository: recipeRepo,
    productRepository: productRepo,
  );

  final saleRepo = DriftSaleRepository(db);
  await saleRepo.init();

  // 3. Repositories (Drift persistence)
  final inventoryRepo = DriftInventoryRepository(db);
  final costLayerRepo = DriftCostLayerRepository(db);
  final purchaseRepo = DriftPurchaseRepository(db);
  final receivingRepo = DriftReceivingRepository(db);

  // 4. Use cases
  // Sale = financial record (tanpa konsumsi stok). Stok dikonsumsi saat
  // stock-out (handover/pickup) melalui ProcessStockOutUseCase.
  final processSaleUseCase = ProcessSaleUseCase(
    saleRepository: saleRepo,
    syncEnqueueService: syncEnqueueService,
  );

  final orderRepository = DriftOrderRepository(db);
  await orderRepository.init();
  final submitOrderUseCase = SubmitOrderUseCase(
    processSaleUseCase: processSaleUseCase,
    saleRepository: saleRepo,
    orderRepository: orderRepository,
    syncEnqueueService: syncEnqueueService,
  );
  final orderPaymentUseCase = OrderPaymentUseCase(
    orderRepository: orderRepository,
  );
  final processStockOutUseCase = ProcessStockOutUseCase(
    costLayerService: CostLayerService(repository: costLayerRepo),
    costLayerRepository: costLayerRepo,
    inventoryRepository: inventoryRepo,
    saleRepository: saleRepo,
  );
  final fulfillOrderUseCase = FulfillOrderUseCase(
    orderRepository: orderRepository,
    saleRepository: saleRepo,
    processStockOutUseCase: processStockOutUseCase,
  );
  final receiveGoodsUseCase = ReceiveGoodsUseCase(
    receivingRepository: receivingRepo,
    inventoryRepository: inventoryRepo,
    costLayerRepository: costLayerRepo,
    syncEnqueueService: syncEnqueueService,
  );
  final processProductionBatchUseCase = ProcessProductionBatchUseCase(
    costLayerRepository: costLayerRepo,
    inventoryRepository: inventoryRepo,
  );
  final recordProductionOutputUseCase = RecordProductionOutputUseCase(
    costLayerRepository: costLayerRepo,
    inventoryRepository: inventoryRepo,
  );
  final executeProductionUseCase = ExecuteProductionUseCase(
    processBatchUseCase: processProductionBatchUseCase,
    recordOutputUseCase: recordProductionOutputUseCase,
    productRepository: productRepo,
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
    submitOrderUseCase: submitOrderUseCase,
    orderPaymentUseCase: orderPaymentUseCase,
    fulfillOrderUseCase: fulfillOrderUseCase,
    saleRepository: saleRepo,
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
    executeProductionUseCase: executeProductionUseCase,
    productUseCases: productUseCases,
    recipeUseCases: recipeUseCases,
    recipeRepository: recipeRepo,
    syncEnqueueService: syncEnqueueService,
    authRepository: authRepository,
    remoteAuthRepository: remoteAuthRepository,
    autoSyncWorker: autoSyncWorker,
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
  final ExecuteProductionUseCase executeProductionUseCase;
  final ProductUseCases productUseCases;
  final RecipeUseCases recipeUseCases;
  final RecipeRepository recipeRepository;
  final SyncEnqueueService syncEnqueueService;
  final AuthRepository authRepository;
  final RemoteAuthRepository remoteAuthRepository;
  final AutoSyncWorker autoSyncWorker;

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
    required this.executeProductionUseCase,
    required this.productUseCases,
    required this.recipeUseCases,
    required this.recipeRepository,
    required this.syncEnqueueService,
    required this.authRepository,
    required this.remoteAuthRepository,
    required this.autoSyncWorker,
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
              executeProductionUseCase: executeProductionUseCase,
              productUseCases: productUseCases,
              recipeUseCases: recipeUseCases,
              recipeRepository: recipeRepository,
              syncEnqueueService: syncEnqueueService,
              authRepository: authRepository,
              remoteAuthRepository: remoteAuthRepository,
              autoSyncWorker: autoSyncWorker,
            ),
          ),
        );
      },
    );
  }
}
