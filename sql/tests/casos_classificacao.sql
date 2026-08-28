-- Cenários de demonstração e verificação do classificador.
SELECT
    '01_baixo_risco' AS caso,
    'Soja' AS nome_safra,
    *
FROM classificar_safra(
    'Alta',
    'Alto',
    'Baixo',
    'Adequada',
    'Adequada',
    'Baixa',
    'Baixo',
    'Alto'
)

UNION ALL

SELECT
    '02_alto_risco' AS caso,
    'Milho' AS nome_safra,
    *
FROM classificar_safra(
    'Baixa',
    'Baixo',
    'Alto',
    'Insuficiente',
    'Acima da faixa ideal',
    'Alta',
    'Alto',
    'Baixo'
)

UNION ALL

SELECT
    '03_perfil_ambiguo' AS caso,
    'Algodão' AS nome_safra,
    *
FROM classificar_safra(
    'Média',
    'Normal',
    'Médio',
    'Adequada',
    'Abaixo da faixa ideal',
    'Moderada',
    'Normal',
    'Médio'
)

UNION ALL

SELECT
    '04_produtividade_alta_mas_custos_ruins' AS caso,
    'Arroz' AS nome_safra,
    *
FROM classificar_safra(
    'Alta',
    'Baixo',
    'Alto',
    'Adequada',
    'Adequada',
    'Baixa',
    'Alto',
    'Alto'
)

UNION ALL

SELECT
    '05_produtividade_baixa_compensada' AS caso,
    'Feijão' AS nome_safra,
    *
FROM classificar_safra(
    'Baixa',
    'Alto',
    'Baixo',
    'Adequada',
    'Adequada',
    'Baixa',
    'Baixo',
    'Alto'
)

UNION ALL

SELECT
    '06_custos_altos_clima_desfavoravel' AS caso,
    'Café' AS nome_safra,
    *
FROM classificar_safra(
    'Alta',
    'Normal',
    'Alto',
    'Excessiva',
    'Acima da faixa ideal',
    'Moderada',
    'Alto',
    'Alto'
)

UNION ALL

-- Duas temperaturas reais podem ser diferentes, mas ambas chegam
-- ao classificador apenas como "Adequada".
SELECT
    '07_limite_discretizacao_20c' AS caso,
    'Soja' AS nome_safra,
    *
FROM classificar_safra(
    'Alta',
    'Alto',
    'Baixo',
    'Adequada',
    'Adequada',
    'Baixa',
    'Baixo',
    'Alto'
)

UNION ALL

SELECT
    '08_limite_discretizacao_24c' AS caso,
    'Soja' AS nome_safra,
    *
FROM classificar_safra(
    'Alta',
    'Alto',
    'Baixo',
    'Adequada',
    'Adequada',
    'Baixa',
    'Baixo',
    'Alto'
);
