import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aplikasi_kasir/features/sync/domain/auth_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/local_auth_repository.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/remote_auth_repository.dart';
import 'package:aplikasi_kasir/features/sync/presentation/sync_login_controller.dart';

void main() {
  group('SyncLoginController', () {
    late RemoteAuthRepository remote;
    late AuthRepository local;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    SyncLoginController buildController(RemoteAuthRepository repository) {
      return SyncLoginController(
        remoteAuthRepository: repository,
        localAuthRepository: local,
      );
    }

    test('login sukses -> token tersimpan dan isLoggedIn true', () async {
      SharedPreferences.setMockInitialValues({});
      local = LocalAuthRepository(await SharedPreferences.getInstance());
      final mock = MockClient((request) async {
        expect(request.url.path, '/api/v1/auth/login');
        return http.Response('{"token":"jwt-abc"}', 200);
      });
      remote = RemoteAuthRepository(
        baseUri: Uri.parse('http://localhost:3000'),
        client: mock,
      );

      final controller = buildController(remote);
      final ok = await controller.login(
        username: 'owner',
        password: 'password123',
      );

      expect(ok, isTrue);
      expect(controller.error, isNull);
      expect(controller.isLoggedIn, isTrue);
      expect(local.getToken(), 'jwt-abc');

      await controller.logout();
      expect(controller.isLoggedIn, isFalse);
      expect(local.getToken(), isNull);
    });

    test('login gagal (401) -> error terisi, token tidak tersimpan',
        () async {
      local = LocalAuthRepository(await SharedPreferences.getInstance());
      remote = RemoteAuthRepository(
        baseUri: Uri.parse('http://localhost:3000'),
        client: MockClient((_) async => http.Response('unauthorized', 401)),
      );

      final controller = buildController(remote);
      final ok = await controller.login(
        username: 'owner',
        password: 'salah',
      );

      expect(ok, isFalse);
      expect(controller.error, isNotNull);
      expect(controller.isLoggedIn, isFalse);
    });

    test('input kosong -> gagal tanpa memanggil backend', () async {
      local = LocalAuthRepository(await SharedPreferences.getInstance());
      remote = RemoteAuthRepository(
        baseUri: Uri.parse('http://localhost:3000'),
        client: MockClient((_) async => http.Response('{}', 200)),
      );

      final controller = buildController(remote);
      final ok =
          await controller.login(username: '  ', password: '');

      expect(ok, isFalse);
      expect(controller.error, 'Username dan password wajib diisi.');
      expect(controller.isLoggedIn, isFalse);
    });

    test('network error -> error koneksi, tidak crash', () async {
      local = LocalAuthRepository(await SharedPreferences.getInstance());
      remote = RemoteAuthRepository(
        baseUri: Uri.parse('http://localhost:3000'),
        client: MockClient((_) async => throw Exception('timeout')),
      );

      final controller = buildController(remote);
      final ok = await controller.login(
        username: 'owner',
        password: 'password123',
      );

      expect(ok, isFalse);
      expect(controller.error, 'Gagal terhubung ke server.');
    });
  });
}
