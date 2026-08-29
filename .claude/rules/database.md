# Aturan Database (Drift)

- Drift adalah satu-satunya persistence layer production (`lib/core/database/app_database.dart` + `app_database.g.dart`). Jangan membuat database/table kedua jika struktur sudah tersedia.
- Schema change wajib menaikkan `schemaVersion` dan menambah migrasi di `onUpgrade` (pola `if (from < N)`) bila DB pengguna lama terdampak.
- Migration harus aman untuk database pengguna lama: kolom baru nullable atau ber-default; data lama tetap terbaca (fallback eksplisit di repository, bukan crash).
- `*.g.dart` adalah hasil generate — JANGAN edit manual. Regenerasi: `dart run build_runner build --delete-conflicting-outputs`.
- Repository production tidak boleh split state memory-vs-SQLite: cache boleh, tetapi save/update/delete harus benar-benar menulis SQLite (await transaksi) dan cache mengikuti hasil persistensi.
- Operasi database async harus di-await; error persistensi harus terdeteksi oleh caller (jangan fire-and-forget).
- Perubahan schema harus disertai test migration/persistence yang relevan.
- Jangan menghapus tabel/kolom/file database tanpa audit dependency dan migration impact.
