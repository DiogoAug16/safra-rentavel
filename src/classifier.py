def classificar_cancelamento(
    conn,
    plano_assinatura: str,
    frequencia_uso: str,
    tempo_desde_ultimo_acesso: str,
    uso_beneficios_plano: str,
    variacao_preco: str,
    percepcao_custo_beneficio: str,
    nivel_satisfacao: str,
    falhas_pagamento: str,
):

    sql = """
        SELECT *
        FROM classificar_cancelamento(
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s,
            %s
        );
    """

    valores = (
        plano_assinatura,
        frequencia_uso,
        tempo_desde_ultimo_acesso,
        uso_beneficios_plano,
        variacao_preco,
        percepcao_custo_beneficio,
        nivel_satisfacao,
        falhas_pagamento,
    )

    with conn.cursor() as cursor:

        cursor.execute(
            sql,
            valores,
        )

        return cursor.fetchone()
