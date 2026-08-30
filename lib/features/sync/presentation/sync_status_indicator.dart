import 'package:flutter/material.dart';

import '../application/auto_sync_worker.dart';

/// Indikator status sinkronisasi untuk AppBar: ikon + jumlah entri
/// yang belum terpush. Mendengarkan [AutoSyncWorker] (ChangeNotifier).
class SyncStatusIndicator extends StatelessWidget {
  final AutoSyncWorker worker;

  const SyncStatusIndicator({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: worker,
      builder: (context, _) {
        final (icon, color, label) = switch (worker.status) {
          SyncUiStatus.offline => (
              Icons.cloud_off,
              Colors.grey,
              'Offline — sinkronisasi menunggu koneksi',
            ),
          SyncUiStatus.syncing => (
              Icons.sync,
              Colors.blue,
              'Menyinkronkan…',
            ),
          SyncUiStatus.pending => (
              Icons.cloud_queue,
              Colors.orange,
              'Menunggu sinkronisasi (${worker.pendingCount} entri)',
            ),
          SyncUiStatus.synced => (
              Icons.cloud_done,
              Colors.green,
              'Tersinkron',
            ),
        };
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Tooltip(
              message: label,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(icon, color: color, size: 20),
              ),
            ),
            if (worker.pendingCount > 0)
              Tooltip(
                message: label,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Text(
                    '${worker.pendingCount}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Tombol sinkronisasi manual ("Sync Sekarang").
class SyncNowButton extends StatelessWidget {
  final AutoSyncWorker worker;

  const SyncNowButton({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: worker,
      builder: (context, _) {
        return IconButton(
          tooltip: 'Sync Sekarang',
          icon: worker.isSyncing
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.sync),
          onPressed: worker.isSyncing ? null : worker.syncNow,
        );
      },
    );
  }
}
