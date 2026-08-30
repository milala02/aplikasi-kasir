/// Status entri antrian sinkronisasi offline-first.
enum SyncQueueStatus { pending, synced, failed }

/// Entri antrian sinkronisasi: payload mandiri (JSON lengkap) yang dikirim
/// ke endpoint tertentu. CDC ditandai pada tabel asal (`isSynced`/`syncedAt`).
class SyncQueueEntry {
  final String id;
  final String endpoint;

  /// Tabel sumber CDC (mis. `orders`) untuk menandai `isSynced` setelah push.
  final String sourceTable;

  /// Id lokal baris sumber (mis. `ord_123`) untuk penanda CDC `isSynced`.
  /// Kosong untuk baris legacy (migrasi v14): orchestrator fallback
  /// membaca `id` dari payload lama.
  final String referenceId;
  final String payloadJson;
  final SyncQueueStatus status;
  final int retryCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  SyncQueueEntry({
    required this.id,
    required this.endpoint,
    required this.sourceTable,
    this.referenceId = '',
    required this.payloadJson,
    required this.status,
    required this.retryCount,
    required this.createdAt,
    required this.updatedAt,
  }) {
    if (id.isEmpty) {
      throw ArgumentError('Sync queue entry ID cannot be empty.');
    }
    if (endpoint.isEmpty) {
      throw ArgumentError('Sync queue endpoint cannot be empty.');
    }
    // sourceTable boleh kosong untuk baris legacy (migrasi v13):
    // entri tanpa sumber CDC tetap di-push, hanya tanpa penanda isSynced.
    if (payloadJson.isEmpty) {
      throw ArgumentError('Sync queue payload cannot be empty.');
    }
    if (retryCount < 0) {
      throw ArgumentError('Sync queue retry count cannot be negative.');
    }
  }

  SyncQueueEntry copyWith({
    SyncQueueStatus? status,
    int? retryCount,
    DateTime? updatedAt,
  }) {
    return SyncQueueEntry(
      id: id,
      endpoint: endpoint,
      sourceTable: sourceTable,
      referenceId: referenceId,
      payloadJson: payloadJson,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
