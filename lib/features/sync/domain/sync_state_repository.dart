/// Tabel transaksi/master yang mendukung flag CDC (`isSynced`/`syncedAt`).
enum SyncSourceTable {
  product,
  customer,
  sale,
  order,
  purchase,
  receiving,
}

/// Penanda CDC: set `isSynced=true` + `syncedAt` pada baris tabel sumber
/// setelah payload berhasil di-push ke backend.
abstract interface class SyncStateRepository {
  Future<void> markSynced(SyncSourceTable table, String id, DateTime at);
}
