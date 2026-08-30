import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../domain/auth_repository.dart';
import '../domain/sync_queue_entry.dart';
import '../domain/sync_queue_repository.dart';
import 'sync_orchestrator.dart';

/// Status sinkronisasi untuk indikator UI.
enum SyncUiStatus { offline, syncing, pending, synced }

/// Worker sinkronisasi otomatis: mendengarkan perubahan konektivitas dan
/// menjalankan [SyncOrchestrator.sync] setiap kali perangkat kembali
/// online (transisi offline -> online). Juga menyediakan sinkronisasi
/// manual ([syncNow]) dan status untuk indikator UI (ChangeNotifier).
/// Eksekusi tumpang-tindih dicegah dengan flag [_syncing].
class AutoSyncWorker extends ChangeNotifier {
  final SyncOrchestrator orchestrator;
  final SyncQueueRepository queueRepository;
  final AuthRepository authRepository;
  final Stream<List<ConnectivityResult>> connectivityStream;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _syncing = false;
  bool _wasOnline = false;
  bool _isOnline = false;
  int _pendingCount = 0;
  DateTime? _lastSyncAt;

  AutoSyncWorker({
    required this.orchestrator,
    required this.queueRepository,
    required this.authRepository,
    required this.connectivityStream,
  });

  /// Status agregat untuk indikator.
  SyncUiStatus get status {
    if (!_isOnline) {
      return SyncUiStatus.offline;
    }
    if (_syncing) {
      return SyncUiStatus.syncing;
    }
    if (_pendingCount > 0) {
      return SyncUiStatus.pending;
    }
    return SyncUiStatus.synced;
  }

  /// Entri antrian yang belum berhasil dipush (PENDING/FAILED).
  int get pendingCount => _pendingCount;

  bool get isSyncing => _syncing;

  DateTime? get lastSyncAt => _lastSyncAt;

  void start() {
    _subscription ??= connectivityStream.listen(_onConnectivityChanged);
    unawaited(_refreshPendingCount());
  }

  /// Sinkronisasi manual (tombol "Sync Sekarang").
  Future<void> syncNow() => _runSync();

  Future<void> _onConnectivityChanged(
    List<ConnectivityResult> results,
  ) async {
    final online = results.any((r) => r != ConnectivityResult.none);
    if (_isOnline != online) {
      _isOnline = online;
      notifyListeners();
    }
    if (online && !_wasOnline) {
      await _runSync();
    }
    _wasOnline = online;
  }

  Future<void> _runSync() async {
    if (_syncing) {
      return;
    }
    _syncing = true;
    notifyListeners();
    try {
      await orchestrator.sync(authToken: authRepository.getToken());
      _lastSyncAt = DateTime.now();
      // Pull master data setelah push (best-effort: kegagalan pull tidak
      // menggagalkan siklus push dan tidak mengubah status sinkronisasi).
      try {
        await orchestrator.pullMasterData(authToken: authRepository.getToken());
      } catch (_) {
        // Pull gagal (network/format) — dicoba lagi di siklus berikutnya.
      }
    } finally {
      await _refreshPendingCount();
      _syncing = false;
      notifyListeners();
    }
  }

  Future<void> _refreshPendingCount() async {
    final all = await queueRepository.getAll();
    _pendingCount =
        all.where((e) => e.status != SyncQueueStatus.synced).length;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
  }
}
