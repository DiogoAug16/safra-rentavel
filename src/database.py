import psycopg

from src.config import DB_CONFIG


def get_connection():
    return psycopg.connect(**DB_CONFIG)