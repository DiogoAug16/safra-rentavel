# Resultados de log-odds

## Objetivo

O log-odds compara a mesma categoria entre os clientes que cancelaram e os que
não cancelaram a assinatura dentro de 30 dias.

`Sim` representa cancelamento e `Nao` representa permanência.

## Fórmula

$$
\text{log-odds} =
\ln\left(
\frac{P(\text{valor} \mid \text{Sim})}
{P(\text{valor} \mid \text{Nao})}
\right)
$$

Nessa fórmula:

- `P(valor | Sim)` é a probabilidade do valor entre os cancelamentos.
- `P(valor | Nao)` é a probabilidade do valor entre as permanências.
- `ln` é o logaritmo natural.

## Como interpretar

| Resultado | Interpretação |
| --- | --- |
| Positivo | O valor favorece a classe `Sim`, ou seja, o cancelamento. |
| Negativo | O valor favorece a classe `Nao`, ou seja, a permanência. |
| Próximo de zero | O valor aparece de forma parecida nas duas classes. |

Quanto maior o valor absoluto, maior a diferença entre as classes. O log-odds
mostra o poder de cada categoria isoladamente. Ele não é a probabilidade final
de cancelamento de um cliente, porque a previsão final também considera as
outras sete features.

## Resultados completos

Os valores estão ordenados pela maior diferença entre as classes:

| Feature | Valor | Entre `Sim` | Entre `Nao` | Log-odds | Efeito |
| --- | --- | ---: | ---: | ---: | --- |
| `tempo_desde_ultimo_acesso` | `Longo` | 26,88% | 2,55% | 2,3560 | `Sim` |
| `frequencia_uso` | `Baixa` | 51,62% | 5,54% | 2,2311 | `Sim` |
| `frequencia_uso` | `Alta` | 8,14% | 54,48% | -1,9016 | `Nao` |
| `uso_beneficios_plano` | `Alto` | 8,37% | 45,04% | -1,6826 | `Nao` |
| `percepcao_custo_beneficio` | `Alta` | 11,42% | 56,34% | -1,5962 | `Nao` |
| `nivel_satisfacao` | `Baixo` | 32,92% | 6,92% | 1,5595 | `Sim` |
| `uso_beneficios_plano` | `Baixo` | 56,09% | 12,60% | 1,4930 | `Sim` |
| `percepcao_custo_beneficio` | `Baixa` | 52,43% | 13,53% | 1,3543 | `Sim` |
| `falhas_pagamento` | `Recorrente` | 9,42% | 2,51% | 1,3210 | `Sim` |
| `nivel_satisfacao` | `Alto` | 18,60% | 57,99% | -1,1370 | `Nao` |
| `tempo_desde_ultimo_acesso` | `Recente` | 33,59% | 77,93% | -0,8416 | `Nao` |
| `plano_assinatura` | `Premium` | 11,99% | 26,45% | -0,7912 | `Nao` |
| `falhas_pagamento` | `Ocasional` | 24,98% | 11,74% | 0,7547 | `Sim` |
| `tempo_desde_ultimo_acesso` | `Moderado` | 39,53% | 19,52% | 0,7055 | `Sim` |
| `plano_assinatura` | `Basico` | 57,28% | 34,13% | 0,5179 | `Sim` |
| `variacao_preco` | `Aumentou` | 38,58% | 23,52% | 0,4950 | `Sim` |
| `variacao_preco` | `Diminuiu` | 3,62% | 5,85% | -0,4819 | `Nao` |
| `nivel_satisfacao` | `Medio` | 48,48% | 35,09% | 0,3232 | `Sim` |
| `falhas_pagamento` | `Nenhuma` | 65,60% | 85,74% | -0,2677 | `Nao` |
| `plano_assinatura` | `Intermediario` | 30,73% | 39,43% | -0,2492 | `Nao` |
| `variacao_preco` | `Manteve` | 57,80% | 70,63% | -0,2004 | `Nao` |
| `percepcao_custo_beneficio` | `Media` | 36,16% | 30,13% | 0,1823 | `Sim` |
| `uso_beneficios_plano` | `Medio` | 35,54% | 42,36% | -0,1755 | `Nao` |
| `frequencia_uso` | `Media` | 40,25% | 39,98% | 0,0067 | `Sim` |

## Principais resultados

As categorias que mais favorecem o cancelamento são:

- último acesso `Longo`, com log-odds `+2,3560`;
- frequência de uso `Baixa`, com `+2,2311`;
- satisfação `Baixo`, com `+1,5595`;
- uso de benefícios `Baixo`, com `+1,4930`;
- custo-benefício `Baixa`, com `+1,3543`.

As categorias que mais favorecem a permanência são:

- frequência de uso `Alta`, com log-odds `-1,9016`;
- uso de benefícios `Alto`, com `-1,6826`;
- custo-benefício `Alta`, com `-1,5962`;
- satisfação `Alto`, com `-1,1370`;
- último acesso `Recente`, com `-0,8416`.

A frequência de uso `Media` é quase neutra, com log-odds `+0,0067`. Isso
significa que ela aparece em proporções muito parecidas nas duas classes e,
sozinha, quase não diferencia cancelamento de permanência.

## Limitações da análise

O log-odds analisa uma categoria por vez. Uma categoria positiva não garante
que o cliente cancelará, assim como uma categoria negativa não garante que ele
permanecerá. A função `classificar_cancelamento()` combina todas as features e
as probabilidades a priori antes de produzir a previsão final.

Os valores dependem do CSV usado no treinamento. Além disso, algumas features
podem estar relacionadas, mas o Naive Bayes trata cada uma separadamente. Por
isso, vários sinais parecidos podem deixar o resultado mais confiante do que o
ideal.

## Como gerar os resultados

Linux/macOS:

```bash
./scripts/linux/log_odds.sh
```

Windows PowerShell:

```powershell
.\scripts\windows\log_odds.ps1
```
