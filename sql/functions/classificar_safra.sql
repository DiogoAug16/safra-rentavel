-- Classifica um novo cenário usando as probabilidades calculadas pelas views.
CREATE OR REPLACE FUNCTION classificar_safra(
    p_produtividade_estimada TEXT,
    p_preco_esperado_venda TEXT,
    p_custo_total_producao TEXT,
    p_precipitacao_acumulada TEXT,
    p_temperatura_media TEXT,
    p_incidencia_pragas_doencas TEXT,
    p_custo_insumos_agricolas TEXT,
    p_historico_produtividade TEXT
)

RETURNS TABLE (
    probabilidade_sim NUMERIC(6,2),
    probabilidade_nao NUMERIC(6,2),
    classe_prevista TEXT,
    recomendacao TEXT
)

LANGUAGE SQL

AS $$

WITH

    -- Organiza os oito parâmetros recebidos no mesmo formato da view
    -- feature_values para encontrar suas verossimilhanças.
    entrada(feature, valor) AS (
        VALUES
            ('produtividade_estimada', p_produtividade_estimada),
            ('preco_esperado_venda', p_preco_esperado_venda),
            ('custo_total_producao', p_custo_total_producao),
            ('precipitacao_acumulada', p_precipitacao_acumulada),
            ('temperatura_media', p_temperatura_media),
            ('incidencia_pragas_doencas', p_incidencia_pragas_doencas),
            ('custo_insumos_agricolas', p_custo_insumos_agricolas),
            ('historico_produtividade', p_historico_produtividade)
    ),

    scores AS (
        -- Soma dos logaritmos: evita multiplicar probabilidades muito pequenas.
        -- log_score(classe) = LN(P(classe)) + soma(LN(P(feature | classe))).
        SELECT
            class_priors.classe,
            LN(class_priors.probabilidade)
            + SUM(LN(likelihoods.probabilidade)) AS log_score

        FROM class_priors

        JOIN likelihoods
            ON likelihoods.classe = class_priors.classe

        JOIN entrada
            ON entrada.feature = likelihoods.feature
            AND entrada.valor = likelihoods.valor

        GROUP BY
            class_priors.classe,
            class_priors.probabilidade
    ),

    pesos AS (
        -- Subtrair o maior score antes de EXP() evita números muito grandes.
        -- A classe com maior score fica com diferença igual a zero.
        SELECT
            classe,
            EXP(log_score - MAX(log_score) OVER ()) AS peso

        FROM scores
    ),

    probabilidades AS (
        -- Normalização final: cada peso / soma dos pesos * 100.
        -- Por isso, as probabilidades Sim e Nao somam aproximadamente 100%.
        SELECT
            classe,
            (peso / SUM(peso) OVER ()) * 100 AS percentual

        FROM pesos
    ),

    resultado AS (
        -- Reúne as probabilidades das duas classes em uma única linha.
        SELECT

            -- Seleciona o percentual da classe Sim.
            MAX(percentual) FILTER (WHERE classe = 'Sim') AS p_sim,

            -- Seleciona o percentual da classe Nao.
            MAX(percentual) FILTER (WHERE classe = 'Nao') AS p_nao

        FROM probabilidades
    )

    SELECT
        -- Arredonda a probabilidade de Sim para duas casas decimais.
        ROUND(p_sim::NUMERIC, 2),

        -- Arredonda a probabilidade de Nao para duas casas decimais.
        ROUND(p_nao::NUMERIC, 2),

        -- A classe com maior probabilidade vence; em empate, Sim vence.
        CASE
            WHEN p_sim >= p_nao
                THEN 'Sim'::TEXT
            ELSE
                'Nao'::TEXT
        END,

        -- A recomendação é uma regra de decisão posterior ao Naive Bayes.
        CASE
            WHEN p_sim >= 90 THEN
                'Probabilidade muito alta de rentabilidade.'::TEXT

            WHEN p_sim >= 70 THEN
                'Alta probabilidade de rentabilidade.'::TEXT

            WHEN p_sim >= 50 THEN
                'A safra tende a ser rentável, mas apresenta fatores de risco.'::TEXT

            WHEN p_nao >= 90 THEN
                'Probabilidade muito alta de não rentabilidade.'::TEXT

            WHEN p_nao >= 70 THEN
                'Alto risco de não rentabilidade.'::TEXT

            WHEN p_nao >= 50 THEN
                'A safra tende a não ser rentável, mas o cenário não é definitivo.'::TEXT

            ELSE
                'Cenário equilibrado. Recomenda-se análise adicional.'::TEXT
        END

    FROM resultado;

$$;
