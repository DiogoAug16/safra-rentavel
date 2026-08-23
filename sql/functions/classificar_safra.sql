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

LANGUAGE plpgsql

AS $$

BEGIN

    RETURN QUERY

    WITH

    entrada(feature, valor) AS (
        VALUES
            (
                'produtividade_estimada',
                p_produtividade_estimada
            ),
            (
                'preco_esperado_venda',
                p_preco_esperado_venda
            ),
            (
                'custo_total_producao',
                p_custo_total_producao
            ),
            (
                'precipitacao_acumulada',
                p_precipitacao_acumulada
            ),
            (
                'temperatura_media',
                p_temperatura_media
            ),
            (
                'incidencia_pragas_doencas',
                p_incidencia_pragas_doencas
            ),
            (
                'custo_insumos_agricolas',
                p_custo_insumos_agricolas
            ),
            (
                'historico_produtividade',
                p_historico_produtividade
            )
    ),

    scores AS (
        SELECT
            prior.classe,

            LN(
                prior.probabilidade::DOUBLE PRECISION
            )
            +
            SUM(
                LN (
                likelihood.probabilidade::DOUBLE PRECISION
                )
            ) AS log_score

        FROM class_priors prior

        JOIN likelihoods likelihood
            ON likelihood.classe = prior.classe

        JOIN entrada e
            ON e.feature = likelihood.feature
            AND e.valor = likelihood.valor

        GROUP BY
            prior.classe,
            prior.probabilidade
    ),

    scores_estabilizados AS (
        SELECT
            classe,
            log_score,

            MAX(log_score) OVER ()
                AS maior_log_score

        FROM scores
    ),

    pesos AS (
        SELECT
            classe,

            EXP(
                log_score - maior_log_score
            ) AS peso

        FROM scores_estabilizados
    ),

    probabilidades AS (
        SELECT
            classe,

            (
                peso
                /
                SUM(peso) OVER ()
            ) * 100 AS percentual

        FROM pesos
    ),

    resultado AS (
        SELECT

            MAX(percentual)
                FILTER (
                    WHERE classe = 'Sim'
                ) AS p_sim,

            MAX(percentual)
                FILTER (
                    WHERE classe = 'Nao'
                ) AS p_nao

        FROM probabilidades
    )

    SELECT
        ROUND(
            p_sim::NUMERIC,
            2
        ),

        ROUND(
            p_nao::NUMERIC,
            2
        ),

        CASE
            WHEN p_sim >= p_nao
                THEN 'Sim'::TEXT
            ELSE
                'Nao'::TEXT
        END,

        CASE
            WHEN p_sim >= 70 THEN
                'Alta probabilidade de rentabilidade.'::TEXT

            WHEN p_sim >= 50 THEN
                'A safra tende a ser rentável, mas apresenta fatores de risco.'::TEXT

            WHEN p_nao >= 70 THEN
                'Alto risco de não rentabilidade.'::TEXT

            ELSE
                'Cenário limítrofe. Recomenda-se análise adicional.'::TEXT
        END

    FROM resultado;

END;

$$;