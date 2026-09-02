#!/usr/bin/env python3
"""Gera ou confere o relatório versionado a partir do CSV validado."""

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))

from src.config import CSV_PATH
from src.csv_loader import validar_csv
from src.probability_report import render_report


REPORT_PATH = Path(__file__).resolve().parent.parent / "docs" / "relatorio-probabilidades.md"


def main(argv=None):
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="falha se o relatório estiver desatualizado")
    args = parser.parse_args(argv)
    expected = render_report(validar_csv(CSV_PATH))

    if args.check:
        try:
            actual = REPORT_PATH.read_text(encoding="utf-8")
        except FileNotFoundError:
            actual = ""
        if actual != expected:
            print(f"Relatório desatualizado: {REPORT_PATH}", file=sys.stderr)
            return 1
        return 0

    REPORT_PATH.write_text(expected, encoding="utf-8")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
