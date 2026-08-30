/// Penyimpanan sesi auth (JWT) untuk sinkronisasi.
abstract interface class AuthRepository {
  String? getToken();

  Future<void> saveToken(String token);

  Future<void> clearToken();
}
