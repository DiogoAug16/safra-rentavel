import os
from pathlib import Path

from dotenv import load_dotenv


BASE_DIR = Path(__file__).resolve().parent.parent

load_dotenv(BASE_DIR / ".env")


SQL_DIR = BASE_DIR / "sql"

CSV_PATH = (
    BASE_DIR
    / "data"
    / "dados_safra_rentabilidade.csv"
)


SQL_FILES = (
    SQL_DIR
    / "tables"
    / "safras_treinamento.sql",

    SQL_DIR
    / "views"
    / "feature_domains.sql",

    SQL_DIR
    / "views"
    / "feature_values.sql",

    SQL_DIR
    / "views"
    / "class_priors.sql",

    SQL_DIR
    / "views"
    / "likelihoods.sql",

    SQL_DIR
    / "functions"
    / "classificar_safra.sql",
)


DB_CONFIG = {
    "host": os.getenv(
        "DB_HOST",
        "localhost",
    ),

    "port": int(
        os.getenv(
            "DB_PORT",
            "5432",
        )
    ),

    "dbname": os.getenv(
        "DB_NAME",
        "postgres",
    ),

    "user": os.getenv(
        "DB_USER",
        "postgres",
    ),

    "password": os.getenv(
        "DB_PASSWORD",
        "postgres",
    ),
}