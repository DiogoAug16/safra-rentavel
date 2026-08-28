-- Probabilidade a priori de cada classe, antes de observar as features.
-- Fórmula: P(classe) = quantidade_da_classe / quantidade_total.
CREATE OR REPLACE VIEW class_priors AS

WITH total AS (
    SELECT
        COUNT(*) AS quantidade
    FROM safras_treinamento
)

SELECT
    s.rentavel AS classe,

    COUNT(*) AS quantidade,

    COUNT(*)::NUMERIC
        / total.quantidade AS probabilidade

FROM safras_treinamento s

CROSS JOIN total

GROUP BY
    s.rentavel,
    total.quantidade;
