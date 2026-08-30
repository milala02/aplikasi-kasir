import 'package:shared_preferences/shared_preferences.dart';

import '../domain/pull_state_repository.dart';

/// Kursor pull inkremental via shared_preferences (dependensi existing).
class LocalPullStateRepository implements PullStateRepository {
  static const String _lastPullAtKey = 'sync_last_pull_at';

  final SharedPreferences _prefs;

  LocalPullStateRepository(this._prefs);

  @override
  DateTime? getLastPullAt() {
    final value = _prefs.getString(_lastPullAtKey);
    return value == null ? null : DateTime.tryParse(value);
  }

  @override
  Future<void> setLastPullAt(DateTime at) async {
    await _prefs.setString(_lastPullAtKey, at.toUtc().toIso8601String());
  }
}
