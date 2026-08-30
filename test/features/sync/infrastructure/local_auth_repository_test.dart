import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/local_auth_repository.dart';

void main() {
  group('LocalAuthRepository', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('simpan, baca, hapus token', () async {
      final prefs = await SharedPreferences.getInstance();
      final repository = LocalAuthRepository(prefs);

      expect(repository.getToken(), isNull);

      await repository.saveToken('jwt-abc');
      expect(repository.getToken(), 'jwt-abc');

      await repository.clearToken();
      expect(repository.getToken(), isNull);
    });
  });
}
