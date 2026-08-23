CREATE OR REPLACE VIEW feature_values AS

SELECT
    s.id,
    s.rentavel AS classe,
    f.feature,
    f.valor

FROM safras_treinamento s

CROSS JOIN LATERAL (
    VALUES
        (
            'produtividade_estimada',
            s.produtividade_estimada
        ),
        (
            'preco_esperado_venda',
            s.preco_esperado_venda
        ),
        (
            'custo_total_producao',
            s.custo_total_producao
        ),
        (
            'precipitacao_acumulada',
            s.precipitacao_acumulada
        ),
        (
            'temperatura_media',
            s.temperatura_media
        ),
        (
            'incidencia_pragas_doencas',
            s.incidencia_pragas_doencas
        ),
        (
            'custo_insumos_agricolas',
            s.custo_insumos_agricolas
        ),
        (
            'historico_produtividade',
            s.historico_produtividade
        )

) AS f(feature, valor);