def classificar_safra(
    conn,
    produtividade: str,
    preco: str,
    custo_producao: str,
    precipitacao: str,
    temperatura: str,
    pragas: str,
    custo_insumos: str,
    historico: str,
):

    sql = """
        SELECT *
        FROM classificar_safra(
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
        produtividade,
        preco,
        custo_producao,
        precipitacao,
        temperatura,
        pragas,
        custo_insumos,
        historico,
    )

    with conn.cursor() as cursor:

        cursor.execute(
            sql,
            valores,
        )

        return cursor.fetchone()