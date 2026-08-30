import 'package:shared_preferences/shared_preferences.dart';

import '../domain/auth_repository.dart';

/// Penyimpanan token lokal via shared_preferences (dependensi existing).
/// Catatan: untuk produksi pertimbangkan flutter_secure_storage —
/// keputusan dependensi keamanan belum diambil.
class LocalAuthRepository implements AuthRepository {
  static const String _tokenKey = 'sync_jwt_token';

  final SharedPreferences _prefs;

  LocalAuthRepository(this._prefs);

  @override
  String? getToken() => _prefs.getString(_tokenKey);

  @override
  Future<void> saveToken(String token) async {
    await _prefs.setString(_tokenKey, token);
  }

  @override
  Future<void> clearToken() async {
    await _prefs.remove(_tokenKey);
  }
}
