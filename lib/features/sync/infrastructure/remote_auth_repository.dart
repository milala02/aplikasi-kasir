import 'dart:convert';

import 'package:http/http.dart' as http;

/// Login ke backend `/api/v1/auth/login` dan mengembalikan JWT.
///
/// Kontrak respons bersifat toleran: menerima `token` atau `access_token`.
class RemoteAuthRepository {
  final Uri baseUri;
  final http.Client _client;

  RemoteAuthRepository({
    required this.baseUri,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<String> login({
    required String username,
    required String password,
  }) async {
    final uri = baseUri.resolve('/api/v1/auth/login');
    final response = await _client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RemoteAuthException(
        'Login gagal (${response.statusCode}): ${response.body}',
      );
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw const RemoteAuthException('Respons login tidak valid.');
    }

    final token = body['token'] ?? body['access_token'];
    if (token is! String || token.isEmpty) {
      throw const RemoteAuthException('Token tidak ditemukan di respons.');
    }

    return token;
  }
}

class RemoteAuthException implements Exception {
  final String message;

  const RemoteAuthException(this.message);

  @override
  String toString() => message;
}
