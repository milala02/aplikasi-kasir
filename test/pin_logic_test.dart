import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_kasir/core/security/auth_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('VERIFIKASI LOGIKA PIN: Awal Kosong -> Simpan PIN -> Status Lock Aktif', () async {
    // Simulasi penyimpanan lokal (SharedPreferences) kosong
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final auth = AuthService(prefs);

    // 1. Kondisi Awal: Aplikasi baru belum punya PIN
    expect(auth.hasPin, false, reason: 'Aplikasi baru harus bernilai hasPin = false');

    // 2. Simpan PIN Baru (misal: 123456)
    await auth.setupPin('123456', 'default_recovery');

    // 3. Kondisi Setelah Simpan: hasPin Wajib True
    expect(auth.hasPin, true, reason: 'Setelah setupPin, hasPin Wajib bernilai true');

    // 4. Pengujian Verifikasi PIN
    expect(auth.verifyPin('123456'), true, reason: 'PIN 123456 harus valid');
    expect(auth.verifyPin('000000'), false, reason: 'PIN salah harus ditolak');
  });
}
