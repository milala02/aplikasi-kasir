import 'package:flutter_test/flutter_test.dart';

// Service Simulasi Sync & Online Status
class OfflineSyncService {
  bool isOnline = false;
  final List<Map<String, dynamic>> _offlineQueue = [];
  final List<Map<String, dynamic>> _serverDatabase = [];

  List<Map<String, dynamic>> get offlineQueue => List.unmodifiable(_offlineQueue);
  List<Map<String, dynamic>> get serverDatabase => List.unmodifiable(_serverDatabase);

  // Menyimpan transaksi
  Future<void> processTransaction(Map<String, dynamic> transaction) async {
    if (isOnline) {
      // Jika Online, langsung kirim ke server
      _serverDatabase.add(transaction);
    } else {
      // Jika Offline, simpan ke antrean lokal
      _offlineQueue.add(transaction);
    }
  }

  // Memicu proses sinkronisasi antrean saat koneksi kembali online
  Future<int> syncPendingTransactions() async {
    if (!isOnline || _offlineQueue.isEmpty) return 0;

    int syncedCount = 0;
    List<Map<String, dynamic>> tempQueue = List.from(_offlineQueue);

    for (var trx in tempQueue) {
      _serverDatabase.add(trx);
      _offlineQueue.remove(trx);
      syncedCount++;
    }

    return syncedCount;
  }
}

void main() {
  group('Uji 2.2 - Offline-First Sync & Mock API Integration', () {
    late OfflineSyncService syncService;

    setUp(() {
      syncService = OfflineSyncService();
    });

    test('2.2.1 - Transaksi saat online langsung masuk ke server', () async {
      syncService.isOnline = true;

      await syncService.processTransaction({'id': 'TRX-101', 'amount': 45000.0});

      expect(syncService.serverDatabase.length, 1);
      expect(syncService.offlineQueue.length, 0);
    });

    test('2.2.2 - Transaksi saat offline masuk ke antrean lokal', () async {
      syncService.isOnline = false;

      await syncService.processTransaction({'id': 'TRX-102', 'amount': 20000.0});
      await syncService.processTransaction({'id': 'TRX-103', 'amount': 75000.0});

      expect(syncService.serverDatabase.length, 0);
      expect(syncService.offlineQueue.length, 2);
    });

    test('2.2.3 - Otomatis sinkronisasi antrean lokal ke server saat koneksi terhubung kembali', () async {
      // 1. Buat transaksi saat offline
      syncService.isOnline = false;
      await syncService.processTransaction({'id': 'TRX-104', 'amount': 30000.0});
      expect(syncService.offlineQueue.length, 1);

      // 2. Koneksi kembali online
      syncService.isOnline = true;
      int synced = await syncService.syncPendingTransactions();

      // 3. Antrean lokal kosong, server terisi
      expect(synced, 1);
      expect(syncService.offlineQueue.length, 0);
      expect(syncService.serverDatabase.length, 1);
      expect(syncService.serverDatabase.first['id'], 'TRX-104');
    });
  });
}
