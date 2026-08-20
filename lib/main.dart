import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/pos_provider.dart';
import 'views/pos_dashboard_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PosProvider(),
      child: MaterialApp(
        title: 'POS Production',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            primary: Colors.blue,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: false,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
        ),
        home: const PosDashboardScreen(),
      ),
    );
  }
}
