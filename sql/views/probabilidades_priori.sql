-- Probabilidade a priori de cada classe, antes de observar as features.
-- Fórmula: P(classe) = quantidade_da_classe / quantidade_total.
CREATE OR REPLACE VIEW class_priors AS

WITH total_registros AS (
    -- Conta todos os registros usados no treinamento.
    SELECT
        COUNT(*) AS total
    FROM safras_treinamento
),

quantidade_por_classe AS (
    -- Conta quantos registros pertencem a cada classe.
    SELECT
        rentavel AS classe,
        COUNT(*) AS quantidade
    FROM safras_treinamento
    GROUP BY rentavel
)

SELECT
    quantidade_por_classe.classe,
    quantidade_por_classe.quantidade,

    -- P(classe) = quantidade_da_classe / quantidade_total.
    quantidade_por_classe.quantidade::NUMERIC
        / total_registros.total AS probabilidade

FROM quantidade_por_classe

CROSS JOIN total_registros;
