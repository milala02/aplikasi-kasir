
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../domain/master_data_pull.dart';
import '../domain/sync_api_client.dart';
import '../domain/sync_queue_entry.dart';

class HttpSyncApiClient implements SyncApiClient {
  final Uri baseUri;
  final http.Client _client;

  HttpSyncApiClient({
    required this.baseUri,
    http.Client? client,
  }) : _client = client ?? http.Client();

  @override
  Future<void> push(SyncQueueEntry entry, {String? authToken}) async {
    final uri = baseUri.resolve(entry.endpoint);
    final headers = <String, String>{
      'Content-Type': 'application/json',
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };

    final response = await _client
        .post(uri, headers: headers, body: entry.payloadJson);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpSyncException(
        'Push gagal (${response.statusCode}): ${response.body}',
      );
    }
  }

  @override
  Future<MasterDataPull> pull({DateTime? since, String? authToken}) async {
    final uri = baseUri.resolveUri(Uri(
      path: '/api/v1/sync/pull',
      queryParameters: {
        if (since != null) 'since': since.toUtc().toIso8601String(),
      },
    ));
    final headers = <String, String>{
      if (authToken != null) 'Authorization': 'Bearer $authToken',
    };

    final response = await _client.get(uri, headers: headers);

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw HttpSyncException(
        'Pull gagal (${response.statusCode}): ${response.body}',
      );
    }

    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw HttpSyncException('Respons pull tidak valid.');
    }
    try {
      return MasterDataPull.fromJson(body);
    } on FormatException catch (e) {
      throw HttpSyncException(e.message);
    }
  }
}

class HttpSyncException implements Exception {
  final String message;

  HttpSyncException(this.message);

  @override
  String toString() => message;
}
