import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/remote_auth_repository.dart';

void main() {
  group('RemoteAuthRepository', () {
    test('200 dengan token -> mengembalikan JWT', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/api/v1/auth/login');
        expect(request.body, contains('"username":"kasir"'));
        return http.Response('{"token":"jwt-abc"}', 200);
      });

      final repository = RemoteAuthRepository(
        baseUri: Uri.parse('http://localhost:3000'),
        client: mock,
      );

      final token =
          await repository.login(username: 'kasir', password: 'pin123');
      expect(token, 'jwt-abc');
    });

    test('200 dengan access_token -> mengembalikan JWT', () async {
      final mock = MockClient((request) async {
        return http.Response('{"access_token":"jwt-def"}', 200);
      });

      final repository = RemoteAuthRepository(
        baseUri: Uri.parse('http://localhost:3000'),
        client: mock,
      );

      expect(
        await repository.login(username: 'kasir', password: 'pin123'),
        'jwt-def',
      );
    });

    test('401 -> throws RemoteAuthException', () async {
      final mock = MockClient(
          (request) async => http.Response('unauthorized', 401));

      final repository = RemoteAuthRepository(
        baseUri: Uri.parse('http://localhost:3000'),
        client: mock,
      );

      await expectLater(
        repository.login(username: 'kasir', password: 'salah'),
        throwsA(isA<RemoteAuthException>()),
      );
    });
  });
}
