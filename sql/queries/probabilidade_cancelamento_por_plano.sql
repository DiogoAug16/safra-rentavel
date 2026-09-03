-- Calcula P(cancelou_em_30_dias = Sim | plano_assinatura).
-- O resultado mostra a taxa observada em cada plano no treinamento.
SELECT
    plano_assinatura,
    COUNT(*) FILTER (
        WHERE cancelou_em_30_dias = 'Sim'
    ) AS cancelamentos,
    COUNT(*) AS total_assinaturas,
    ROUND(
        100.0 * COUNT(*) FILTER (
            WHERE cancelou_em_30_dias = 'Sim'
        ) / COUNT(*),
        2
    ) AS probabilidade_cancelamento
FROM assinaturas_treinamento
GROUP BY plano_assinatura
ORDER BY probabilidade_cancelamento DESC, plano_assinatura;
