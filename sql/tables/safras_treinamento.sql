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

    rentavel VARCHAR(3) NOT NULL
        CHECK (
            rentavel IN ('Sim', 'Nao')
    )
);

ALTER TABLE safras_treinamento
ADD COLUMN IF NOT EXISTS nome_safra VARCHAR(100)
    NOT NULL DEFAULT 'Não informado';

ALTER TABLE safras_treinamento
ALTER COLUMN nome_safra DROP DEFAULT;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM pg_constraint
        WHERE conrelid = 'safras_treinamento'::REGCLASS
            AND conname = 'nome_safra_nao_vazio'
    ) THEN
        ALTER TABLE safras_treinamento
        ADD CONSTRAINT nome_safra_nao_vazio
        CHECK (BTRIM(nome_safra) <> '');
    END IF;
END;
$$;
