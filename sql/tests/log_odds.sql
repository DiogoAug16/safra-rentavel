-- Compara a mesma categoria entre as classes Sim e Nao.
-- Log-odds positivo favorece Sim; negativo favorece Nao.
WITH probabilidades AS (
    SELECT
        feature,
        valor,
        MAX(probabilidade) FILTER (WHERE classe = 'Sim') AS prob_sim,
        MAX(probabilidade) FILTER (WHERE classe = 'Nao') AS prob_nao

    FROM likelihoods

    GROUP BY
        feature,
        valor
),

odds AS (
    SELECT
        feature,
        valor,
        prob_sim,
        prob_nao,
        LN(
            (prob_sim / prob_nao)::DOUBLE PRECISION
        ) AS log_odds

    FROM probabilidades
)

SELECT
    feature,
    valor,
    ROUND((prob_sim * 100)::NUMERIC, 2) AS probabilidade_sim,
    ROUND((prob_nao * 100)::NUMERIC, 2) AS probabilidade_nao,
    ROUND(log_odds::NUMERIC, 4) AS log_odds,

    CASE
        WHEN log_odds > 0 THEN 'Sim'
        WHEN log_odds < 0 THEN 'Nao'
        ELSE 'Neutro'
    END AS efeito

FROM odds

ORDER BY
    ABS(log_odds) DESC,
    feature,
    valor;
