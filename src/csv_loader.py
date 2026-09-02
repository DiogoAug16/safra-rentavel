import csv
from pathlib import Path


FEATURE_COLUMNS = (
    "plano_assinatura",
    "frequencia_uso",
    "tempo_desde_ultimo_acesso",
    "uso_beneficios_plano",
    "variacao_preco",
    "percepcao_custo_beneficio",
    "nivel_satisfacao",
    "falhas_pagamento",
)

CSV_COLUMNS = FEATURE_COLUMNS + ("cancelou_assinatura",)

ALLOWED_VALUES = {
    "plano_assinatura": {"Basico", "Intermediario", "Premium"},
    "frequencia_uso": {"Baixa", "Media", "Alta"},
    "tempo_desde_ultimo_acesso": {"Recente", "Moderado", "Longo"},
    "uso_beneficios_plano": {"Baixo", "Medio", "Alto"},
    "variacao_preco": {"Manteve", "Aumentou", "Diminuiu"},
    "percepcao_custo_beneficio": {"Baixa", "Media", "Alta"},
    "nivel_satisfacao": {"Baixo", "Medio", "Alto"},
    "falhas_pagamento": {"Nenhuma", "Ocasional", "Recorrente"},
    "cancelou_assinatura": {"Sim", "Nao"},
}

FEATURE_VALUES = {
    "plano_assinatura": ("Basico", "Intermediario", "Premium"),
    "frequencia_uso": ("Baixa", "Media", "Alta"),
    "tempo_desde_ultimo_acesso": ("Recente", "Moderado", "Longo"),
    "uso_beneficios_plano": ("Baixo", "Medio", "Alto"),
    "variacao_preco": ("Manteve", "Aumentou", "Diminuiu"),
    "percepcao_custo_beneficio": ("Baixa", "Media", "Alta"),
    "nivel_satisfacao": ("Baixo", "Medio", "Alto"),
    "falhas_pagamento": ("Nenhuma", "Ocasional", "Recorrente"),
}

EXPECTED_ROW_COUNT = 5_000


COPY_SQL = """
COPY assinaturas_treinamento (
    plano_assinatura,
    frequencia_uso,
    tempo_desde_ultimo_acesso,
    uso_beneficios_plano,
    variacao_preco,
    percepcao_custo_beneficio,
    nivel_satisfacao,
    falhas_pagamento,
    cancelou_assinatura
)
FROM STDIN
"""


def validar_csv(csv_path: Path) -> list[dict[str, str]]:
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

    if len(registros) != EXPECTED_ROW_COUNT:
        raise ValueError(
            f"Quantidade de linhas inválida: esperado {EXPECTED_ROW_COUNT}, "
            f"recebido {len(registros)}."
        )

    for numero_linha, row in enumerate(registros, start=2):
        if None in row:
            raise ValueError(
                f"Campos extras na linha {numero_linha}: {row[None]!r}."
            )
        for coluna, valores in ALLOWED_VALUES.items():
            if row[coluna] not in valores:
                raise ValueError(
                    f"Valor inválido na linha {numero_linha}, coluna {coluna}: "
                    f"{row[coluna]!r}."
                )

    return registros


def carregar_csv(
    conn,
    csv_path: Path,
) -> int:

    registros = validar_csv(csv_path)

    with conn.cursor() as cursor:

        cursor.execute(
            """
            TRUNCATE TABLE assinaturas_treinamento
            RESTART IDENTITY;
            """
        )

        with cursor.copy(COPY_SQL) as copy:

            for row in registros:

                copy.write_row(
                    tuple(row[coluna] for coluna in CSV_COLUMNS)
                )

    return len(registros)
