import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:aplikasi_kasir/features/sync/domain/sync_queue_entry.dart';
import 'package:aplikasi_kasir/features/sync/infrastructure/http_sync_api_client.dart';

void main() {
  group('HttpSyncApiClient', () {
    SyncQueueEntry buildEntry() {
      final now = DateTime(2026, 8, 20);
      return SyncQueueEntry(
        id: 'sq_001',
        endpoint: '/api/v1/sync/push',
        sourceTable: 'orders',
        payloadJson: '{"id":"ord_1"}',
        status: SyncQueueStatus.pending,
        retryCount: 0,
        createdAt: now,
        updatedAt: now,
      );
    }

    test('200 -> sukses tanpa exception', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/api/v1/sync/push');
        expect(request.body, '{"id":"ord_1"}');
        expect(request.headers['Authorization'], 'Bearer jwt-123');
        return http.Response('{"ok":true}', 200);
      });

      final client = HttpSyncApiClient(
        baseUri: Uri.parse('http://localhost:3000'),
        client: mock,
      );

      await client.push(buildEntry(), authToken: 'jwt-123');
    });

    test('500 -> throws HttpSyncException', () async {
      final mock = MockClient(
          (request) async => http.Response('boom', 500));

      final client = HttpSyncApiClient(
        baseUri: Uri.parse('http://localhost:3000'),
        client: mock,
      );

      await expectLater(
        client.push(buildEntry()),
        throwsA(isA<HttpSyncException>()),
      );
    });
  });

  group('HttpSyncApiClient.pull', () {
    final baseUri = Uri.parse('http://localhost:3000');

    test('200 -> parse payload penuh (products/categories/uoms)', () async {
      final mock = MockClient((request) async {
        expect(request.url.path, '/api/v1/sync/pull');
        expect(request.url.queryParameters['since'],
            '2026-08-01T00:00:00.000Z');
        expect(request.headers['Authorization'], 'Bearer jwt-1');
        return http.Response('''
        {
          "products": [{
            "id": "550e8400-e29b-41d4-a716-446655440000",
            "sku": "BM-001",
            "name": "Bawang Merah",
            "stockUomId": "1bb4f570-213a-57d4-af43-52aacdb83f94",
            "categoryId": null,
            "isActive": true,
            "createdAt": "2026-08-01T00:00:00Z",
            "updatedAt": "2026-08-01T00:00:00Z"
          }],
          "categories": [{
            "id": "9c0e1234-e29b-41d4-a716-446655440001",
            "name": "Bumbu Dapur",
            "isActive": true,
            "createdAt": "2026-08-01T00:00:00Z",
            "updatedAt": "2026-08-01T00:00:00Z"
          }],
          "uoms": [{
            "id": "1bb4f570-213a-57d4-af43-52aacdb83f94",
            "name": "kilogram",
            "symbol": "kg",
            "isActive": true,
            "createdAt": "2026-08-01T00:00:00Z",
            "updatedAt": "2026-08-01T00:00:00Z"
          }]
        }
        ''', 200);
      });

      final client = HttpSyncApiClient(baseUri: baseUri, client: mock);
      final payload = await client.pull(
        since: DateTime.utc(2026, 8, 1),
        authToken: 'jwt-1',
      );

      expect(payload.products, hasLength(1));
      expect(payload.products.single.sku, 'BM-001');
      expect(payload.products.single.categoryId, isNull);
      expect(payload.categories.single.name, 'Bumbu Dapur');
      expect(payload.uoms.single.name, 'kilogram');
      expect(payload.uoms.single.symbol, 'kg');
    });

    test('tanpa since -> tidak mengirim query parameter', () async {
      final mock = MockClient((request) async {
        expect(request.url.queryParameters.containsKey('since'), isFalse);
        return http.Response(
            '{"products":[],"categories":[],"uoms":[]}', 200);
      });

      final client = HttpSyncApiClient(baseUri: baseUri, client: mock);
      final payload = await client.pull();

      expect(payload.products, isEmpty);
    });

    test('500 -> throws HttpSyncException', () async {
      final mock = MockClient(
          (request) async => http.Response('server error', 500));

      final client = HttpSyncApiClient(baseUri: baseUri, client: mock);

      await expectLater(
        client.pull(),
        throwsA(isA<HttpSyncException>()),
      );
    });

    test('payload tidak valid -> throws HttpSyncException', () async {
      final mock = MockClient(
          (request) async => http.Response('{"products": "bukan-array"}', 200));

      final client = HttpSyncApiClient(baseUri: baseUri, client: mock);

      await expectLater(
        client.pull(),
        throwsA(isA<HttpSyncException>()),
      );
    });
  });
}
