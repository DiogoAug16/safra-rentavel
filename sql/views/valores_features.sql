-- Converte as oito colunas de features em linhas no formato
-- (id, classe, feature, valor). Assim, as views de contagem podem
-- contar qualquer valor dentro de cada classe de forma uniforme.
CREATE OR REPLACE VIEW feature_values AS

SELECT
    s.id,
    s.cancelou_em_30_dias AS classe,
    f.feature,
    f.valor

FROM assinaturas_treinamento s

CROSS JOIN LATERAL (
    VALUES
        ('plano_assinatura', s.plano_assinatura),
        ('frequencia_uso', s.frequencia_uso),
        ('tempo_desde_ultimo_acesso', s.tempo_desde_ultimo_acesso),
        ('uso_beneficios_plano', s.uso_beneficios_plano),
        ('variacao_preco', s.variacao_preco),
        ('percepcao_custo_beneficio', s.percepcao_custo_beneficio),
        ('nivel_satisfacao', s.nivel_satisfacao),
        ('falhas_pagamento', s.falhas_pagamento)

) AS f(feature, valor);
