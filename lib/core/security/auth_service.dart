import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Peran pengguna di aplikasi.
enum UserRole {
  owner,   // Akses penuh: produk, laporan, pengaturan, diskon besar
  cashier, // Hanya akses transaksi kasir
}

/// Hasil percobaan verifikasi PIN.
enum PinVerifyResult {
  success,
  wrongPin,
  lockedOut, // Terkunci setelah melebihi batas percobaan
}

class AuthService {
  static const String _pinKey = 'app_secure_pin_hash';
  static const String _recoveryKey = 'app_recovery_phrase_hash';
  static const String _roleKey = 'app_user_role';
  static const String _failedAttemptsKey = 'app_pin_failed_attempts';
  static const String _lockoutUntilKey = 'app_pin_lockout_until';
  static const String _lastActivityKey = 'app_last_activity_ms';

  /// Batas percobaan PIN sebelum dikunci.
  static const int maxFailedAttempts = 5;

  /// Durasi kunci setelah melebihi batas percobaan (5 menit).
  static const Duration lockoutDuration = Duration(minutes: 5);

  /// Batas waktu tidak aktif sebelum sesi dikunci otomatis (15 menit).
  static const Duration sessionTimeout = Duration(minutes: 15);

  final SharedPreferences _prefs;

  AuthService(this._prefs);

  // -------------------------------------------------------------------------
  // Hashing
  // -------------------------------------------------------------------------
  String _hashData(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // -------------------------------------------------------------------------
  // Setup & Status
  // -------------------------------------------------------------------------

  /// Apakah aplikasi sudah memiliki PIN yang terdaftar.
  bool get hasPin => _prefs.getString(_pinKey) != null;

  /// Mendaftarkan PIN baru dengan peran dan frasa pemulihan.
  Future<void> setupPin(
    String pin,
    String recoveryPhrase, {
    UserRole role = UserRole.owner,
  }) async {
    final hashedPin = _hashData(pin);
    final hashedRecovery = _hashData(recoveryPhrase.toLowerCase().trim());
    await _prefs.setString(_pinKey, hashedPin);
    await _prefs.setString(_recoveryKey, hashedRecovery);
    await _prefs.setString(_roleKey, role.name);
    // Reset percobaan gagal saat PIN baru dibuat
    await _prefs.remove(_failedAttemptsKey);
    await _prefs.remove(_lockoutUntilKey);
    _updateActivity();
  }

  // -------------------------------------------------------------------------
  // RBAC
  // -------------------------------------------------------------------------

  /// Peran pengguna yang tersimpan; default ke [UserRole.owner].
  UserRole get role {
    final saved = _prefs.getString(_roleKey);
    if (saved == null) return UserRole.owner;
    return UserRole.values.firstWhere((r) => r.name == saved,
        orElse: () => UserRole.owner);
  }

  bool get isOwner => role == UserRole.owner;
  bool get isCashier => role == UserRole.cashier;

  // -------------------------------------------------------------------------
  // Brute-Force Protection
  // -------------------------------------------------------------------------

  int get _failedAttempts => _prefs.getInt(_failedAttemptsKey) ?? 0;

  DateTime? get _lockoutUntil {
    final ms = _prefs.getInt(_lockoutUntilKey);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  /// Apakah akun sedang terkunci karena terlalu banyak percobaan gagal.
  bool get isLockedOut {
    final until = _lockoutUntil;
    if (until == null) return false;
    return DateTime.now().isBefore(until);
  }

  /// Sisa waktu lockout dalam detik, atau 0 jika tidak terkunci.
  int get lockoutSecondsRemaining {
    final until = _lockoutUntil;
    if (until == null) return 0;
    final remaining = until.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  Future<void> _recordFailedAttempt() async {
    final attempts = _failedAttempts + 1;
    await _prefs.setInt(_failedAttemptsKey, attempts);
    if (attempts >= maxFailedAttempts) {
      final lockUntil =
          DateTime.now().add(lockoutDuration).millisecondsSinceEpoch;
      await _prefs.setInt(_lockoutUntilKey, lockUntil);
    }
  }

  Future<void> _clearFailedAttempts() async {
    await _prefs.remove(_failedAttemptsKey);
    await _prefs.remove(_lockoutUntilKey);
  }

  /// Sisa percobaan sebelum dikunci.
  int get remainingAttempts {
    return (maxFailedAttempts - _failedAttempts).clamp(0, maxFailedAttempts);
  }

  // -------------------------------------------------------------------------
  // Session Timeout
  // -------------------------------------------------------------------------

  /// Perbarui timestamp aktivitas terakhir (panggil saat ada interaksi).
  void updateActivity() => _updateActivity();

  void _updateActivity() {
    _prefs.setInt(_lastActivityKey, DateTime.now().millisecondsSinceEpoch);
  }

  /// Apakah sesi sudah kadaluarsa karena tidak aktif terlalu lama.
  bool get isSessionExpired {
    if (!hasPin) return false;
    final lastMs = _prefs.getInt(_lastActivityKey);
    if (lastMs == null) return true;
    final last = DateTime.fromMillisecondsSinceEpoch(lastMs);
    return DateTime.now().difference(last) > sessionTimeout;
  }

  // -------------------------------------------------------------------------
  // Verifikasi PIN
  // -------------------------------------------------------------------------

  /// Verifikasi PIN dengan perlindungan brute-force.
  Future<PinVerifyResult> verifyPinSecure(String pin) async {
    if (isLockedOut) return PinVerifyResult.lockedOut;

    final savedHash = _prefs.getString(_pinKey);
    if (savedHash == null) return PinVerifyResult.wrongPin;

    if (_hashData(pin) == savedHash) {
      await _clearFailedAttempts();
      _updateActivity();
      return PinVerifyResult.success;
    } else {
      await _recordFailedAttempt();
      return isLockedOut
          ? PinVerifyResult.lockedOut
          : PinVerifyResult.wrongPin;
    }
  }

  /// Verifikasi PIN (API lama — tanpa perlindungan brute-force, untuk kompatibilitas).
  bool verifyPin(String pin) {
    final savedHash = _prefs.getString(_pinKey);
    if (savedHash == null) return false;
    return _hashData(pin) == savedHash;
  }

  // -------------------------------------------------------------------------
  // Recovery
  // -------------------------------------------------------------------------

  bool verifyRecoveryPhrase(String phrase) {
    final savedHash = _prefs.getString(_recoveryKey);
    if (savedHash == null) return false;
    return _hashData(phrase.toLowerCase().trim()) == savedHash;
  }

  Future<void> resetSecurity() async {
    await _prefs.remove(_pinKey);
    await _prefs.remove(_recoveryKey);
    await _prefs.remove(_roleKey);
    await _prefs.remove(_failedAttemptsKey);
    await _prefs.remove(_lockoutUntilKey);
    await _prefs.remove(_lastActivityKey);
  }
}
