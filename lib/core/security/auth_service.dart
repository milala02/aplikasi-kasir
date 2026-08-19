import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _pinKey = 'app_secure_pin_hash';
  static const String _recoveryKey = 'app_recovery_phrase_hash';
  
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  // Fungsi internal untuk menghasilkan Hash SHA-256
  String _hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Cek apakah aplikasi sudah memiliki PIN yang terdaftar
  bool get hasPin => _prefs.getString(_pinKey) != null;

  // Mendaftarkan PIN baru beserta frasa pemulihan
  Future<void> setupPin(String pin, String recoveryPhrase) async {
    final hashedPin = _hashData(pin);
    final hashedRecovery = _hashData(recoveryPhrase.toLowerCase().trim());
    
    await _prefs.setString(_pinKey, hashedPin);
    await _prefs.setString(_recoveryKey, hashedRecovery);
  }

  // Memvalidasi PIN saat login
  bool verifyPin(String pin) {
    final savedHash = _prefs.getString(_pinKey);
    if (savedHash == null) return false;
    
    return _hashData(pin) == savedHash;
  }

  // Memvalidasi frasa pemulihan (jika lupa PIN)
  bool verifyRecoveryPhrase(String phrase) {
    final savedHash = _prefs.getString(_recoveryKey);
    if (savedHash == null) return false;
    
    return _hashData(phrase.toLowerCase().trim()) == savedHash;
  }

  // Mereset sistem keamanan (dipanggil setelah recovery berhasil)
  Future<void> resetSecurity() async {
    await _prefs.remove(_pinKey);
    await _prefs.remove(_recoveryKey);
  }
}
