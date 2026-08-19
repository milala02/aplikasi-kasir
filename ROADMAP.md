# 🚀 Roadmap Pengembangan Aplikasi Kasir & Produksi

Dokumen ini berisi rencana pengembangan fitur lanjutan untuk rilis mendatang.

## 1. Modul Manajemen Stok & Bahan Baku
- [ ] **Pencatatan Bahan Mentah:** Sistem melacak stok rempah/bahan baku utama.
- [ ] **Pengurangan Stok Otomatis:** Stok bahan berkurang otomatis berdasarkan formula setiap kali ada input hasil produksi.
- [ ] **Notifikasi Stok Minimum:** Peringatan visual jika bahan baku atau produk siap jual berada di bawah batas minimum.
- [ ] **Pencatatan Waste/Bahan Rusak:** Input khusus untuk bahan kedaluwarsa atau rusak agar kalkulasi HPP tetap presisi.

## 2. Modul Transaksi & Integrasi Kasir
- [ ] **Cetak Struk Bluetooth:** Integrasi printer thermal portabel (`blue_thermal_printer` / `flutter_pos_printer_platform`).
- [ ] **Integrasi QRIS:** Menampilkan kode QRIS dinamis/statis untuk pembayaran non-tunai.
- [ ] **Struk Digital via WhatsApp:** Fitur kirim nota transaksi langsung ke nomor WhatsApp pelanggan.

## 3. Modul Analitik & Laporan Keuangan
- [ ] **Dashboard Visual (`fl_chart`):** Grafik tren penjualan harian, mingguan, dan analisis produk terlaris.
- [ ] **Laporan Laba Rugi Otomatis:** Kalkulasi real-time membandingkan total omzet terhadap HPP dan biaya operasional.
- [ ] **Ekspor Laporan (Excel/PDF):** Fitur mengunduh rekap transaksi ke format `.xlsx` atau `.pdf`.

## 4. Modul Keamanan & Cloud Backup
- [ ] **Backup & Restore Google Drive:** Pencadangan berkas database SQLite secara berkala ke Google Drive.
- [ ] **Role-Based Access Control (RBAC):** Pemisahan hak akses antara akun Owner (akses penuh) dan Kasir/Karyawan (akses transaksi).
