import os
from pathlib import Path

from dotenv import load_dotenv


BASE_DIR = Path(__file__).resolve().parent.parent

load_dotenv(BASE_DIR / ".env")

SQL_DIR = BASE_DIR / "sql"

CSV_PATH = (
    BASE_DIR
    / "data"
    / "plataformas_digitais.csv"
)

SQL_FILES = (
    SQL_DIR
    / "tables"
    / "assinaturas_treinamento.sql",

    SQL_DIR
    / "views"
    / "dominios_features.sql",

    SQL_DIR
    / "views"
    / "valores_features.sql",

    SQL_DIR
    / "views"
    / "probabilidades_priori.sql",

    SQL_DIR
    / "views"
    / "verossimilhancas.sql",

    SQL_DIR
    / "functions"
    / "classificar_cancelamento.sql",
)


DB_CONFIG = {
    "host": os.getenv("DB_HOST", "localhost"),
    "port": int(os.getenv("DB_PORT", "5432")),
    "dbname": os.getenv("DB_NAME", "assinatura"),
    "user": os.getenv("DB_USER", "postgres"),
    "password": os.getenv("DB_PASSWORD", "postgres"),
}
