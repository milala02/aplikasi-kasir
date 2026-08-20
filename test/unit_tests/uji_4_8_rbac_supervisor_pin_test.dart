import 'package:flutter_test/flutter_test.dart';

enum UserRole { cashier, supervisor, admin }

class AuthService {
  final String _supervisorPin = '8888';
  final Map<String, int> _failedPinAttempts = {};

  bool canPerformVoidWithoutPin(UserRole role) {
    return role == UserRole.supervisor || role == UserRole.admin;
  }

  bool verifySupervisorPin(String userId, String inputPin) {
    int attempts = _failedPinAttempts[userId] ?? 0;
    if (attempts >= 3) {
      throw StateError('Akses terkunci. Terlalu banyak percobaan PIN salah.');
    }

    if (inputPin == _supervisorPin) {
      _failedPinAttempts[userId] = 0;
      return true;
    } else {
      _failedPinAttempts[userId] = attempts + 1;
      return false;
    }
  }

  bool authorizeDiscount(UserRole role, double discountPercentage, String? supervisorPin) {
    // Kasir biasa maksimal diskon 15% tanpa PIN
    if (discountPercentage <= 15.0) return true;
    if (role == UserRole.cashier && supervisorPin == _supervisorPin) return true;
    if (role == UserRole.supervisor || role == UserRole.admin) return true;
    return false;
  }
}

void main() {
  group('Uji 4.8 - RBAC & Supervisor PIN Override Validation', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('4.8.1 - Kasir biasa tidak bisa Void tanpa PIN Supervisor', () {
      expect(authService.canPerformVoidWithoutPin(UserRole.cashier), isFalse);
      expect(authService.canPerformVoidWithoutPin(UserRole.supervisor), isTrue);
    });

    test('4.8.2 - Verifikasi PIN Supervisor yang benar mengizinkan Void', () {
      bool isAuthorized = authService.verifySupervisorPin('cashier_01', '8888');
      expect(isAuthorized, isTrue);
    });

    test('4.8.3 - Diskon di atas 15% ditolak jika PIN Supervisor salah', () {
      bool invalidDiscount = authService.authorizeDiscount(UserRole.cashier, 25.0, '1234');
      bool validDiscount = authService.authorizeDiscount(UserRole.cashier, 25.0, '8888');

      expect(invalidDiscount, isFalse);
      expect(validDiscount, isTrue);
    });

    test('4.8.4 - Proteksi Brute Force: Terkunci setelah 3 kali PIN salah', () {
      const userId = 'cashier_02';
      authService.verifySupervisorPin(userId, '1111');
      authService.verifySupervisorPin(userId, '2222');
      authService.verifySupervisorPin(userId, '3333');

      expect(
        () => authService.verifySupervisorPin(userId, '8888'),
        throwsA(isA<StateError>()),
      );
    });
  });
}
