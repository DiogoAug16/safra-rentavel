-- Verossimilidade de cada valor de feature dentro de cada classe.
-- Fórmula de Laplace: P(feature = valor | classe) =
-- (ocorrencias + 1) / (quantidade_da_classe + numero_de_categorias).
-- O CROSS JOIN com feature_domains também cria linhas para valores
-- que ainda não apareceram nos dados, permitindo aplicar o +1.
CREATE OR REPLACE VIEW likelihoods AS

WITH

-- Cada CTE calcula uma parte necessária da fórmula de Laplace.
contagem_classe AS (
    -- Quantidade de registros em cada classe: Sim e Nao.
    SELECT
        cancelou_em_30_dias AS classe,
        COUNT(*) AS quantidade

    FROM assinaturas_treinamento

    GROUP BY cancelou_em_30_dias
),

cardinalidade AS (
    -- K: número de categorias disponíveis para cada feature.
    SELECT
        feature,
        COUNT(*) AS quantidade_categorias

    FROM feature_domains

    GROUP BY feature
),

contagem_valores AS (
    -- Quantidade observada de cada combinação classe, feature e valor.
    SELECT
        classe,
        feature,
        valor,
        COUNT(*) AS quantidade

    FROM feature_values

    GROUP BY
        classe,
        feature,
        valor
)

SELECT
    -- Classe para a qual a probabilidade será calculada.
    contagem_classe.classe,

    -- Nome da feature, como plano_assinatura.
    feature_domains.feature,

    -- Categoria da feature, como Alta ou Baixa.
    feature_domains.valor,

    -- Quantas vezes o valor apareceu dentro da classe.
    -- Se não apareceu, COALESCE transforma NULL em zero.
    COALESCE(contagem_valores.quantidade, 0) AS quantidade_observada,

    -- Quantidade total de registros da classe.
    contagem_classe.quantidade
        AS quantidade_classe,

    -- K: quantidade de categorias possíveis para a feature.
    cardinalidade.quantidade_categorias,

    -- Aplicação da suavização de Laplace:
    -- (ocorrencias + 1) / (quantidade_da_classe + K).
    (COALESCE(contagem_valores.quantidade, 0) + 1)::NUMERIC / (contagem_classe.quantidade + cardinalidade.quantidade_categorias)
    AS probabilidade

-- Começa com uma linha para cada classe existente.
FROM contagem_classe

-- Combina cada classe com todas as features e categorias permitidas.
-- Isso inclui categorias que ainda não apareceram nos dados.
CROSS JOIN feature_domains

-- Adiciona o número de categorias da feature, usado como K.
JOIN cardinalidade
    ON cardinalidade.feature = feature_domains.feature

-- Procura a quantidade observada para a combinação atual.
-- LEFT JOIN mantém a linha mesmo quando essa combinação não existe.
LEFT JOIN contagem_valores
    ON contagem_valores.classe = contagem_classe.classe
    AND contagem_valores.feature = feature_domains.feature
    AND contagem_valores.valor = feature_domains.valor;
