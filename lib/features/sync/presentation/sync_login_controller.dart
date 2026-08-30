import 'package:flutter/foundation.dart';

import '../domain/auth_repository.dart';
import '../infrastructure/remote_auth_repository.dart';

/// Controller form login sinkronisasi: memanggil login backend dan
/// menyimpan token hasilnya ke penyimpanan lokal.
class SyncLoginController extends ChangeNotifier {
  final RemoteAuthRepository remoteAuthRepository;
  final AuthRepository localAuthRepository;

  bool _loading = false;
  String? _error;

  SyncLoginController({
    required this.remoteAuthRepository,
    required this.localAuthRepository,
  });

  bool get isLoading => _loading;

  String? get error => _error;

  bool get isLoggedIn => localAuthRepository.getToken() != null;

  /// Login; true bila token berhasil disimpan. Error tersedia di [error].
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    if (username.trim().isEmpty || password.isEmpty) {
      _error = 'Username dan password wajib diisi.';
      notifyListeners();
      return false;
    }

    if (_loading) {
      return false;
    }
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final token = await remoteAuthRepository.login(
        username: username.trim(),
        password: password,
      );
      await localAuthRepository.saveToken(token);
      return true;
    } on RemoteAuthException catch (e) {
      _error = e.message;
      return false;
    } catch (_) {
      _error = 'Gagal terhubung ke server.';
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await localAuthRepository.clearToken();
    notifyListeners();
  }
}
