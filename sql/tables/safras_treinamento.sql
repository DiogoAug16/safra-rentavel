-- Tabela com os registros usados para calcular as probabilidades do Naive Bayes.
-- Cada linha representa uma safra e sua classe final: rentavel = Sim ou Nao.
-- nome_safra identifica o registro.
CREATE TABLE IF NOT EXISTS safras_treinamento (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,

    nome_safra VARCHAR(100) NOT NULL
        CONSTRAINT nome_safra_nao_vazio
        CHECK (BTRIM(nome_safra) <> ''),

    produtividade_estimada VARCHAR(20) NOT NULL
        CHECK (
            produtividade_estimada IN (
                'Baixa',
                'Média',
                'Alta'
            )
        ),

    preco_esperado_venda VARCHAR(20) NOT NULL
        CHECK (
            preco_esperado_venda IN (
                'Baixo',
                'Normal',
                'Alto'
            )
        ),

    custo_total_producao VARCHAR(20) NOT NULL
        CHECK (
            custo_total_producao IN (
                'Baixo',
                'Médio',
                'Alto'
            )
        ),

    precipitacao_acumulada VARCHAR(20) NOT NULL
        CHECK (
            precipitacao_acumulada IN (
                'Insuficiente',
                'Adequada',
                'Excessiva'
            )
        ),

    temperatura_media VARCHAR(30) NOT NULL
        CHECK (
            temperatura_media IN (
                'Abaixo da faixa ideal',
                'Adequada',
                'Acima da faixa ideal'
            )
        ),

    incidencia_pragas_doencas VARCHAR(20) NOT NULL
        CHECK (
            incidencia_pragas_doencas IN (
                'Baixa',
                'Moderada',
                'Alta'
            )
        ),

    custo_insumos_agricolas VARCHAR(20) NOT NULL
        CHECK (
            custo_insumos_agricolas IN (
                'Baixo',
                'Normal',
                'Alto'
            )
        ),

    historico_produtividade VARCHAR(20) NOT NULL
        CHECK (
            historico_produtividade IN (
                'Baixo',
                'Médio',
                'Alto'
            )
        ),

    -- Classe que o modelo deve prever.
    rentavel VARCHAR(3) NOT NULL
        CHECK (
            rentavel IN ('Sim', 'Nao')
    )
);