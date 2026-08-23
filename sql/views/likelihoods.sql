CREATE OR REPLACE VIEW likelihoods AS

WITH

contagem_classe AS (
    SELECT
        rentavel AS classe,
        COUNT(*) AS quantidade

    FROM safras_treinamento

    GROUP BY rentavel
),

cardinalidade AS (
    SELECT
        feature,
        COUNT(*) AS quantidade_categorias

    FROM feature_domains

    GROUP BY feature
),

contagem_valores AS (
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
    SELECT DISTINCT
        rentavel AS classe

    FROM safras_treinamento
)

SELECT
    c.classe,

    d.feature,

    d.valor,

    COALESCE(
        cv.quantidade,
        0
    ) AS quantidade_observada,

    cc.quantidade
        AS quantidade_classe,

    card.quantidade_categorias,

    (
        COALESCE(cv.quantidade, 0) + 1
    )::NUMERIC
    /
    (
        cc.quantidade
        + card.quantidade_categorias
    ) AS probabilidade

FROM classes c

JOIN contagem_classe cc
    ON cc.classe = c.classe

CROSS JOIN feature_domains d

JOIN cardinalidade card
    ON card.feature = d.feature

LEFT JOIN contagem_valores cv
    ON cv.classe = c.classe
    AND cv.feature = d.feature
    AND cv.valor = d.valor;