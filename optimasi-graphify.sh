#!/bin/bash
set -e

echo "=== 1. MEMBLOKIR CACHE GRAPHIFY DARI LLM ==="
touch .claudeignore .gitignore

# Tambahkan ke .claudeignore jika belum ada
grep -qxF 'graphify-out/' .claudeignore || echo 'graphify-out/' >> .claudeignore
grep -qxF 'GRAPH_REPORT.md' .claudeignore || echo 'GRAPH_REPORT.md' >> .claudeignore

# Tambahkan ke .gitignore juga agar repositori bersih
grep -qxF 'graphify-out/' .gitignore || echo 'graphify-out/' >> .gitignore

echo "Berhasil mengamankan .claudeignore dan .gitignore!"

echo "=== 2. MEMBUAT COMMAND UPDATE GRAPHIFY ==="
cat << 'EOSCRIPT' > update-graph.sh
#!/bin/bash
# Batasi pembacaan maksimal 15.000 karakter per file untuk hemat token
export GRAPHIFY_FILE_CHAR_CAP=15000

if [ -d "graphify-out" ]; then
    echo "Memperbarui graph (Mode Parsial / Hemat Token)..."
    graphify . --update
else
    echo "Mengekstrak graph untuk pertama kali..."
    graphify .
fi
EOSCRIPT

chmod +x update-graph.sh
echo "Selesai! Otomatisasi siap."
