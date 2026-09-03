# Naive Bayes aplicado à previsão de cancelamento de assinaturas

## Objetivo do projeto

Este projeto usa dados de assinaturas para estimar o risco de cancelamento.

- `Sim` significa que o cliente cancelou a assinatura dentro de 30 dias.
- `Nao` significa que o cliente não cancelou a assinatura dentro de 30 dias.

Para cada nova assinatura, o sistema recebe oito características e devolve:

- a probabilidade de cancelamento;
- a probabilidade de permanência;
- a classe mais provável;
- uma recomendação de risco.

## Dados e treinamento

## 1. O problema

Uma plataforma quer identificar assinaturas com maior chance de cancelamento. A equipe pode usar essa previsão para entrar em contato com clientes de risco, revisar benefícios ou corrigir problemas de pagamento.

O conjunto tem 5.000 assinaturas. Cada uma possui oito características e um
resultado final, `Sim` ou `Nao`, observado após o período de 30 dias.

| Característica | Categorias usadas no projeto |
| --- | --- |
| Plano de assinatura | Básico, Intermediário, Premium |
| Frequência de uso | Baixa, Média, Alta |
| Tempo desde o último acesso | Recente, Moderado, Longo |
| Uso dos benefícios do plano | Baixo, Médio, Alto |
| Variação de preço | Manteve, Aumentou, Diminuiu |
| Percepção de custo-benefício | Baixa, Média, Alta |
| Nível de satisfação | Baixo, Médio, Alto |
| Falhas de pagamento | Nenhuma, Ocasional, Recorrente |

Cada característica tem três categorias. Por isso, o modelo trabalha com 24 combinações entre característica e categoria. Como cada uma das 5.000 assinaturas traz oito valores, o treinamento analisa 40.000 valores de características.

## 2. Ponto de partida: probabilidades a priori

Antes de olhar as características, o modelo observa a distribuição geral dos resultados.

| Resultado | Registros | Probabilidade inicial |
| --- | ---: | ---: |
| Cancelou, `Sim` | 2.099 | 41,98% |
| Permaneceu, `Nao` | 2.901 | 58,02% |

A probabilidade a priori calcula a chance de cada classe antes de analisar uma assinatura específica:

$$
P(C) =
\frac{N(C)}{N}
$$

Nessa fórmula:

- $C$ representa `Sim` ou `Nao`.
- $N(C)$ representa a quantidade de registros da classe.
- $N$ representa a quantidade total de registros.
- $P(C)$ representa a probabilidade inicial da classe.

$$
P(\text{Sim}) = \frac{2099}{5000} = 0{,}4198 = 41{,}98\%
$$

$$
P(\text{Nao}) = \frac{2901}{5000} = 0{,}5802 = 58{,}02\%
$$

Sem conhecer o perfil de uma assinatura, o histórico aponta 41,98% de chance de cancelamento e 58,02% de chance de permanência.

## 3. O que é Naive Bayes

O Naive Bayes compara o perfil de uma nova assinatura com os perfis que já apareceram no histórico. Ele verifica com que frequência cada valor apareceu entre quem cancelou e entre quem permaneceu.

O termo “naive” significa “ingênuo”. No cálculo, isso representa a simplificação de que as características de um perfil são independentes umas das outras dentro de cada classe. Assim, o modelo calcula a probabilidade de cada característica separadamente e depois combina esses valores, como se não houvesse relação entre elas.

A fórmula abaixo mostra como o modelo combina essas informações para calcular a probabilidade de uma classe depois de analisar o perfil da assinatura:

$$
P(C \mid X) = \frac{P(X \mid C) \cdot P(C)}{P(X)}
$$

Nessa fórmula:

- $C$ representa `Sim` ou `Nao`.
- $X$ representa o perfil da assinatura, formado pelas oito características.
- $P(C)$ é a probabilidade inicial da classe.
- $P(X \mid C)$ é a probabilidade de observar aquele perfil dentro da classe.
- $P(X)$ é a probabilidade geral de observar aquele perfil.
- O resultado final é a probabilidade da classe depois de analisar o perfil.

No Naive Bayes, a probabilidade do perfil é obtida combinando as probabilidades das oito features.

## 4. Como o modelo aprende

O treinamento conta cada categoria dentro de `Sim` e de `Nao`. Depois, aplica a suavização de Laplace:

$$
P(X=v \mid C) =
\frac{N(X=v,C) + 1}
{N(C) + K}
$$

Nessa fórmula:

- $X=v$ representa uma feature com um valor específico, como plano igual a `Basico`.
- $C$ representa a classe `Sim` ou `Nao`.
- $N(X=v,C)$ representa a quantidade de vezes que o valor apareceu dentro da classe.
- $N(C)$ representa a quantidade total de registros da classe.
- $K$ representa a quantidade de categorias possíveis para a feature. Neste projeto, $K=3$.

O $+1$ evita probabilidade zero quando uma categoria não aparece em uma classe. Sem esse ajuste, um único zero eliminaria todo o cálculo daquela classe.

Exemplo com o plano `Basico`:

Os dois cálculos abaixo mostram como o modelo compara a presença do plano Básico entre clientes que cancelaram e clientes que permaneceram:

$$
P(\text{Basico} \mid \text{Sim}) = \frac{1203 + 1}{2099 + 3}
= \frac{1204}{2102} \approx 57{,}28\%
$$

$$
P(\text{Basico} \mid \text{Nao}) = \frac{990 + 1}{2901 + 3}
= \frac{991}{2904} \approx 34{,}13\%
$$

O plano Básico aparece mais entre os cancelamentos do que entre as permanências. O modelo usa essa diferença como uma evidência, junto com as outras características.

## Classificação e resultados

## 5. Como o sistema classifica uma assinatura

```mermaid
flowchart LR
    A[Dados da assinatura] --> B[Probabilidades aprendidas]
    B --> C[Score de Sim e Nao]
    C --> D[Normalização]
    D --> E[Classe e recomendação]
```

O sistema segue cinco passos:

1. Recebe os oito valores da assinatura.
2. Busca as probabilidades aprendidas para esses valores.
3. Calcula um score para `Sim` e outro para `Nao`.
4. Transforma os scores em percentuais que somam 100%.
5. Escolhe a classe com maior percentual e informa o nível de risco.

## 6. Por que o cálculo usa logaritmos

O modelo multiplica várias probabilidades pequenas. Para manter o cálculo estável, ele soma seus logaritmos naturais:

$$
L(C) = \ln(P(C)) + \ln(P(X \mid C))
$$

Nessa fórmula:

- $L(C)$ representa o log-score da classe.
- $C$ representa `Sim` ou `Nao`.
- $P(C)$ representa a probabilidade inicial da classe.
- $P(X \mid C)$ representa a probabilidade do perfil dentro da classe.
- $\ln$ representa o logaritmo natural.

Essa transformação preserva a ordem dos scores, então a classe com maior score continua sendo a mesma.

Depois, o sistema converte o log-score em um peso positivo usando o exponencial:

$$
W(C) = EXP\left(L(C) - L_{max}\right)
      = e^{L(C) - L_{max}}
$$

Os log-scores podem ser negativos e não representam probabilidades diretamente. O exponencial transforma esses valores em pesos positivos, que podem ser comparados e usados na normalização final.

Aqui, $L_{max}$ é o maior log-score entre as classes `Sim` e `Nao`. A subtração evita valores numéricos muito grandes e não muda a comparação entre as classes.

Em seguida, o sistema normaliza os pesos:

Os pesos ainda são apenas valores relativos e não representam percentuais. Por isso, cada peso é dividido pela soma dos dois pesos. Assim, o resultado fica entre 0% e 100%, e as probabilidades de `Sim` e `Nao` somam 100%.

$$
P(C \mid X) =
\frac{W(C)}{W(\text{Sim}) + W(\text{Nao})}
\times 100
$$

Nessa fórmula:

- $P(C \mid X)$ representa a probabilidade final da classe depois de analisar o perfil.
- $C$ representa a classe que está sendo calculada.
- $X$ representa o perfil da assinatura.
- $W(C)$ representa o peso positivo da classe, calculado com $EXP$ a partir do log-score.
- $L_{max}$ representa o maior log-score entre as classes.
- $W(\text{Sim})$ representa o peso da classe `Sim`.
- $W(\text{Nao})$ representa o peso da classe `Nao`.

No resultado final, as probabilidades de `Sim` e `Nao` somam 100%. O código SQL usa `EXP` para converter os log scores antes dessa normalização.

## 7. Sinais que aparecem mais entre cancelamentos

As proporções abaixo usam a suavização de Laplace. Elas mostram quanto cada valor aparece dentro de cada classe.

| Valor observado | Entre cancelamentos, `Sim` | Entre permanências, `Nao` |
| --- | ---: | ---: |
| Frequência de uso baixa | 51,62% | 5,54% |
| Uso baixo dos benefícios | 56,09% | 12,60% |
| Custo-benefício baixo | 52,43% | 13,53% |
| Satisfação baixa | 32,92% | 6,92% |
| Falhas de pagamento recorrentes | 9,42% | 2,51% |

Cada linha é uma evidência. O Naive Bayes combina as oito evidências antes de decidir a classe.

## 8. Limitações do modelo

- O Naive Bayes considera que cada feature é independente das outras dentro de uma classe. Na prática, algumas podem estar relacionadas. Por exemplo, quem usa pouco a plataforma também pode usar pouco os benefícios. O modelo não identifica essa relação e pode contar sinais parecidos mais de uma vez.
- As features foram transformadas em categorias. Isso facilita o cálculo, mas faz o modelo perder detalhes. Por exemplo, usos diferentes podem ser classificados apenas como `Baixa`.
- Quando aparece uma categoria que não existia no treinamento, o modelo não rejeita o perfil nem cria uma nova categoria. Ele considera que esse valor teve zero ocorrências e aplica a suavização de Laplace, adicionando 1 à contagem. Assim, o valor recebe uma probabilidade pequena, mas diferente de zero.
- O modelo percebe quais características aparecem mais entre os cancelamentos, mas isso não significa que elas sejam a causa. Por exemplo, a baixa satisfação pode estar ligada ao cancelamento, mas o motivo real também pode ser o preço ou uma falha de pagamento.
