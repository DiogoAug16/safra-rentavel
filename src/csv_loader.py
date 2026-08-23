import csv
from pathlib import Path


CSV_COLUMNS = (
    "Nome da safra",
    "Produtividade estimada",
    "Preço esperado de venda",
    "Custo total de produção por hectare",
    "Precipitação acumulada",
    "Temperatura média",
    "Incidência de pragas e doenças",
    "Custo dos insumos agrícolas",
    "Histórico de produtividade da área",
    "Rentavel",
)


COPY_SQL = """
COPY safras_treinamento (
    nome_safra,
    produtividade_estimada,
    preco_esperado_venda,
    custo_total_producao,
    precipitacao_acumulada,
    temperatura_media,
    incidencia_pragas_doencas,
    custo_insumos_agricolas,
    historico_produtividade,
    rentavel
)
FROM STDIN
"""


def carregar_csv(
    conn,
    csv_path: Path,
) -> int:

    if not csv_path.exists():
        raise FileNotFoundError(
            f"Arquivo não encontrado: {csv_path}"
        )

    with csv_path.open(
        "r",
        encoding="utf-8-sig",
        newline="",
    ) as arquivo:

        reader = csv.DictReader(
            arquivo
        )

        if reader.fieldnames != list(CSV_COLUMNS):
            raise ValueError(
                "Cabeçalho CSV inválido: "
                + ", ".join(CSV_COLUMNS)
            )

        registros = list(reader)

    if any(
        not row["Nome da safra"].strip()
        for row in registros
    ):
        raise ValueError("Nome da safra não pode ser vazio.")

    with conn.cursor() as cursor:

        cursor.execute(
            """
            TRUNCATE TABLE safras_treinamento
            RESTART IDENTITY;
            """
        )

        with cursor.copy(COPY_SQL) as copy:

            for row in registros:

                copy.write_row(
                    (
                        row["Nome da safra"],

                        row[
                            "Produtividade estimada"
                        ],

                        row[
                            "Preço esperado de venda"
                        ],

                        row[
                            "Custo total de produção por hectare"
                        ],

                        row[
                            "Precipitação acumulada"
                        ],

                        row[
                            "Temperatura média"
                        ],

                        row[
                            "Incidência de pragas e doenças"
                        ],

                        row[
                            "Custo dos insumos agrícolas"
                        ],

                        row[
                            "Histórico de produtividade da área"
                        ],

                        row["Rentavel"],
                    )
                )

    return len(registros)
