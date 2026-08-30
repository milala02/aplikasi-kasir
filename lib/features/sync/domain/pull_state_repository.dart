/// Penanda kursor pull inkremental: timestamp `since` terakhir kali
/// master data berhasil ditarik dari backend.
abstract interface class PullStateRepository {
  DateTime? getLastPullAt();

  Future<void> setLastPullAt(DateTime at);
}
