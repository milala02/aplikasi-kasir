# CLAUDE.md — Aturan Proyek Aplikasi Kasir

Aplikasi Flutter POS & produksi (warung bumbu). Persistence: Drift (SQLite). Uang: `Money` minor units. Quantity: `Quantity` (value + scale).

## Aturan Inti

- Repository adalah source of truth. Baca kode aktual; jangan menebak API, schema, data bisnis, atau behavior.
- Inspect file terkait sebelum edit. Buat rencana minimal, lalu implement, test, verifikasi.
- Kerjakan hanya scope task. Jangan refactor besar, jangan sentuh legacy/dead code, jangan tambah fitur yang tidak diminta.
- Pertahankan business logic yang sudah tested. Jangan melemahkan/menghapus test agar pass.
- Baca hanya file yang relevan. Jangan minta user menyalin file yang bisa dibaca langsung dari repository.
- Jangan menghapus atau revert perubahan user.
- Jangan commit kecuali user secara eksplisit meminta.
- Jika ada ambiguitas yang memengaruhi correctness dan tidak bisa diselesaikan tanpa asumsi, STOP dan laporkan blocker.

## Verifikasi

- `dart analyze lib test`
- `flutter test`
- Regenerasi generated Drift: `dart run build_runner build --delete-conflicting-outputs`

## Output Akhir Task

Singkat: Status · File berubah · Inti perubahan · Analyze/test result · Blocker (jika ada). Jangan mengulang isi CLAUDE.md atau rules.

## Referensi

- Protokol keamanan & kredensial: `GEMINI.md`.
- Detail teknis: `rules/architecture.md`, `rules/testing.md`, `rules/database.md`, `rules/fifo-costing.md`, `rules/token-efficiency.md`.
