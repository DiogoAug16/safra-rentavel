-- Probabilidade a priori de cada classe, antes de observar as features.
-- Fórmula: P(classe) = quantidade_da_classe / quantidade_total.
CREATE OR REPLACE VIEW class_priors AS

SELECT
    cancelou_assinatura AS classe,
    COUNT(*) AS quantidade,

    -- P(classe) = quantidade_da_classe / quantidade_total.
    COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM assinaturas_treinamento) AS probabilidade

FROM assinaturas_treinamento

GROUP BY cancelou_assinatura;
