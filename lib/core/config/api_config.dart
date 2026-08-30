/// Konfigurasi endpoint backend sinkronisasi.
/// URL dapat di-override saat build via:
/// `flutter run --dart-define=API_BASE_URL=https://<vps>:3000`
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );
}
