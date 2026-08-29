# Aturan Token Efficiency

- Prioritaskan token efficiency tanpa mengurangi correctness.
- Jangan membaca/menampilkan file penuh jika hanya sebagian diperlukan; gunakan search/grep dan potongan file relevan terlebih dahulu.
- Jangan meminta user menyalin file yang tersedia di repository.
- Jangan mengulang konteks proyek yang sudah tersedia di repository atau CLAUDE.md.
- Jangan menampilkan diff/output command panjang kecuali diperlukan untuk diagnosis. Gunakan output CLI ringkas (`tail`, filter).
- Jangan mengulang kembali instruksi atau aturan yang sudah tertulis di CLAUDE.md. Jika perlu merujuk aturan, cukup sebutkan nama filenya, misalnya `rules/database.md`.
- Instruksi permanen harus stabil: jangan memasukkan timestamp, random ID, status dinamis, hasil test sementara, atau output tool ke dalamnya.
- Task yang berubah harus berada di prompt task, bukan di CLAUDE.md. Jangan mengubah wording/struktur instruksi permanen tanpa alasan.
- Manfaatkan prefix caching dengan mempertahankan bagian instruksi yang stabil; jangan mengklaim cache hit tanpa data pengukuran.
- Jika informasi sudah dapat diperoleh dari filesystem, jangan memasukkannya kembali ke prompt.
- Setelah memahami task, jangan mengulang seluruh task kepada user; langsung kerjakan.
