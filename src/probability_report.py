"""Geração determinística do relatório de probabilidades."""

from collections import Counter

from src.csv_loader import FEATURE_COLUMNS, FEATURE_VALUES


def render_report(rows: list[dict[str, str]]) -> str:
    class_counts = Counter(row["cancelou_assinatura"] for row in rows)
    counts = Counter(
        (row["cancelou_assinatura"], feature, row[feature])
        for row in rows
        for feature in FEATURE_COLUMNS
    )
    lines = [
        "# Relatório de probabilidades do Naive Bayes",
        "",
        "Valores calculados deterministicamente a partir de `data/plataformas_digitais.csv`. "
        "`Sim` é cancelamento; `Nao` é permanência.",
        "",
        "## Probabilidades a priori",
        "",
        "| Classe | Quantidade | Probabilidade |",
        "| --- | ---: | ---: |",
    ]
    lines.extend(
        f"| {classe} | {class_counts[classe]:,} | {class_counts[classe] / len(rows):.2%} |"
        for classe in ("Sim", "Nao")
    )
    lines.extend(
        [
            "",
            "## Verossimilhanças com Laplace",
            "",
            "`Probabilidade = (Observado + 1) / (Registros da classe + 3)`. Cada feature tem três categorias.",
            "",
            "| Classe | Feature | Valor | Observado | Registros da classe | K | Probabilidade |",
            "| --- | --- | --- | ---: | ---: | ---: | ---: |",
        ]
    )
    for classe in ("Sim", "Nao"):
        for feature in FEATURE_COLUMNS:
            for value in FEATURE_VALUES[feature]:
                observed = counts[classe, feature, value]
                probability = (observed + 1) / (class_counts[classe] + 3)
                lines.append(
                    f"| {classe} | {feature} | {value} | {observed} | "
                    f"{class_counts[classe]} | 3 | {probability:.2%} |"
                )
    lines.extend(
        [
            "",
            "## Cenário padrão",
            "",
            "Para `Basico`, `Baixa`, `Longo`, `Baixo`, `Aumentou`, `Baixa`, `Baixo` e "
            "`Recorrente`, o cálculo sem arredondamento produz `Sim = 99,9983367%` e "
            "`Nao = 0,0016633%`. A função SQL arredonda para `100,00%` e `0,00%`; "
            "a recomendação é risco muito alto de cancelamento.",
            "",
        ]
    )
    return "\n".join(lines)
