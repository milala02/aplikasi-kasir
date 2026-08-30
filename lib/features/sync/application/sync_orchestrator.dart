import 'dart:convert';

import '../domain/master_data_pull_repository.dart';
import '../domain/pull_state_repository.dart';
import '../domain/sync_api_client.dart';
import '../domain/sync_queue_entry.dart';
import '../domain/sync_queue_repository.dart';
import '../domain/sync_state_repository.dart';

/// Hasil satu siklus sinkronisasi.
class SyncResult {
  final int synced;
  final int failed;

  const SyncResult({required this.synced, required this.failed});
}

/// Hasil satu siklus pull master data.
class SyncPullResult {
  final DateTime? since;
  final int uomsUpserted;
  final int categoriesUpserted;
  final int productsUpserted;
  final int productsSkipped;

  const SyncPullResult({
    required this.since,
    required this.uomsUpserted,
    required this.categoriesUpserted,
    required this.productsUpserted,
    required this.productsSkipped,
  });
}

/// Orchestrator offline-first:
/// baca antrian PENDING → push via [SyncApiClient] → sukses: status SYNCED
/// + CDC `isSynced=true` pada tabel sumber; gagal: status FAILED + retry+1
/// (tanpa CDC).
///
/// Konvensi payload: payloadJson wajib memuat `id` entitas sumber.
class SyncOrchestrator {
  final SyncQueueRepository queueRepository;
  final SyncApiClient apiClient;
  final SyncStateRepository syncStateRepository;
  final MasterDataPullRepository masterDataRepository;
  final PullStateRepository pullStateRepository;

  SyncOrchestrator({
    required this.queueRepository,
    required this.apiClient,
    required this.syncStateRepository,
    required this.masterDataRepository,
    required this.pullStateRepository,
  });

  Future<SyncResult> sync({String? authToken}) async {
    var synced = 0;
    var failed = 0;

    final pending = await queueRepository.getPending();
    for (final entry in pending) {
      try {
        await apiClient.push(entry, authToken: authToken);

        final now = DateTime.now();
        await queueRepository.update(
          entry.copyWith(status: SyncQueueStatus.synced, updatedAt: now),
        );

        // CDC hanya untuk entri dengan sumber tabel (baris legacy/baru
        // tanpa sourceTable tetap di-push tanpa penanda isSynced).
        if (entry.sourceTable.isNotEmpty) {
          await syncStateRepository.markSynced(
            _tableFrom(entry.sourceTable),
            _payloadId(entry),
            now,
          );
        }
        synced++;
      } catch (_) {
        await queueRepository.update(
          entry.copyWith(
            status: SyncQueueStatus.failed,
            retryCount: entry.retryCount + 1,
            updatedAt: DateTime.now(),
          ),
        );
        failed++;
      }
    }

    return SyncResult(synced: synced, failed: failed);
  }

  /// Pull master data (products, categories, uoms) secara inkremental:
  /// `since` dari [PullStateRepository], upsert via [MasterDataPullRepository],
  /// lalu simpan kursor baru. Lempar exception bila gagal (caller
  /// menentukan best-effort atau propagate).
  Future<SyncPullResult> pullMasterData({String? authToken}) async {
    final since = pullStateRepository.getLastPullAt();
    final payload = await apiClient.pull(since: since, authToken: authToken);
    final result = await masterDataRepository.upsert(payload);
    await pullStateRepository.setLastPullAt(DateTime.now().toUtc());
    return SyncPullResult(
      since: since,
      uomsUpserted: result.uomsUpserted,
      categoriesUpserted: result.categoriesUpserted,
      productsUpserted: result.productsUpserted,
      productsSkipped: result.productsSkipped,
    );
  }

  static SyncSourceTable _tableFrom(String sourceTable) {
    return SyncSourceTable.values.firstWhere(
      (t) => t.name == sourceTable,
      orElse: () =>
          throw StateError('Unknown sync source table: $sourceTable'),
    );
  }

  static String _payloadId(SyncQueueEntry entry) {
    // Baris baru memuat referenceId lokal (v14). Baris legacy (payload
    // flat dengan `id` lokal) memakai fallback di bawah.
    if (entry.referenceId.isNotEmpty) {
      return entry.referenceId;
    }
    final payload = jsonDecode(entry.payloadJson);
    if (payload is! Map<String, dynamic>) {
      throw StateError('Payload bukan objek JSON.');
    }
    final id = payload['id'];
    if (id is! String || id.isEmpty) {
      throw StateError('Payload tidak memuat id.');
    }
    return id;
  }
}
