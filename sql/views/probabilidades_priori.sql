-- Probabilidade a priori de cada classe, antes de observar as features.
-- Fórmula: P(classe) = quantidade_da_classe / quantidade_total.
CREATE OR REPLACE VIEW class_priors AS

SELECT
    rentavel AS classe,
    COUNT(*) AS quantidade,

    -- P(classe) = quantidade_da_classe / quantidade_total.
    COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM safras_treinamento) AS probabilidade

FROM safras_treinamento

GROUP BY rentavel;
