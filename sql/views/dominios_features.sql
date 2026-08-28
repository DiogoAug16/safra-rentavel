-- Catálogo dos valores aceitos por cada feature categórica.
-- O total de categorias de cada feature é usado como K na suavização de Laplace.
CREATE OR REPLACE VIEW feature_domains (feature, valor) AS

VALUES
    ('produtividade_estimada', 'Baixa'),
    ('produtividade_estimada', 'Média'),
    ('produtividade_estimada', 'Alta'),

    ('preco_esperado_venda', 'Baixo'),
    ('preco_esperado_venda', 'Normal'),
    ('preco_esperado_venda', 'Alto'),

    ('custo_total_producao', 'Baixo'),
    ('custo_total_producao', 'Médio'),
    ('custo_total_producao', 'Alto'),

    ('precipitacao_acumulada', 'Insuficiente'),
    ('precipitacao_acumulada', 'Adequada'),
    ('precipitacao_acumulada', 'Excessiva'),

    ('temperatura_media', 'Abaixo da faixa ideal'),
    ('temperatura_media', 'Adequada'),
    ('temperatura_media', 'Acima da faixa ideal'),

    ('incidencia_pragas_doencas', 'Baixa'),
    ('incidencia_pragas_doencas', 'Moderada'),
    ('incidencia_pragas_doencas', 'Alta'),

    ('custo_insumos_agricolas', 'Baixo'),
    ('custo_insumos_agricolas', 'Normal'),
    ('custo_insumos_agricolas', 'Alto'),

    ('historico_produtividade', 'Baixo'),
    ('historico_produtividade', 'Médio'),
    ('historico_produtividade', 'Alto');
