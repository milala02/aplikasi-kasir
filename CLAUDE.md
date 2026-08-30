# Aplikasi Kasir - Project Instructions

Aplikasi Flutter POS & produksi (warung bumbu). Persistence: Drift (SQLite). Uang: `Money` minor units.

## Arsitektur Aktual
- **Domain**: `lib/domain/` - Entity, Value Object, Repository Interface
- **Application**: `lib/application/` - Use Case, Service
- **Infrastructure**: `lib/infrastructure/` - Repository Implementation, Database (Drift)
- **Presentation**: `lib/presentation/` - BLoC/Cubit, UI Screens, Widgets

## Database (Drift)
- **Schema Version**: v7 (migration chain v1→v7)
- **Generated Files**: `*.g.dart` dan `*.drift.dart` **TIDAK boleh diedit manual**
- **Migration**: Setiap perubahan schema wajib buat migration dengan `schemaVersion` yang benar
- **Best Practice**: Hindari split state memory vs SQLite di production

## Business Logic - FIFO Costing
- **Sumber HPP**: `CostLayer` dan `StockLedger` adalah source of truth
- **Aturan**:
  - Jangan mengganti costing dengan konstanta/estimasi
  - Perubahan FIFO wajib memiliki regression test
  - Validation-before-mutation dan async persistence sudah benar

## Integrasi (Inventory → Receiving → Purchasing → Sales)
- **StockLedger ↔ StockMovement**: Pastikan konsistensi setelah receiving/sale
- **Sale HPP dan Total**: Perhatikan perhitungan HPP saat sale
- **Purchasing → Receiving**: Pastikan reference integrity

## Dashboard Analytics
- **Data Source**: SQLite query agregasi, bukan cache memory
- **Consistency**: Dashboard harus reflect real-time data dari database

## Testing
- `flutter test` untuk menjalankan semua test
- `flutter analyze` sebelum commit (wajib)
- Logic baru harus memiliki regression test

## Verifikasi
- `dart analyze lib test`
- `flutter test`
- Regenerasi generated Drift: `dart run build_runner build --delete-conflicting-outputs`

## Output Akhir Task
Singkat: Status · File berubah · Inti perubahan · Analyze/test result · Blocker (jika ada). Jangan mengulang konteks.

## Referensi
- Detail teknis: `rules/architecture.md`, `rules/testing.md`, `rules/database.md`, `rules/fifo-costing.md`
