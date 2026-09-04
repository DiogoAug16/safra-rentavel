-- Classifica uma assinatura pelas probabilidades calculadas nas views.

-- O alvo possui duas classes:
--   Sim: o cliente cancelou dentro de 30 dias.
--   Nao: o cliente não cancelou dentro de 30 dias.
CREATE OR REPLACE FUNCTION classificar_cancelamento(
    -- As oito features categóricas de uma nova assinatura.
    p_plano_assinatura TEXT,
    p_frequencia_uso TEXT,
    p_tempo_desde_ultimo_acesso TEXT,
    p_uso_beneficios_plano TEXT,
    p_variacao_preco TEXT,
    p_percepcao_custo_beneficio TEXT,
    p_nivel_satisfacao TEXT,
    p_falhas_pagamento TEXT
)
RETURNS TABLE (
    -- Probabilidades finais em percentual, arredondadas para duas casas.
    probabilidade_sim NUMERIC(6,2),
    probabilidade_nao NUMERIC(6,2),
    classe_prevista TEXT,
    recomendacao TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY

    -- Organiza a entrada no mesmo formato da view feature_values.
    WITH entrada(feature, valor) AS (
        VALUES
            ('plano_assinatura', p_plano_assinatura),
            ('frequencia_uso', p_frequencia_uso),
            ('tempo_desde_ultimo_acesso', p_tempo_desde_ultimo_acesso),
            ('uso_beneficios_plano', p_uso_beneficios_plano),
            ('variacao_preco', p_variacao_preco),
            ('percepcao_custo_beneficio', p_percepcao_custo_beneficio),
            ('nivel_satisfacao', p_nivel_satisfacao),
            ('falhas_pagamento', p_falhas_pagamento)
    ),

    -- K é a quantidade de categorias disponíveis para cada feature.
    cardinalidade AS (
        SELECT feature, COUNT(*) AS quantidade_categorias
        FROM feature_domains
        GROUP BY feature
    ),

    -- Calcula o log da probabilidade conjunta para cada classe:
    -- log(P(C)) + soma(log(P(feature = valor | C))).
    -- busca as probabilidades de cada dado e calcula o scre de cada classe
    scores AS (
        SELECT
            class_priors.classe,
            LN(class_priors.probabilidade) + SUM(
                LN(
                    COALESCE(
                        likelihoods.probabilidade,

                        -- Categoria não vista: fallback de Laplace.
                        1::NUMERIC / (
                            class_priors.quantidade
                            + cardinalidade.quantidade_categorias
                        )
                    )
                )
            ) AS log_score
        FROM class_priors
        CROSS JOIN entrada
        JOIN cardinalidade
            ON cardinalidade.feature = entrada.feature
        LEFT JOIN likelihoods
            ON likelihoods.classe = class_priors.classe
            AND likelihoods.feature = entrada.feature
            AND likelihoods.valor = entrada.valor
        GROUP BY
            class_priors.classe,
            class_priors.probabilidade,
            class_priors.quantidade
    ),

    -- converter score em formato comparavel
    pesos AS (
        SELECT
            classe,
            EXP(log_score - MAX(log_score) OVER ()) AS peso
        FROM scores
    ),

    -- transforma tudo e porcentagens simples
    probabilidades AS (
        SELECT
            classe,
            (peso / SUM(peso) OVER ()) * 100 AS percentual
        FROM pesos
    ),

    -- Coloca as duas classes na mesma linha para formar a saída final.
    -- comparar as porcentagens escolhe a vencedora e da a recomendacao final
    resultado AS (
        SELECT
            MAX(percentual) FILTER (WHERE classe = 'Sim') AS p_sim,
            MAX(percentual) FILTER (WHERE classe = 'Nao') AS p_nao
        FROM probabilidades
    )
    SELECT
        -- Arredondamento apenas na apresentação do resultado.
        ROUND(p_sim::NUMERIC, 2),
        ROUND(p_nao::NUMERIC, 2),

        -- A classe prevista é a que possui a maior probabilidade.
        CASE
            WHEN p_sim >= p_nao THEN 'Sim'::TEXT
            ELSE 'Nao'::TEXT
        END,

        -- A recomendação interpreta a probabilidade;
        CASE
            WHEN p_sim >= 90 THEN 'Tendência muito alta de cancelamento.'::TEXT
            WHEN p_nao >= 90 THEN 'Tendência muito alta de permanência.'::TEXT
            WHEN p_sim >= 70 THEN 'Alta tendência de cancelamento.'::TEXT
            WHEN p_nao >= 70 THEN 'Alta tendência de permanência.'::TEXT
            WHEN p_sim >= 55 THEN 'Tendência moderada de cancelamento.'::TEXT
            WHEN p_nao >= 55 THEN 'Tendência moderada de permanência.'::TEXT
            ELSE 'Cenário equilibrado; recomenda-se análise adicional.'::TEXT
        END
    FROM resultado;
END;
$$;
