from pathlib import Path

from src.config import SQL_FILES


def executar_arquivo_sql(
    conn,
    arquivo: Path,
) -> None:

    sql = arquivo.read_text(
        encoding="utf-8"
    )

    cursor = conn.cursor()
    try:
        cursor.execute(sql)
    finally:
        cursor.close()


def executar_definicoes_sql(
    conn,
) -> None:

    for arquivo in SQL_FILES:

        executar_arquivo_sql(
            conn,
            arquivo,
        )

        print(
            f"Executado: {arquivo.name}"
        )
