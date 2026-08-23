import argparse

from src.classifier import classificar_safra
from src.config import CSV_PATH, SQL_DIR
from src.csv_loader import carregar_csv
from src.database import get_connection
from src.sql_runner import executar_definicoes_sql


SQL_CLEANUP = """
DROP FUNCTION IF EXISTS classificar_safra(
    TEXT,
    TEXT,
    TEXT,
    TEXT,
    TEXT,
    TEXT,
    TEXT,
    TEXT
);

DROP VIEW IF EXISTS likelihoods;
DROP VIEW IF EXISTS class_priors;
DROP VIEW IF EXISTS feature_values;
DROP VIEW IF EXISTS feature_domains;

DROP VIEW IF EXISTS nb_likelihoods;
DROP VIEW IF EXISTS nb_class_priors;
DROP VIEW IF EXISTS nb_feature_values;
DROP VIEW IF EXISTS nb_feature_domains;

DROP TABLE IF EXISTS safras_treinamento;
"""


def run():
    with get_connection() as conn:
        print("Classificando safra...")

        resultado = classificar_safra(
            conn=conn,
            produtividade="Alta",
            preco="Alto",
            custo_producao="Médio",
            precipitacao="Adequada",
            temperatura="Adequada",
            pragas="Baixa",
            custo_insumos="Normal",
            historico="Alto",
        )

        (
            prob_sim,
            prob_nao,
            classe,
            recomendacao,
        ) = resultado

        print("\nResultado")
        print("-" * 50)

        print(
            f"Rentável: {prob_sim}%"
        )

        print(
            f"Não rentável: {prob_nao}%"
        )

        print(
            f"Classe: {classe}"
        )

        print(
            f"Recomendação: {recomendacao}"
        )


def setup():
    with get_connection() as conn:
        print("Configurando estrutura SQL...")
        executar_definicoes_sql(conn)

        print("\nCarregando dados de treinamento...")
        quantidade = carregar_csv(conn, CSV_PATH)
        print(f"{quantidade} registros importados com sucesso.")

def test():
    sql = (SQL_DIR / "tests" / "classification_cases.sql").read_text(
        encoding="utf-8"
    )

    with get_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute(sql)
            columns = [column.name for column in cursor.description]
            rows = cursor.fetchall()

    print(" | ".join(columns))
    print("-" * 100)
    for row in rows:
        print(" | ".join(
            f"{value}%" if column in {"probabilidade_sim", "probabilidade_nao"} else str(value)
            for column, value in zip(columns, row)
        ))


def clean():
    with get_connection() as conn:
        print("Limpando objetos do projeto...")
        with conn.cursor() as cursor:
            cursor.execute(SQL_CLEANUP)
        print("Banco limpo com sucesso.")


def main(argv=None):
    parser = argparse.ArgumentParser(description="Gerencia o projeto Safra Rentável.")
    parser.add_argument(
        "command",
        nargs="?",
        choices=("setup", "run", "test", "clean"),
        default="run",
        help="ação a executar (padrão: run)",
    )
    args = parser.parse_args(argv)
    {"setup": setup, "run": run, "test": test, "clean": clean}[args.command]()


if __name__ == "__main__":
    main()
