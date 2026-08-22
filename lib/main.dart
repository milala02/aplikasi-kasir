import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/service_locator.dart';
import 'app/presentation/pos_controller.dart';
import 'app/presentation/dashboard_controller.dart';
import 'views/pos_dashboard_screen.dart';
import 'views/initial_pin_setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependency injection
  await setupServiceLocator();
  
  final prefs = await SharedPreferences.getInstance();
  final bool isSetupDone = prefs.getBool('is_initial_setup_done') ?? false;

  runApp(MyApp(isSetupDone: isSetupDone));
}

class MyApp extends StatelessWidget {
  final bool isSetupDone;

  const MyApp({super.key, this.isSetupDone = false});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // POS Controller - Main business logic for POS operations
        ChangeNotifierProvider<POSController>(
          create: (_) => getIt<POSController>()..loadProducts(),
        ),
        // Dashboard Controller - Analytics and reporting
        ChangeNotifierProvider<DashboardController>(
          create: (_) => getIt<DashboardController>()..loadTodaysSales(),
        ),
      ],
      child: MaterialApp(
        title: 'POS Kasir',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: false,
        ),
        home: isSetupDone ? const PosDashboardScreen() : const InitialPinSetupScreen(),
      ),
    );
  }
}
