# Project Guidelines & Security Protocol: Aplikasi Kasir

## 🚨 PROTOKOL KEAMANAN & PRIVASI (CRITICAL)
1. **Dilarang Keras Exposure Kredensial:**
   - JANGAN PERNAH menyalin, menampilkan, atau menyimpan Personal Access Token (PAT) GitHub, API Key, password database, atau kunci rahasia dalam file basis kode atau log.
   - Semua kredensial dan kunci rahasia WAJIB disimpan dalam file `.env` yang terisolasi.
   - Pastikan file `.env`, `.env.local`, file log, dan folder `node_modules`/`vendor` selalu ada di dalam `.gitignore`.

2. **Validasi & Proteksi Lingkungan VPS:**
   - Dilarang mengeksekusi perintah shell yang berpotensi merusak sistem (`rm -rf /`, pengubahan hak akses `chmod 777` secara masif, dll).
   - Pastikan setiap perintah `git` tidak menyertakan token mentah secara eksplisit di file repositori.

---

## 🔒 KEAMANAN KODE APLIKASI KASIR
1. **Sanitasi Data & Transaksi:**
   - Terapkan sanitasi input ketat pada semua endpoint API (mencegah SQL Injection, XSS, dan Command Injection).
   - Pastikan kalkulasi nilai transaksi, diskon, dan kembalian uang menggunakan tipe data desimal/presisi tinggi yang tepat di tingkat database dan backend.
   - Setiap transaksi wajib dibungkus dalam *Database Transaction* (Commit/Rollback) untuk menjamin integritas data stok dan keuangan.

2. **Otentikasi & Hak Akses:**
   - Pisahkan batasan hak akses secara tegas antara peran Kasir (*Cashier*) dan Admin/Pemilik.
   - Hashing semua kata sandi pengguna menggunakan algoritma aman (misal: bcrypt/Argon2).

---

## 🛠️ INSTRUKSI PENGEMBANGAN
- Selalu periksa keterhubungan dependensi dan lakukan pengujian (*testing/debugging*) sebelum menerapkan perubahan secara langsung pada file konfigurasi produksi.
- Berikan penjelasan ringkas saat melakukan refactoring kode atau memperbaiki bug keamanan.
