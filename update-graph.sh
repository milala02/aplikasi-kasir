#!/bin/bash
export GRAPHIFY_FILE_CHAR_CAP=15000

if [ -d "graphify-out" ]; then
    echo "Memperbarui graph (Mode Parsial / Code-Only)..."
    graphify . --update --code-only
else
    echo "Mengekstrak graph untuk pertama kali (Code-Only)..."
    graphify . --code-only
fi
