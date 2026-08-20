# 🚀 Smart POS & Cashier System (Flutter)

[![Flutter CI](https://github.com/milala/aplikasi-kasir/actions/workflows/flutter_ci.yml/badge.svg)](https://github.com/milala/aplikasi-kasir/actions)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)

Aplikasi Point of Sale (POS) modern berbasis **Flutter** yang dirancang khusus untuk efisiensi transaksi, performa tinggi, dan ketahanan edge-case di lapangan. Dilengkapi dengan pipa **Automated CI/CD** berbasis GitHub Actions.

---

## ✨ Fitur Utama

- **🛒 Management Keranjang & Stok**: Perhitungan subtotal real-time, batas stok otomatis, dan proteksi kuantitas minimum.
- **🏷️ Kategori & Filter Presisi**: Filter cepat katalog produk, pencarian real-time, serta empty state UI handling.
- **💰 Diskon & Pajak (PPN)**: Kalkulasi diskon (persen & nominal khusus) dan simulasi PPN 11% bebas floating-point error.
- **💳 Multi-Metode Pembayaran**: Dukungan metode pembayaran Tunai (Cash), QRIS dinamis, dan Transfer Bank.
- **🛡️ Anti-Spam & Double-Tap Guard**: Proteksi synchronous guard pada tombol transaksi untuk mencegah double charge saat kasir terburu-buru.
- **📄 Receipt Preview & Printing**: Simulasi modul cetak nota ke printer thermal dan preview struk digital.
- **📊 Financial Stress-Tested Engine**: Mesin transaksi telah teruji mampu memproses 10.000 transaksi simultan dalam waktu kurang dari 1 detik.

---

## 🛠️ Pipa CI/CD (GitHub Actions)

Repositori ini dikawal oleh alur kerja otomatisasi CI/CD untuk memastikan kualitas kode (Quality Assurance):

1. **Static Code Analysis**: `flutter analyze` untuk kepatuhan standar sintaks.
2. **Automated Widget & Unit Testing**: Eksekusi otomatis Uji 1.1 hingga Uji 1.13.
3. **Code Coverage Report**: Agregasi laporan cakupan tes dalam bentuk artifact (`lcov.info`).
4. **Automated APK Build**: Kompilasi otomatis Debug APK pada setiap komit di branch utama (`main`).

---

## 🚀 Memulai (Quick Start)

### Prasyarat
- Flutter SDK (`stable` channel)
- Java JDK 17 / AGP 8.x+

### Jalankan Lokal

1. Clone repositori:
   `git clone https://github.com/milala/aplikasi-kasir.git`
2. Masuk ke direktori:
   `cd aplikasi-kasir`
3. Install dependensi:
   `flutter pub get`
4. Jalankan pengujian:
   `flutter test`

---

*Dikembangkan dengan fokus pada stabilitas UI/UX dan keandalan transaksi kasir.*
