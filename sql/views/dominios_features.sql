-- Catálogo dos valores aceitos por cada feature categórica.
-- O total de categorias de cada feature é usado como K na suavização de Laplace.
CREATE OR REPLACE VIEW feature_domains (feature, valor) AS

VALUES
    ('plano_assinatura', 'Basico'),
    ('plano_assinatura', 'Intermediario'),
    ('plano_assinatura', 'Premium'),
    ('frequencia_uso', 'Baixa'),
    ('frequencia_uso', 'Media'),
    ('frequencia_uso', 'Alta'),
    ('tempo_desde_ultimo_acesso', 'Recente'),
    ('tempo_desde_ultimo_acesso', 'Moderado'),
    ('tempo_desde_ultimo_acesso', 'Longo'),
    ('uso_beneficios_plano', 'Baixo'),
    ('uso_beneficios_plano', 'Medio'),
    ('uso_beneficios_plano', 'Alto'),
    ('variacao_preco', 'Manteve'),
    ('variacao_preco', 'Aumentou'),
    ('variacao_preco', 'Diminuiu'),
    ('percepcao_custo_beneficio', 'Baixa'),
    ('percepcao_custo_beneficio', 'Media'),
    ('percepcao_custo_beneficio', 'Alta'),
    ('nivel_satisfacao', 'Baixo'),
    ('nivel_satisfacao', 'Medio'),
    ('nivel_satisfacao', 'Alto'),
    ('falhas_pagamento', 'Nenhuma'),
    ('falhas_pagamento', 'Ocasional'),
    ('falhas_pagamento', 'Recorrente');
