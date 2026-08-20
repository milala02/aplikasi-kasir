import 'package:flutter_test/flutter_test.dart';

// Simulating API Client with Token Handling & Interceptors
class ApiClient {
  String? authToken;
  int retryCount = 0;

  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    if (authToken == null) throw Exception('401 Unauthorized');
    
    // Simulasi Network Failure
    if (endpoint == 'fail') throw Exception('500 Internal Server Error');
    
    return {'status': 'success', 'data': 'mock_data'};
  }
}

void main() {
  group('Uji 4.5 - API Network Service & Secure Token Validation', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient();
    });

    test('4.5.1 - API menolak request jika token tidak ditemukan (401)', () {
      expect(
        () async => await apiClient.fetchData('/products'),
        throwsA(predicate((e) => e.toString().contains('401 Unauthorized'))),
      );
    });

    test('4.5.2 - API sukses mengambil data jika token tersedia', () async {
      apiClient.authToken = 'VALID_TOKEN_123';
      final response = await apiClient.fetchData('/products');
      
      expect(response['status'], 'success');
      expect(response['data'], 'mock_data');
    });

    test('4.5.3 - API menangani Server Error (500) dengan exception', () async {
      apiClient.authToken = 'VALID_TOKEN_123';
      
      expect(
        () async => await apiClient.fetchData('fail'),
        throwsA(predicate((e) => e.toString().contains('500 Internal Server Error'))),
      );
    });
  });
}
