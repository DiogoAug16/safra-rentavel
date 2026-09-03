-- Nove casos variados para testar as principais faixas de recomendação.
SELECT
    '01_muito_alta_cancelamento' AS caso,
    'Inativo e insatisfeito' AS perfil,
    'Longo período sem acesso e baixa satisfação.' AS contexto_situacao,
    *
FROM classificar_cancelamento(
    'Basico',
    'Alta',
    'Longo',
    'Alto',
    'Aumentou',
    'Baixa',
    'Baixo',
    'Ocasional'
)

UNION ALL

SELECT
    '02_muito_alta_permanencia',
    'Engajado e satisfeito',
    'Acesso recente, satisfação alta e sem falhas de pagamento.',
    *
FROM classificar_cancelamento(
    'Premium',
    'Media',
    'Recente',
    'Medio',
    'Aumentou',
    'Alta',
    'Medio',
    'Nenhuma'
)

UNION ALL

SELECT
    '03_limite_muito_alta_cancelamento',
    'Pouco uso e baixa satisfação',
    'Baixo uso e baixa satisfação, apesar do acesso recente.',
    *
FROM classificar_cancelamento(
    'Basico',
    'Baixa',
    'Recente',
    'Alto',
    'Manteve',
    'Media',
    'Baixo',
    'Ocasional'
)

UNION ALL

SELECT
    '04_limite_muito_alta_permanencia',
    'Boa permanência',
    'Plano Premium, acesso recente e boa avaliação de valor.',
    *
FROM classificar_cancelamento(
    'Premium',
    'Media',
    'Recente',
    'Baixo',
    'Manteve',
    'Alta',
    'Medio',
    'Nenhuma'
)

UNION ALL

SELECT
    '05_tendencia_moderada_cancelamento',
    'Sinais mistos',
    'Satisfação alta, mas falhas recorrentes e pouco uso de benefícios.',
    *
FROM classificar_cancelamento(
    'Premium',
    'Media',
    'Recente',
    'Baixo',
    'Aumentou',
    'Media',
    'Alto',
    'Recorrente'
)

UNION ALL

SELECT
    '06_tendencia_moderada_permanencia',
    'Premium com sinais mistos',
    'Plano Premium e sem falhas, mas pouco uso e baixa satisfação.',
    *
FROM classificar_cancelamento(
    'Premium',
    'Baixa',
    'Recente',
    'Medio',
    'Manteve',
    'Alta',
    'Baixo',
    'Nenhuma'
)

UNION ALL

SELECT
    '07_perfil_ambiguo',
    'Perfil equilibrado',
    'Uso alto e satisfação alta, mas falhas e baixo valor percebido.',
    *
FROM classificar_cancelamento(
    'Basico',
    'Alta',
    'Recente',
    'Baixo',
    'Diminuiu',
    'Baixa',
    'Alto',
    'Recorrente'
)

UNION ALL

SELECT
    '08_premium_sinais_mistos',
    'Premium com sinais negativos',
    'Plano Premium, porém baixa satisfação e falhas recorrentes.',
    *
FROM classificar_cancelamento(
    'Premium',
    'Media',
    'Recente',
    'Alto',
    'Aumentou',
    'Baixa',
    'Baixo',
    'Recorrente'
)

UNION ALL

SELECT
    '09_valor_nao_visto',
    'Categoria não planejada',
    'Plano não planejado, longo tempo sem acesso e baixa satisfação.',
    *
FROM classificar_cancelamento(
    'Corporativo',
    'Alta',
    'Longo',
    'Alto',
    'Aumentou',
    'Baixa',
    'Baixo',
    'Ocasional'
);
