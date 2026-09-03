"""Geração determinística do relatório de probabilidades."""

from collections import Counter

from src.csv_loader import FEATURE_COLUMNS, FEATURE_VALUES


def render_report(rows: list[dict[str, str]]) -> str:
    class_counts = Counter(row["cancelou_em_30_dias"] for row in rows)
    plan_totals = Counter(row["plano_assinatura"] for row in rows)
    plan_cancellations = Counter(
        row["plano_assinatura"]
        for row in rows
        if row["cancelou_em_30_dias"] == "Sim"
    )
    counts = Counter(
        (row["cancelou_em_30_dias"], feature, row[feature])
        for row in rows
        for feature in FEATURE_COLUMNS
    )
    lines = [
        "# Relatório de probabilidades do Naive Bayes",
        "",
        "Valores calculados deterministicamente a partir de `data/plataformas_digitais.csv`. "
        "`Sim` significa cancelamento dentro de 30 dias; `Nao` significa que isso não ocorreu.",
        "",
        "## Fórmulas usadas",
        "",
        "Probabilidade a priori:",
        "",
        "$$",
        "P(C) = \\frac{N(C)}{N}",
        "$$",
        "",
        "Verossimilhança com suavização de Laplace:",
        "",
        "$$",
        "P(X=v \\mid C) = \\frac{N(X=v,C)+1}{N(C)+K}",
        "$$",
        "",
        "Nessa fórmula:",
        "",
        "- $C$ representa a classe (`Sim` ou `Nao`).",
        "- $N(C)$ representa a quantidade de registros da classe.",
        "- $N$ representa a quantidade total de registros.",
        "- $X=v$ representa uma feature com um valor específico.",
        "- $N(X=v,C)$ representa a quantidade de ocorrências do valor dentro da classe.",
        "- $K$ representa a quantidade de categorias da feature. Neste projeto, $K=3$.",
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
            "## Taxa de cancelamento por plano",
            "",
            "A taxa mostra a proporção de clientes de cada plano que cancelou em até 30 dias:",
            "",
            "$$",
            "P(C=\\text{Sim} \\mid P=p) = "
            "\\frac{N(C=\\text{Sim},P=p)}{N(P=p)}",
            "$$",
            "",
            "Nessa fórmula:",
            "",
            "- $C$ representa o resultado do cliente: `Sim` ou `Nao`.",
            "- $P$ representa a feature `plano_assinatura`.",
            "- $p$ representa um plano específico, como `Basico`.",
            "- $N(C=\\text{Sim},P=p)$ representa a quantidade de cancelamentos dentro do plano.",
            "- $N(P=p)$ representa a quantidade total de assinaturas daquele plano.",
            "",
            "| Plano | Cancelamentos | Total de assinaturas | Taxa de cancelamento |",
            "| --- | ---: | ---: | ---: |",
        ]
    )
    plan_rows = sorted(
        (
            plano,
            plan_cancellations[plano],
            plan_totals[plano],
        )
        for plano in FEATURE_VALUES["plano_assinatura"]
    )
    plan_rows.sort(
        key=lambda item: (-item[1] / item[2], item[0])
    )
    lines.extend(
        f"| {plano} | {cancelamentos:,} | {total:,} | {cancelamentos / total:.2%} |"
        for plano, cancelamentos, total in plan_rows
    )
    lines.extend(
        [
            "",
            "O plano Básico apresenta a maior taxa observada no CSV. Isso mostra uma "
            "associação nos dados, mas não prova que o plano cause o cancelamento. "
            "As outras features também participam da previsão.",
        ]
    )
    lines.extend(
        [
            "",
            "## Verossimilhanças com Laplace",
            "",
            "A tabela abaixo mostra as probabilidades calculadas com a fórmula de Laplace. Cada feature tem três categorias.",
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
            "## Cenário de referência",
            "",
            "Para `Basico`, `Baixa`, `Recente`, `Alto`, `Manteve`, `Media`, `Baixo` e "
            "`Ocasional`, o cálculo sem arredondamento produz `Sim = 90,0009592%` e "
            "`Nao = 9,9990408%`. A função SQL arredonda para `90,00%` e `10,00%`; "
            "a recomendação é tendência muito alta de cancelamento.",
            "A comparação entre as categorias está em `docs/resultados-log-odds.md`.",
            "",
        ]
    )
    return "\n".join(lines)
