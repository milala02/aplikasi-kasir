import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_kasir/core/security/auth_service.dart';
import 'package:aplikasi_kasir/features/auth/presentation/pin_screen.dart';

void main() {
  testWidgets('PinScreen merender mode Setup saat instalasi pertama (belum ada PIN)', (WidgetTester tester) async {
    // 1. Mock SharedPreferences kosong (belum ada PIN tersimpan)
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final authService = AuthService(prefs);

    // 2. Render PinScreen langsung (tanpa memerlukan seluruh dependensi MyApp)
    await tester.pumpWidget(MaterialApp(
      home: PinScreen(
        authService: authService,
        child: const Scaffold(body: Text('Dashboard')),
      ),
    ));
    await tester.pumpAndSettle();

    // 3. Verifikasi: Mode setup PIN muncul (bukan dashboard)
    expect(find.text('Buat PIN Baru'), findsOneWidget);
    expect(find.text('Dashboard'), findsNothing);
  });

  testWidgets('PinScreen menampilkan child langsung jika PIN sudah diatur dan benar', (WidgetTester tester) async {
    // 1. Siapkan SharedPreferences dengan PIN yang sudah diatur
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final authService = AuthService(prefs);
    await authService.setupPin('123456', 'recovery');

    // 2. Render PinScreen
    await tester.pumpWidget(MaterialApp(
      home: PinScreen(
        authService: authService,
        child: const Scaffold(body: Text('Dashboard')),
      ),
    ));
    await tester.pumpAndSettle();

    // 3. Verifikasi: Mode verifikasi PIN muncul (bukan dashboard)
    expect(find.text('Masukkan PIN Anda'), findsOneWidget);
    expect(find.text('Dashboard'), findsNothing);
  });
}
