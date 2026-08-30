import '../domain/pull_state_repository.dart';

/// Implementasi in-memory untuk unit test.
class InMemoryPullStateRepository implements PullStateRepository {
  DateTime? lastPullAt;

  @override
  DateTime? getLastPullAt() => lastPullAt;

  @override
  Future<void> setLastPullAt(DateTime at) async {
    lastPullAt = at;
  }
}
