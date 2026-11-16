# Contributing — aplikasi-kasir

Terima kasih mau berkontribusi.

## Cara kontribusi
1. Buka issue dulu untuk bug / fitur — jelaskan langkah reproduksi dan hasil yang diharapkan.
2. Fork repo, buat branch `fix/<nama-singkat>` atau `feat/<nama-singkat>`.
3. Ikuti gaya yang sudah ada. Jalankan sebelum PR:
   ```bash
   flutter analyze
   flutter test
   ```
4. Satu PR = satu perubahan. Tulis judul jelas dan isi template PR.

## Yang dicari
- Perbaikan bug transaksi / stok / hitung diskon & PPN.
- Test untuk edge case kasir (stok habis, qty 0, double-tap).
- Perbaikan docs / README yang salah atau tidak jalan.

## Yang tidak diterima
- Perubahan format massal tanpa alasan.
- Klaim performa tanpa bukti test / benchmark.
