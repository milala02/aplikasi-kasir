# Aturan FIFO Costing

- `CostLayer` adalah satu-satunya sumber HPP FIFO (fields: original/remaining quantity, unitCost, acquiredAt, purchaseId). Jangan menambah sumber HPP paralel.
- FIFO harus deterministik: urutkan layer berdasarkan `acquiredAt`, lalu `id` sebagai tie-breaker — termasuk di use case yang mengonsumsi layer langsung (produksi), karena repository Drift tidak menjamin urutan.
- `CostLayerService.consume` adalah mesin konsumsi FIFO untuk penjualan: validasi penuh dulu (sort, cek kecukupan), baru mutasi repository. Pertahankan pola validation-before-mutation.
- Jangan menyebabkan konsumsi layer parsial ketika validasi stok gagal: cek ketersediaan seluruh item sebelum mengonsumsi apa pun.
- Jangan mengganti HPP FIFO dengan konstanta/estimasi (mis. persentase flat dari omzet).
- `SaleItem.unitCost` nullable = fallback eksplisit untuk data lama tanpa HPP. Jangan menghapus semantics ini.
- Perubahan costing wajib memiliki regression test (FIFO satu layer, lintas layer dengan harga berbeda, stok kurang → gagal tanpa efek samping, determinisme urutan).
- Async update/save layer harus di-await.
- Jangan mengarang formula resep atau komposisi produksi. Jika data bisnis yang dibutuhkan tidak tersedia: audit repository/history/test dahulu; jika tetap tidak tersedia, STOP dan laporkan blocker.
