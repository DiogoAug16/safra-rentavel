import argparse

from src.classifier import classificar_cancelamento
from src.config import CSV_PATH, SQL_DIR
from src.csv_loader import carregar_csv
from src.database import get_connection
from src.sql_runner import executar_definicoes_sql


SQL_CLEANUP = """
DROP FUNCTION IF EXISTS classificar_cancelamento(
    TEXT,
    TEXT,
    TEXT,
    TEXT,
    TEXT,
    TEXT,
    TEXT,
    TEXT
);

DROP FUNCTION IF EXISTS classificar_safra(
    TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT, TEXT
);

DROP VIEW IF EXISTS likelihoods;
DROP VIEW IF EXISTS class_priors;
DROP VIEW IF EXISTS feature_values;
DROP VIEW IF EXISTS feature_domains;

DROP VIEW IF EXISTS nb_likelihoods;
DROP VIEW IF EXISTS nb_class_priors;
DROP VIEW IF EXISTS nb_feature_values;
DROP VIEW IF EXISTS nb_feature_domains;

DROP TABLE IF EXISTS assinaturas_treinamento;
DROP TABLE IF EXISTS safras_treinamento;
"""


def run():
    with get_connection() as conn:
        print("Classificando risco de cancelamento...")

        resultado = classificar_cancelamento(
            conn=conn,
            plano_assinatura="Basico",
            frequencia_uso="Baixa",
            tempo_desde_ultimo_acesso="Longo",
            uso_beneficios_plano="Baixo",
            variacao_preco="Aumentou",
            percepcao_custo_beneficio="Baixa",
            nivel_satisfacao="Baixo",
            falhas_pagamento="Recorrente",
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
            f"Cancelamento: {prob_sim}%"
        )

        print(
            f"Permanência: {prob_nao}%"
        )

        print(
            f"Classe: {classe}"
        )

        print(
            f"Recomendação: {recomendacao}"
        )


def setup():
    with get_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute(SQL_CLEANUP)
        print("Configurando estrutura SQL...")
        executar_definicoes_sql(conn)

        print("\nCarregando dados de treinamento...")
        quantidade = carregar_csv(conn, CSV_PATH)
        print(f"{quantidade} registros importados com sucesso.")

def log_odds():
    sql = (SQL_DIR / "queries" / "log_odds.sql").read_text(
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


def likelihoods():
    with get_connection() as conn:
        with conn.cursor() as cursor:
            cursor.execute("""
                SELECT
                    feature,
                    valor,
                    classe,
                    quantidade_observada,
                    quantidade_classe,
                    quantidade_categorias,
                    ROUND((probabilidade * 100)::NUMERIC, 2)
                        AS probabilidade
                FROM likelihoods
                ORDER BY
                    feature,
                    valor,
                    classe;
            """)
            columns = [column.name for column in cursor.description]
            rows = cursor.fetchall()

    print(" | ".join(columns))
    print("-" * 100)
    for row in rows:
        print(" | ".join(
            f"{value}%" if column == "probabilidade" else str(value)
            for column, value in zip(columns, row)
        ))


def clean():
    with get_connection() as conn:
        print("Limpando objetos do projeto...")
        with conn.cursor() as cursor:
            cursor.execute(SQL_CLEANUP)
        print("Banco limpo com sucesso.")


def main(argv=None):
    parser = argparse.ArgumentParser(description="Gerencia o classificador de cancelamento de assinaturas.")
    parser.add_argument(
        "command",
        nargs="?",
        choices=("setup", "run", "log-odds", "likelihoods", "clean"),
        default="run",
        help="ação a executar (padrão: run)",
    )
    args = parser.parse_args(argv)
    {
        "setup": setup,
        "run": run,
        "log-odds": log_odds,
        "likelihoods": likelihoods,
        "clean": clean,
    }[args.command]()


if __name__ == "__main__":
    main()
