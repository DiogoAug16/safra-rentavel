# Naive Bayes para Cancelamento de Assinaturas

Projeto acadêmico que implementa um classificador **Naive Bayes categórico em PostgreSQL** para prever se uma assinatura será cancelada.

O Python é utilizado apenas para:

- conectar ao PostgreSQL;
- criar os objetos SQL do projeto;
- carregar o conjunto de treinamento em CSV;
- executar a função de classificação.

O cálculo do Naive Bayes é realizado diretamente no banco de dados.

---

## Objetivo

Classificar uma assinatura em uma das seguintes classes:

- `Sim` — assinatura cancelada;
- `Nao` — assinatura não cancelada.

O modelo utiliza as seguintes features categóricas:

- plano de assinatura;
- frequência de uso;
- tempo desde o último acesso;
- uso de benefícios do plano;
- variação de preço;
- percepção de custo-benefício;
- nível de satisfação;
- falhas de pagamento.

---

## Funcionamento

O fluxo geral do projeto é:

```mermaid
flowchart TD
    A[CSV de treinamento] --> B[main.py setup]
    B --> C[Schema e views SQL]
    C --> D[(PostgreSQL - banco de assinaturas)]
    B --> E[assinaturas_treinamento]
    E --> D
    D --> F[main.py]
    F --> G[classificar_cancelamento]
    G --> H[Probabilidades e classe prevista]
```

O banco calcula:

1. probabilidades a priori `P(classe)`;
2. verossimilhanças `P(feature = valor | classe)`;
3. suavização de Laplace;
4. scores utilizando log-probabilidades;
5. normalização dos scores entre `0%` e `100%`;
6. classe prevista e recomendação.

---

## Estrutura do projeto

```text
.
├── data/
│   └── plataformas_digitais.csv
│
├── sql/
│   ├── tables/
│   │   └── assinaturas_treinamento.sql
│   │
│   ├── views/
│   │   ├── dominios_features.sql
│   │   ├── valores_features.sql
│   │   ├── probabilidades_priori.sql
│   │   └── verossimilhancas.sql
│   │
│   └── functions/
│       └── classificar_cancelamento.sql
│
├── docs/
│   ├── training-data-model.md
│   ├── naive-bayes-training.md
│   └── naive-bayes-inference.md
│
├── src/
│   ├── __init__.py
│   ├── config.py
│   ├── database.py
│   ├── csv_loader.py
│   ├── sql_runner.py
│   └── classifier.py
│
├── main.py
├── requirements.txt
└── README.md
```

---

## Arquitetura SQL

```mermaid
flowchart TD
    A[(assinaturas_treinamento)]

    A --> B[feature_values]
    A --> C[class_priors]

    D[feature_domains] --> E[likelihoods]
    B --> E

    C --> F[classificar_cancelamento]
    E --> F

    F --> G[Probabilidades normalizadas]
    G --> H[Classe prevista]
    H --> I[Recomendação]
```

### Responsabilidade dos objetos

| Objeto | Responsabilidade |
|---|---|
| `assinaturas_treinamento` | armazena os registros de treinamento |
| `feature_domains` | define as categorias possíveis de cada feature |
| `feature_values` | transforma os registros em pares feature/valor |
| `class_priors` | calcula `P(classe)` |
| `likelihoods` | calcula `P(feature = valor | classe)` com Laplace |
| `classificar_cancelamento()` | calcula os scores, normaliza e retorna a classificação |

---

## Pré-requisitos

É necessário possuir:

- Python 3;
- PostgreSQL;
- banco PostgreSQL chamado `assinatura`;
- `pip`.

O banco `assinatura` deve existir antes da execução do projeto.

---

## Instalação

Clone ou acesse o diretório do projeto e crie um ambiente virtual:

```bash
python -m venv .venv
```

### Linux/macOS

```bash
source .venv/bin/activate
```

### Windows PowerShell

```powershell
.\.venv\Scripts\Activate.ps1
```

Instale as dependências:

```bash
pip install -r requirements.txt
```

O `requirements.txt` utiliza:

```text
psycopg[binary]
python-dotenv
```

---

## Configuração do PostgreSQL

Por padrão, o projeto utiliza:

```text
host: localhost
port: 5432
database: assinatura
user: postgres
password: postgres
```

O banco padrão é `assinatura`. Esses valores podem ser alterados através de
variáveis de ambiente.

### Linux/macOS

```bash
export DB_HOST=localhost
export DB_PORT=5432
export DB_NAME=assinatura
export DB_USER=postgres
export DB_PASSWORD=sua_senha
```

### Windows PowerShell

```powershell
$env:DB_HOST="localhost"
$env:DB_PORT="5432"
$env:DB_NAME="assinatura"
$env:DB_USER="postgres"
$env:DB_PASSWORD="sua_senha"
```

A configuração é lida em:

```text
src/config.py
```

---

## Dataset

O arquivo de treinamento é `data/plataformas_digitais.csv`, com 5.000 registros e estas colunas, nesta ordem:

`plano_assinatura`, `frequencia_uso`, `tempo_desde_ultimo_acesso`, `uso_beneficios_plano`, `variacao_preco`, `percepcao_custo_beneficio`, `nivel_satisfacao`, `falhas_pagamento` e `cancelou_assinatura`.

Cada feature possui três categorias; `cancelou_assinatura` aceita somente `Sim` e `Nao`. Não há identificador externo. `Sim` indica que a assinatura cancelou e `Nao` indica permanência.

---

## Como executar

Com o PostgreSQL em execução e o ambiente Python configurado:

```bash
scripts/setup.sh
scripts/run.sh
```

Os comandos Python são:

```bash
python main.py setup
python main.py run
python main.py log-odds
python main.py likelihoods
python main.py clean
```

Sem argumento, `python main.py` equivale a `python main.py run`.

Os scripts `scripts/setup.sh`, `scripts/run.sh`, `scripts/log_odds.sh`,
`scripts/likelihoods.sh` e `scripts/clean.sh` são atalhos para esses comandos.
`setup` cria ou atualiza o schema e carrega o CSV. Execute-o antes da primeira
classificação e sempre que os dados de treinamento mudarem.

O fluxo executado é:

```mermaid
sequenceDiagram
    participant D as main.py setup
    participant S as SQL Runner
    participant P as PostgreSQL
    participant C as CSV Loader
    participant M as main.py run
    participant N as Classifier

    D->>S: executar definições SQL
    S->>P: criar tabela, views e função

    D->>C: carregar CSV
    C->>P: inserir dados de treinamento

    M->>N: classificar assinatura
    N->>P: SELECT classificar_cancelamento(...)
    P-->>N: probabilidades e decisão
    N-->>M: resultado
```

A saída será semelhante a:

```text
$ scripts/setup.sh
Configurando estrutura SQL...
Executado: assinaturas_treinamento.sql
Executado: dominios_features.sql
Executado: valores_features.sql
Executado: probabilidades_priori.sql
Executado: verossimilhancas.sql
Executado: classificar_cancelamento.sql

Carregando dados de treinamento...
5000 registros importados com sucesso.

$ scripts/run.sh
Classificando risco de cancelamento...

Resultado
--------------------------------------------------
Cancelamento: 100.00%
Permanência: 0.00%
Classe: Sim
Recomendação: Risco muito alto de cancelamento.
```

Os percentuais dependem dos dados armazenados na tabela de treinamento.

O relatório de probabilidades é derivado do CSV. Gere-o após alterar os dados e
confira-o sem escrever arquivos antes de entregar:

```bash
python scripts/generate_probability_report.py
python scripts/generate_probability_report.py --check
```

Para consultar o log-odds de cada categoria das features:

```bash
scripts/log_odds.sh
```

Para consultar a tabela de verossimilhanças calculadas com Laplace:

```bash
scripts/likelihoods.sh
```

O resultado compara `P(valor | Sim)` com `P(valor | Nao)`. Valores positivos
favorecem `Sim`, valores negativos favorecem `Nao`, e quanto maior o valor
absoluto, maior a diferença entre as classes.

---

## Limpeza do banco

```bash
scripts/clean.sh
```

O script remove somente os objetos do projeto na ordem de dependências: a função `classificar_cancelamento()`, as views atuais e legadas `nb_*` do Naive Bayes e, por último, a tabela `assinaturas_treinamento` com todos os dados de treinamento. Não usa `CASCADE`; dependências externas continuam bloqueando a operação. Execute `scripts/setup.sh` depois para recriar e recarregar o banco.

---

## Classificação manual pelo PostgreSQL

Também é possível chamar o classificador diretamente por SQL:

```sql
SELECT *
FROM classificar_cancelamento(
    'Basico',
    'Baixa',
    'Longo',
    'Baixo',
    'Aumentou',
    'Baixa',
    'Baixo',
    'Recorrente'
);
```

A função retorna:

```text
probabilidade_sim
probabilidade_nao
classe_prevista
recomendacao
```

---

## Fluxo do Naive Bayes

```mermaid
flowchart LR
    A[P classe] --> D[Log score]
    B[P feature valor dado classe] --> D
    C[Suavização de Laplace] --> B

    D --> E[Estabilização numérica]
    E --> F[EXP]
    F --> G[Normalização]
    G --> H[P Sim]
    G --> I[P Nao]

    H --> J[Classe com maior probabilidade]
    I --> J
```

A classificação utiliza:

```text
log_score(C) =
    ln(P(C))
    +
    Σ ln(P(Xi | C))
```

Depois, os scores são convertidos novamente para escala linear e normalizados para que:

```text
P(Sim) + P(Nao) = 100%
```

---

## Documentação técnica

A documentação detalhada dos objetos SQL está dividida por responsabilidade:

```text
docs/training-data-model.md
docs/naive-bayes-training.md
docs/naive-bayes-inference.md
```

Cada documento explica os objetos SQL e os cálculos realizados naquela etapa.

---

## Observações

- O algoritmo Naive Bayes é implementado em SQL.
- O Python não calcula as probabilidades do modelo.
- O Python atua como camada de execução e integração com o PostgreSQL.
- As features utilizadas são exclusivamente categóricas.
- A suavização de Laplace evita probabilidades condicionais iguais a zero.
- Log-probabilidades são utilizadas para reduzir o risco de underflow numérico.
- As probabilidades finais são normalizadas para valores percentuais.
