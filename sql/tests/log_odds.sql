-- Compara a mesma categoria entre as classes Sim e Nao.
-- Log-odds positivo favorece Sim; negativo favorece Nao.
WITH probabilidades AS (
    -- Coloca as probabilidades de Sim e Nao na mesma linha.
    SELECT
        feature,
        valor,

        -- Probabilidade do valor dentro da classe Sim.
        MAX(probabilidade) FILTER (WHERE classe = 'Sim') AS prob_sim,

        -- Probabilidade do valor dentro da classe Nao.
        MAX(probabilidade) FILTER (WHERE classe = 'Nao') AS prob_nao

    FROM likelihoods

    GROUP BY
        feature,
        valor
),

log_odds_calculado AS (
    -- Compara as probabilidades das duas classes usando logaritmo natural.
    -- Fórmula: log_odds = LN(P(valor | Sim) / P(valor | Nao)).
    SELECT
        feature,
        valor,
        prob_sim,
        prob_nao,
        LN(prob_sim / prob_nao) AS log_odds

    FROM probabilidades
)

SELECT
    -- Nome da feature e categoria analisada.
    feature,
    valor,

    -- Converte as probabilidades decimais para porcentagens.
    ROUND(prob_sim * 100, 2) AS probabilidade_sim,
    ROUND(prob_nao * 100, 2) AS probabilidade_nao,

    -- Mostra a diferença entre as classes com quatro casas decimais.
    ROUND(log_odds, 4) AS log_odds,

    -- O sinal indica qual classe é favorecida.
    CASE
        WHEN log_odds > 0 THEN 'Sim'
        WHEN log_odds < 0 THEN 'Nao'
        ELSE 'Neutro'
    END AS efeito

FROM log_odds_calculado

-- Exibe primeiro as categorias com maior diferença entre as classes.
ORDER BY ABS(log_odds) DESC, feature, valor;
