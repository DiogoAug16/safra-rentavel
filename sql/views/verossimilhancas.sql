-- Verossimilidade de cada valor de feature dentro de cada classe.
-- Fórmula de Laplace: P(feature = valor | classe) =
-- (ocorrencias + 1) / (quantidade_da_classe + numero_de_categorias).
-- O CROSS JOIN com feature_domains também cria linhas para valores
-- que ainda não apareceram nos dados, permitindo aplicar o +1.
CREATE OR REPLACE VIEW likelihoods AS

WITH

-- Cada CTE calcula uma parte necessária da fórmula de Laplace.
contagem_classe AS (
    -- Quantidade de registros em cada classe: Sim e Nao.
    SELECT
        rentavel AS classe,
        COUNT(*) AS quantidade

    FROM safras_treinamento

    GROUP BY rentavel
),

cardinalidade AS (
    -- K: número de categorias disponíveis para cada feature.
    SELECT
        feature,
        COUNT(*) AS quantidade_categorias

    FROM feature_domains

    GROUP BY feature
),

contagem_valores AS (
    -- Quantidade observada de cada combinação classe, feature e valor.
    SELECT
        classe,
        feature,
        valor,
        COUNT(*) AS quantidade

    FROM feature_values

    GROUP BY
        classe,
        feature,
        valor
),

classes AS (
    -- Lista cada classe uma única vez: Sim e Nao.
    SELECT DISTINCT
        rentavel AS classe

    FROM safras_treinamento
)

SELECT
    -- Classe para a qual a probabilidade será calculada.
    c.classe,

    -- Nome da feature, como produtividade_estimada.
    d.feature,

    -- Categoria da feature, como Alta ou Baixa.
    d.valor,

    -- Quantas vezes o valor apareceu dentro da classe.
    -- Se não apareceu, COALESCE transforma NULL em zero.
    COALESCE(
        cv.quantidade,
        0
    ) AS quantidade_observada,

    -- Quantidade total de registros da classe.
    cc.quantidade
        AS quantidade_classe,

    -- K: quantidade de categorias possíveis para a feature.
    card.quantidade_categorias,

    -- Aplicação da suavização de Laplace:
    -- (ocorrencias + 1) / (quantidade_da_classe + K).
    (
        COALESCE(cv.quantidade, 0) + 1
    )::NUMERIC
    /
    (
        cc.quantidade
        + card.quantidade_categorias
    ) AS probabilidade

-- Começa com uma linha para cada classe existente.
FROM classes c

-- Adiciona a quantidade total de registros de cada classe.
JOIN contagem_classe cc
    ON cc.classe = c.classe

-- Combina cada classe com todas as features e categorias permitidas.
-- Isso inclui categorias que ainda não apareceram nos dados.
CROSS JOIN feature_domains d

-- Adiciona o número de categorias da feature, usado como K.
JOIN cardinalidade card
    ON card.feature = d.feature

-- Procura a quantidade observada para a combinação atual.
-- LEFT JOIN mantém a linha mesmo quando essa combinação não existe.
LEFT JOIN contagem_valores cv
    ON cv.classe = c.classe
    AND cv.feature = d.feature
    AND cv.valor = d.valor;
