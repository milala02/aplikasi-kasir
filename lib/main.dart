import 'package:flutter/material.dart';

// Database
import 'core/database/app_database.dart';

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
  // Pastikan binding Flutter terinisialisasi sebelum memanggil platform channel (seperti path_provider untuk SQLite)
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inisialisasi Database Lokal (SQLite / Drift)
  final db = AppDatabase();

  // 2. Inisialisasi Repositories (Dependency Injection)
  final productRepo = DriftProductRepository(db);
  await productRepo.init(); // Load cache dari SQLite
  
  final customerRepo = DriftCustomerRepository(db);
  await customerRepo.init(); // Load cache dari SQLite

  // (Gunakan InMemory sementara untuk modul yang belum di-migrate ke Drift penuh di tutorial ini)
  final costLayerRepo = InMemoryCostLayerRepository();
  final inventoryRepo = InMemoryInventoryRepository();
  final saleRepo = InMemorySaleRepository();

  // 3. Inisialisasi Use Cases
  final processSaleUseCase = ProcessSaleUseCase(
    saleRepository: saleRepo,
    inventoryRepository: inventoryRepo,
  );
  
  final financialAnalyticsUseCase = FinancialAnalyticsUseCase(
    saleRepository: saleRepo,
  );

  // 4. Inisialisasi State Management Controllers
  final dashboardController = DashboardController(
    analyticsUseCase: financialAnalyticsUseCase,
    saleRepository: saleRepo,
  );
  
  final posController = POSController(
    productRepository: productRepo,
    customerRepository: customerRepo,
    processSaleUseCase: processSaleUseCase,
  );

  // 5. Jalankan Aplikasi
  runApp(KasirApp(
    dashboardController: dashboardController,
    posController: posController,
    costLayerRepository: costLayerRepo,
    customerRepository: customerRepo,
  ));
}

class KasirApp extends StatelessWidget {
  final DashboardController dashboardController;
  final POSController posController;
  final InMemoryCostLayerRepository costLayerRepository;
  final DriftCustomerRepository customerRepository;

  const KasirApp({
    super.key,
    required this.dashboardController,
    required this.posController,
    required this.costLayerRepository,
    required this.customerRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir POS Warung',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          elevation: 4,
        ),
      ),
      home: MainNavigationShell(
        dashboardController: dashboardController,
        posController: posController,
        costLayerRepository: costLayerRepository,
        customerRepository: customerRepository,
      ),
    );
  }
}
