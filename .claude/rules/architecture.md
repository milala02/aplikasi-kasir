# Arsitektur Repository

## Struktur

- `lib/core/` — primitif bersama: `money/`, `quantity/`, `unit/`, `result/` (`Result`/`Success`/`Failure`), `errors/` (`DomainError`), `database/` (Drift), `security/` (auth), `theme/`.
- `lib/features/<feature>/` — `domain/` (entitas + interface repository), `application/` (use case), `infrastructure/` (implementasi Drift + InMemory untuk test), `presentation/` (screen + controller).
- Feature aktual: auth, cart, customers, dashboard, inventory, portioning, production, products, purchasing, receiving, recipes, sales.

## Dependency & Wiring

- Wiring manual dari `lib/main.dart` (composition root): AppDatabase → repository Drift → use case → controller → screen, diteruskan ke `MyApp` → `PinScreen` → `MainNavigationShell`.
- State management aktual: `ChangeNotifier` controller + constructor injection. Jangan memaksakan Riverpod/Provider/folder pattern yang tidak dipakai aplikasi.
- Paket `provider` ada di pubspec tetapi alur aplikasi tidak menggunakannya — jangan menambah pemakaian tanpa kebutuhan.

## Pola Async

- Use case mengembalikan `Result<T>`; error domain pakai `DomainError(code, message)` dengan code konsisten (mis. `INSUFFICIENT_STOCK`, `PROCESS_SALE_ERROR`).
- Await setiap operasi async sesuai tipe aktual interface repository. Jangan mengabaikan Future kecuali interface memang void.
- Di UI: hindari `BuildContext` setelah async gap tanpa mounted check; jangan lakukan pekerjaan async blocking di `build()`.

## Hubungan Antar Feature

- `receiving` → menciptakan `StockMovement` (purchase) + `CostLayer` baru per item.
- `sales` → `ProcessSaleUseCase` mengonsumsi `CostLayer` FIFO via `CostLayerService`, mencatat `StockMovement` (sale), menyimpan `Sale` ber-HPP (`SaleItem.unitCost`, nullable untuk data lama).
- `production` → `ProcessProductionBatchUseCase` mengonsumsi `CostLayer` FIFO (urutkan `acquiredAt` lalu `id`), mencatat `StockMovement` outbound, menghasilkan `ProductionBatch` (HPP). UI produksi menunggu data Recipe bisnis.
- `dashboard` → membaca `SaleRepository` untuk ringkasan dan transaksi terakhir.

## Legacy

- `lib/providers/`, `lib/data/`, `lib/views/`, `lib/pages/` adalah kode lama yang TIDAK terhubung ke alur aplikasi. Jangan disentuh kecuali benar-benar diperlukan oleh task.
