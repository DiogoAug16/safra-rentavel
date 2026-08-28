#!/bin/sh

set -e

ROOT_DIR=$(CDPATH= cd "$(dirname "$0")/.." && pwd)

VENV_PYTHON="$ROOT_DIR/.venv/bin/python"

if [ ! -f "$VENV_PYTHON" ]; then
    echo "Erro: ambiente virtual .venv não encontrado."
    echo "Crie-o com: python3 -m venv .venv"
    exit 1
fi

exec "$VENV_PYTHON" "$ROOT_DIR/main.py" log-odds
