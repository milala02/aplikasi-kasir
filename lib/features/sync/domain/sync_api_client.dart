import 'master_data_pull.dart';
import 'sync_queue_entry.dart';

/// Klien sinkronisasi backend: push antrian + pull master data.
abstract interface class SyncApiClient {
  /// Kirim payload entri ke endpoint-nya. Lempar exception bila gagal
  /// (non-2xx / network error) — orchestrator menandai FAILED.
  Future<void> push(SyncQueueEntry entry, {String? authToken});

  /// Tarik master data (products, categories, uoms) yang diperbarui
  /// sejak [since] (inklusif). `since` null berarti tarik semua.
  /// Lempar exception bila gagal (non-2xx / network error / format).
  Future<MasterDataPull> pull({DateTime? since, String? authToken});
}
