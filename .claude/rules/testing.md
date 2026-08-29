# Aturan Testing

- Logic baru harus memiliki regression test yang relevan di `test/features/<feature>/` (struktur mengikuti lib).
- Jangan menghapus atau melemahkan test hanya agar pass. Pertahankan test existing.
- Jika test gagal, diagnosis root cause-nya; perbaiki failure terkait saja, jangan menutupi.
- Jangan menyatakan task selesai sebelum verification selesai dan PASS.
- Command aktual:
  - `dart analyze lib test`
  - `flutter test`
- Task terfokus boleh menjalankan test/analyze terfokus dulu, tetapi sebelum selesai jalankan verification sesuai scope.
- Test persistence/migration wajib bila perubahan database membutuhkannya:
  - Round-trip/restart via `AppDatabase(NativeDatabase(file))` dengan file temp (`Directory.systemTemp`) + teardown close & delete.
  - Migrasi diuji dengan membuat DB versi lama secara manual (`PRAGMA user_version`) lalu membuka dengan schema baru.
  - Baris legacy harus tetap terbaca dengan fallback eksplisit.
- Repository InMemory (`in_memory_*`) dipakai untuk unit test use case/controller; jangan mengubah behaviornya tanpa alasan.
- Fixture test (productId, layer, harga) BUKAN data bisnis — jangan dijadikan data produksi.
