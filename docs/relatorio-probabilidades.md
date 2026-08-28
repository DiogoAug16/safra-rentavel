# Relatório de probabilidades do Naive Bayes

Gerado pelo comando `python main.py probabilidades`.

## Probabilidades a priori

A probabilidade a priori mostra a proporção de cada classe antes da análise das features.

| Classe | Quantidade | Probabilidade |
| --- | --- | --- |
| Sim | 60 | 50.00% |
| Nao | 60 | 50.00% |

## Verossimilhanças

Esta tabela mostra `P(feature = valor | classe)`. Os valores já estão em porcentagem. `Observado` é a quantidade encontrada no CSV, e `Categorias (K)` é usada na suavização de Laplace.

| Classe | Feature | Valor | Observado | Registros da classe | Categorias (K) | Probabilidade |
| --- | --- | --- | --- | --- | --- | --- |
| Sim | produtividade_estimada | Alta | 32 | 60 | 3 | 52.38% |
| Sim | produtividade_estimada | Baixa | 9 | 60 | 3 | 15.87% |
| Sim | produtividade_estimada | Média | 19 | 60 | 3 | 31.75% |
| Sim | preco_esperado_venda | Alto | 29 | 60 | 3 | 47.62% |
| Sim | preco_esperado_venda | Baixo | 12 | 60 | 3 | 20.63% |
| Sim | preco_esperado_venda | Normal | 19 | 60 | 3 | 31.75% |
| Sim | custo_total_producao | Alto | 13 | 60 | 3 | 22.22% |
| Sim | custo_total_producao | Baixo | 28 | 60 | 3 | 46.03% |
| Sim | custo_total_producao | Médio | 19 | 60 | 3 | 31.75% |
| Sim | precipitacao_acumulada | Adequada | 28 | 60 | 3 | 46.03% |
| Sim | precipitacao_acumulada | Excessiva | 16 | 60 | 3 | 26.98% |
| Sim | precipitacao_acumulada | Insuficiente | 16 | 60 | 3 | 26.98% |
| Sim | temperatura_media | Abaixo da faixa ideal | 18 | 60 | 3 | 30.16% |
| Sim | temperatura_media | Acima da faixa ideal | 15 | 60 | 3 | 25.40% |
| Sim | temperatura_media | Adequada | 27 | 60 | 3 | 44.44% |
| Sim | incidencia_pragas_doencas | Alta | 14 | 60 | 3 | 23.81% |
| Sim | incidencia_pragas_doencas | Baixa | 25 | 60 | 3 | 41.27% |
| Sim | incidencia_pragas_doencas | Moderada | 21 | 60 | 3 | 34.92% |
| Sim | custo_insumos_agricolas | Alto | 15 | 60 | 3 | 25.40% |
| Sim | custo_insumos_agricolas | Baixo | 26 | 60 | 3 | 42.86% |
| Sim | custo_insumos_agricolas | Normal | 19 | 60 | 3 | 31.75% |
| Sim | historico_produtividade | Alto | 25 | 60 | 3 | 41.27% |
| Sim | historico_produtividade | Baixo | 15 | 60 | 3 | 25.40% |
| Sim | historico_produtividade | Médio | 20 | 60 | 3 | 33.33% |
| Nao | produtividade_estimada | Alta | 15 | 60 | 3 | 25.40% |
| Nao | produtividade_estimada | Baixa | 25 | 60 | 3 | 41.27% |
| Nao | produtividade_estimada | Média | 20 | 60 | 3 | 33.33% |
| Nao | preco_esperado_venda | Alto | 17 | 60 | 3 | 28.57% |
| Nao | preco_esperado_venda | Baixo | 24 | 60 | 3 | 39.68% |
| Nao | preco_esperado_venda | Normal | 19 | 60 | 3 | 31.75% |
| Nao | custo_total_producao | Alto | 24 | 60 | 3 | 39.68% |
| Nao | custo_total_producao | Baixo | 16 | 60 | 3 | 26.98% |
| Nao | custo_total_producao | Médio | 20 | 60 | 3 | 33.33% |
| Nao | precipitacao_acumulada | Adequada | 17 | 60 | 3 | 28.57% |
| Nao | precipitacao_acumulada | Excessiva | 21 | 60 | 3 | 34.92% |
| Nao | precipitacao_acumulada | Insuficiente | 22 | 60 | 3 | 36.51% |
| Nao | temperatura_media | Abaixo da faixa ideal | 22 | 60 | 3 | 36.51% |
| Nao | temperatura_media | Acima da faixa ideal | 21 | 60 | 3 | 34.92% |
| Nao | temperatura_media | Adequada | 17 | 60 | 3 | 28.57% |
| Nao | incidencia_pragas_doencas | Alta | 22 | 60 | 3 | 36.51% |
| Nao | incidencia_pragas_doencas | Baixa | 18 | 60 | 3 | 30.16% |
| Nao | incidencia_pragas_doencas | Moderada | 20 | 60 | 3 | 33.33% |
| Nao | custo_insumos_agricolas | Alto | 23 | 60 | 3 | 38.10% |
| Nao | custo_insumos_agricolas | Baixo | 18 | 60 | 3 | 30.16% |
| Nao | custo_insumos_agricolas | Normal | 19 | 60 | 3 | 31.75% |
| Nao | historico_produtividade | Alto | 19 | 60 | 3 | 31.75% |
| Nao | historico_produtividade | Baixo | 22 | 60 | 3 | 36.51% |
| Nao | historico_produtividade | Médio | 19 | 60 | 3 | 31.75% |

## Resultado do cenário padrão

| Probabilidade Sim | Probabilidade Nao | Classe | Recomendação |
| --- | --- | --- | --- |
| 93.59% | 6.41% | Sim | Alta probabilidade de rentabilidade. |
