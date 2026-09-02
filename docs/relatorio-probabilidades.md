# Relatório de probabilidades do Naive Bayes

Valores calculados deterministicamente a partir de `data/plataformas_digitais.csv`. `Sim` é cancelamento; `Nao` é permanência.

## Probabilidades a priori

| Classe | Quantidade | Probabilidade |
| --- | ---: | ---: |
| Sim | 2,099 | 41.98% |
| Nao | 2,901 | 58.02% |

## Verossimilhanças com Laplace

`Probabilidade = (Observado + 1) / (Registros da classe + 3)`. Cada feature tem três categorias.

| Classe | Feature | Valor | Observado | Registros da classe | K | Probabilidade |
| --- | --- | --- | ---: | ---: | ---: | ---: |
| Sim | plano_assinatura | Basico | 1203 | 2099 | 3 | 57.28% |
| Sim | plano_assinatura | Intermediario | 645 | 2099 | 3 | 30.73% |
| Sim | plano_assinatura | Premium | 251 | 2099 | 3 | 11.99% |
| Sim | frequencia_uso | Baixa | 1084 | 2099 | 3 | 51.62% |
| Sim | frequencia_uso | Media | 845 | 2099 | 3 | 40.25% |
| Sim | frequencia_uso | Alta | 170 | 2099 | 3 | 8.14% |
| Sim | tempo_desde_ultimo_acesso | Recente | 705 | 2099 | 3 | 33.59% |
| Sim | tempo_desde_ultimo_acesso | Moderado | 830 | 2099 | 3 | 39.53% |
| Sim | tempo_desde_ultimo_acesso | Longo | 564 | 2099 | 3 | 26.88% |
| Sim | uso_beneficios_plano | Baixo | 1178 | 2099 | 3 | 56.09% |
| Sim | uso_beneficios_plano | Medio | 746 | 2099 | 3 | 35.54% |
| Sim | uso_beneficios_plano | Alto | 175 | 2099 | 3 | 8.37% |
| Sim | variacao_preco | Manteve | 1214 | 2099 | 3 | 57.80% |
| Sim | variacao_preco | Aumentou | 810 | 2099 | 3 | 38.58% |
| Sim | variacao_preco | Diminuiu | 75 | 2099 | 3 | 3.62% |
| Sim | percepcao_custo_beneficio | Baixa | 1101 | 2099 | 3 | 52.43% |
| Sim | percepcao_custo_beneficio | Media | 759 | 2099 | 3 | 36.16% |
| Sim | percepcao_custo_beneficio | Alta | 239 | 2099 | 3 | 11.42% |
| Sim | nivel_satisfacao | Baixo | 691 | 2099 | 3 | 32.92% |
| Sim | nivel_satisfacao | Medio | 1018 | 2099 | 3 | 48.48% |
| Sim | nivel_satisfacao | Alto | 390 | 2099 | 3 | 18.60% |
| Sim | falhas_pagamento | Nenhuma | 1378 | 2099 | 3 | 65.60% |
| Sim | falhas_pagamento | Ocasional | 524 | 2099 | 3 | 24.98% |
| Sim | falhas_pagamento | Recorrente | 197 | 2099 | 3 | 9.42% |
| Nao | plano_assinatura | Basico | 990 | 2901 | 3 | 34.13% |
| Nao | plano_assinatura | Intermediario | 1144 | 2901 | 3 | 39.43% |
| Nao | plano_assinatura | Premium | 767 | 2901 | 3 | 26.45% |
| Nao | frequencia_uso | Baixa | 160 | 2901 | 3 | 5.54% |
| Nao | frequencia_uso | Media | 1160 | 2901 | 3 | 39.98% |
| Nao | frequencia_uso | Alta | 1581 | 2901 | 3 | 54.48% |
| Nao | tempo_desde_ultimo_acesso | Recente | 2262 | 2901 | 3 | 77.93% |
| Nao | tempo_desde_ultimo_acesso | Moderado | 566 | 2901 | 3 | 19.52% |
| Nao | tempo_desde_ultimo_acesso | Longo | 73 | 2901 | 3 | 2.55% |
| Nao | uso_beneficios_plano | Baixo | 365 | 2901 | 3 | 12.60% |
| Nao | uso_beneficios_plano | Medio | 1229 | 2901 | 3 | 42.36% |
| Nao | uso_beneficios_plano | Alto | 1307 | 2901 | 3 | 45.04% |
| Nao | variacao_preco | Manteve | 2050 | 2901 | 3 | 70.63% |
| Nao | variacao_preco | Aumentou | 682 | 2901 | 3 | 23.52% |
| Nao | variacao_preco | Diminuiu | 169 | 2901 | 3 | 5.85% |
| Nao | percepcao_custo_beneficio | Baixa | 392 | 2901 | 3 | 13.53% |
| Nao | percepcao_custo_beneficio | Media | 874 | 2901 | 3 | 30.13% |
| Nao | percepcao_custo_beneficio | Alta | 1635 | 2901 | 3 | 56.34% |
| Nao | nivel_satisfacao | Baixo | 200 | 2901 | 3 | 6.92% |
| Nao | nivel_satisfacao | Medio | 1018 | 2901 | 3 | 35.09% |
| Nao | nivel_satisfacao | Alto | 1683 | 2901 | 3 | 57.99% |
| Nao | falhas_pagamento | Nenhuma | 2489 | 2901 | 3 | 85.74% |
| Nao | falhas_pagamento | Ocasional | 340 | 2901 | 3 | 11.74% |
| Nao | falhas_pagamento | Recorrente | 72 | 2901 | 3 | 2.51% |

## Cenário padrão

Para `Basico`, `Baixa`, `Longo`, `Baixo`, `Aumentou`, `Baixa`, `Baixo` e `Recorrente`, o cálculo sem arredondamento produz `Sim = 99,9983367%` e `Nao = 0,0016633%`. A função SQL arredonda para `100,00%` e `0,00%`; a recomendação é risco muito alto de cancelamento.
