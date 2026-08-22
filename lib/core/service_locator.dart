import 'package:get_it/get_it.dart';
import 'package:drift/drift.dart';
import 'package:provider/provider.dart';
import '../core/database/app_database.dart';
import '../features/products/infrastructure/drift_product_repository.dart';
import '../features/products/domain/product_repository.dart';
import '../features/sales/infrastructure/drift_sales_repository.dart';
import '../features/sales/domain/sales_repository.dart';
import '../features/cart/infrastructure/drift_cart_repository.dart';
import '../features/cart/domain/cart_repository.dart';
import '../features/products/application/product_use_cases.dart';
import '../features/sales/application/sales_use_cases.dart';
import '../features/cart/application/cart_use_cases.dart';
import '../app/presentation/pos_controller.dart';
import '../app/presentation/dashboard_controller.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Database
  final database = AppDatabase();
  getIt.registerSingleton<AppDatabase>(database);

  // Repositories (Drift implementations)
  getIt.registerSingleton<ProductRepository>(
    DriftProductRepository(getIt<AppDatabase>()),
  );
  
  getIt.registerSingleton<SalesRepository>(
    DriftSalesRepository(getIt<AppDatabase>()),
  );
  
  getIt.registerSingleton<CartRepository>(
    DriftCartRepository(getIt<AppDatabase>()),
  );

  // Use Cases
  getIt.registerSingleton<ProductUseCases>(
    ProductUseCases(getIt<ProductRepository>()),
  );
  
  getIt.registerSingleton<SalesUseCases>(
    SalesUseCases(getIt<SalesRepository>()),
  );
  
  getIt.registerSingleton<CartUseCases>(
    CartUseCases(getIt<CartRepository>()),
  );

  // Controllers
  getIt.registerSingleton<POSController>(
    POSController(
      productUseCases: getIt<ProductUseCases>(),
      salesUseCases: getIt<SalesUseCases>(),
      cartUseCases: getIt<CartUseCases>(),
    ),
  );
  
  getIt.registerSingleton<DashboardController>(
    DashboardController(
      salesUseCases: getIt<SalesUseCases>(),
    ),
  );
}

/// Extension to easily access GetIt instance in Provider context
extension GetItExtension on BuildContext {
  T read<T extends Object>() => getIt<T>();
  T watch<T extends Object>() => getIt<T>();
}
