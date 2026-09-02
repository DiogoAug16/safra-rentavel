-- Registros usados para prever cancelamento de assinatura.
CREATE TABLE IF NOT EXISTS assinaturas_treinamento (
    id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    plano_assinatura VARCHAR(20) NOT NULL CHECK (plano_assinatura IN ('Basico', 'Intermediario', 'Premium')),
    frequencia_uso VARCHAR(10) NOT NULL CHECK (frequencia_uso IN ('Baixa', 'Media', 'Alta')),
    tempo_desde_ultimo_acesso VARCHAR(10) NOT NULL CHECK (tempo_desde_ultimo_acesso IN ('Recente', 'Moderado', 'Longo')),
    uso_beneficios_plano VARCHAR(10) NOT NULL CHECK (uso_beneficios_plano IN ('Baixo', 'Medio', 'Alto')),
    variacao_preco VARCHAR(10) NOT NULL CHECK (variacao_preco IN ('Manteve', 'Aumentou', 'Diminuiu')),
    percepcao_custo_beneficio VARCHAR(10) NOT NULL CHECK (percepcao_custo_beneficio IN ('Baixa', 'Media', 'Alta')),
    nivel_satisfacao VARCHAR(10) NOT NULL CHECK (nivel_satisfacao IN ('Baixo', 'Medio', 'Alto')),
    falhas_pagamento VARCHAR(12) NOT NULL CHECK (falhas_pagamento IN ('Nenhuma', 'Ocasional', 'Recorrente')),
    cancelou_assinatura VARCHAR(3) NOT NULL CHECK (cancelou_assinatura IN ('Sim', 'Nao'))
);
