-- Classifica uma assinatura pelas probabilidades calculadas nas views.
CREATE OR REPLACE FUNCTION classificar_cancelamento(
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
    probabilidade_sim NUMERIC(6,2),
    probabilidade_nao NUMERIC(6,2),
    classe_prevista TEXT,
    recomendacao TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM (
            VALUES
                ('plano_assinatura', p_plano_assinatura),
                ('frequencia_uso', p_frequencia_uso),
                ('tempo_desde_ultimo_acesso', p_tempo_desde_ultimo_acesso),
                ('uso_beneficios_plano', p_uso_beneficios_plano),
                ('variacao_preco', p_variacao_preco),
                ('percepcao_custo_beneficio', p_percepcao_custo_beneficio),
                ('nivel_satisfacao', p_nivel_satisfacao),
                ('falhas_pagamento', p_falhas_pagamento)
        ) AS entrada(feature, valor)
        LEFT JOIN feature_domains USING (feature, valor)
        WHERE feature_domains.feature IS NULL
    ) THEN
        RAISE EXCEPTION 'Entrada inválida para classificar_cancelamento';
    END IF;

    RETURN QUERY
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
    scores AS (
        SELECT
            class_priors.classe,
            LN(class_priors.probabilidade) + SUM(LN(likelihoods.probabilidade)) AS log_score
        FROM class_priors
        JOIN likelihoods ON likelihoods.classe = class_priors.classe
        JOIN entrada ON entrada.feature = likelihoods.feature AND entrada.valor = likelihoods.valor
        GROUP BY class_priors.classe, class_priors.probabilidade
    ),
    pesos AS (
        SELECT classe, EXP(log_score - MAX(log_score) OVER ()) AS peso
        FROM scores
    ),
    probabilidades AS (
        SELECT classe, (peso / SUM(peso) OVER ()) * 100 AS percentual
        FROM pesos
    ),
    resultado AS (
        SELECT
            MAX(percentual) FILTER (WHERE classe = 'Sim') AS p_sim,
            MAX(percentual) FILTER (WHERE classe = 'Nao') AS p_nao
        FROM probabilidades
    )
    SELECT
        ROUND(p_sim::NUMERIC, 2),
        ROUND(p_nao::NUMERIC, 2),
        CASE WHEN p_sim >= p_nao THEN 'Sim'::TEXT ELSE 'Nao'::TEXT END,
        CASE
            WHEN p_sim >= 90 THEN 'Risco muito alto de cancelamento.'::TEXT
            WHEN p_sim >= 70 THEN 'Alto risco de cancelamento.'::TEXT
            WHEN p_sim >= 50 THEN 'A assinatura tende ao cancelamento; faça uma intervenção.'::TEXT
            WHEN p_nao >= 90 THEN 'Risco muito baixo de cancelamento.'::TEXT
            WHEN p_nao >= 70 THEN 'Baixo risco de cancelamento.'::TEXT
            WHEN p_nao >= 50 THEN 'A assinatura tende à permanência, mas requer acompanhamento.'::TEXT
            ELSE 'Cenário equilibrado. Recomenda-se análise adicional.'::TEXT
        END
    FROM resultado;
END;
$$;
