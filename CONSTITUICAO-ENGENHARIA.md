<!--
Sync Impact Report
- Mudança de versão: (documento novo) → 1.0.0
- Motivo do bump: MAJOR. Adoção inicial da constituição de engenharia organizacional.
- Origem: regras já em vigor no Archetype Backend NestJS da Suprema
  (rian-suprema/simplified-traditional-archetype), convertidas de prosa em
  princípios declarativos e verificáveis.
- Princípios definidos (9):
  I.    Nasce do Archetype (Golden Path)
  II.   Identidade Delegada à Plataforma SayPlus
  III.  Isolamento Multi-Tenant em Três Camadas
  IV.   Migrations são Código de Produção
  V.    Contratos Invariantes de Erro, Configuração e Saúde
  VI.   Fronteiras de Módulo e de Serviço
  VII.  Observabilidade Fail-Open
  VIII. Cadeia de Suprimentos e Empacotamento
  IX.   Qualidade é Gate, não Recomendação
- Seções: Restrições Técnicas do Golden Path; Decisões que Exigem ADR;
  Fluxo de Desenvolvimento e Portões de Qualidade; Governance.
- Nota de idioma: o corpo é redigido em pt-BR; os títulos estruturais
  `## Core Principles` e `## Governance` permanecem no texto canônico do
  template para que as ferramentas do Spec Kit continuem a localizá-los.
- TODOs pendentes:
  - TODO(VARIANTE_COMPLETA): confirmar o repositório oficial da variante
    completa do archetype (petstore-api). Bloqueante para qualquer serviço
    que exija cache, mensageria ou HTTP externo.
-->

# Constituição de Engenharia da Suprema

Este documento define **como** a Suprema constrói software de backend. Vale para todo
serviço do grupo, de qualquer domínio.

Ele **não** trata de regra de negócio. Restrições de domínio (growth, KYC, carteira,
provider) vivem na constituição do serviço, que herda esta e a complementa.

**Teste para saber onde uma regra pertence:** se ela valeria igual em outro serviço da
Suprema, é desta constituição. Se não valeria, é da constituição do serviço.

## Core Principles

### I. Nasce do Archetype (Golden Path)

Todo serviço backend MUST ser construído a partir do **Archetype Backend NestJS da
Suprema**. A stack é fixa: **Node 22** (`>=22 <23`), **NestJS 11**, **TypeScript em modo
`strict`**, **TypeORM sobre Aurora PostgreSQL**.

É **PROIBIDO** montar stack fora do golden path. Trocar runtime, framework, ORM ou banco
não é decisão de feature nem de preferência de time.

**Escolha da variante** MUST ser decidida antes da primeira linha de código, pelo critério:

- o domínio precisa de **cache distribuído, mensageria ou cliente HTTP externo**?
  - **Não** → variante **simples**
  - **Sim** → variante **completa**

Errar essa escolha não é ajuste de configuração: a variante simples carrega um gate de
arquitetura que **derruba o build** ao encontrar import de cache, mensageria ou HTTP
externo. A correção depois é retrabalho.

O módulo de exemplo do archetype (marcado `[EXEMPLO]`) MUST ser removido antes do primeiro
merge em `main`.

**Racional:** o archetype já carrega CI, segurança, testes de arquitetura, saúde e
observabilidade homologados. Cada desvio transfere esse custo para o time do serviço e
quebra a manutenção compartilhada entre os serviços do grupo.

### II. Identidade Delegada à Plataforma SayPlus

Nenhum serviço **emite** token, **armazena** senha ou **chama** a SayPlus para validar
credencial. A identidade nasce na plataforma; o serviço apenas **consome e obedece**.

Todo serviço MUST:

- validar o JWT com a **chave pública** da SayPlus, offline, sem I/O;
- fixar o algoritmo em **RS256** na strategy. Aceitar o algoritmo declarado no header do
  token é vulnerabilidade, não flexibilidade;
- conferir **issuer**, **audience** e **expiração**;
- declarar em **cada rota** o code de permissão exigido, na convenção
  `modulo.recurso.acao`, com os verbos `read`, `create`, `edit`, `delete`. É **`edit`,
  nunca `update`**;
- manter os codes de permissão em **um único arquivo** como literal, referenciados por
  constante nas rotas. Todo code MUST estar registrado no catálogo SayPlus antes de
  aparecer em token emitido.

Rota sem declaração de permissão e sem declaração explícita de rota pública **nasce negada
e NÃO passa no build**. A única exceção prevista para rota pública são as probes de saúde.

Chave pública ausente no ambiente MUST fazer o serviço **subir** com probes saudáveis e
toda rota protegida respondendo 401, registrando o problema no log. Deploy mal configurado
vira alarme, nunca indisponibilidade e nunca brecha.

**Racional:** autorização por omissão é a origem mais comum de exposição de dados. Falhar
no build move a descoberta do incidente para antes do merge, e vale igualmente para código
escrito por pessoa ou gerado por IA.

### III. Isolamento Multi-Tenant em Três Camadas

Vazamento entre tenants é falha crítica. As três camadas MUST existir **simultaneamente**.
Nenhuma substitui as outras:

1. **Modelo.** Toda tabela de domínio carrega `tenant_id`, e toda unicidade de negócio é
   **composta** com ele.
2. **Aplicação.** Todo acesso é filtrado pelo tenant obtido **exclusivamente do claim do
   token**. É **PROIBIDO** aceitar tenant vindo de body, header, query ou path. Para um
   tenant, registro de outro tenant simplesmente não existe, em leitura, escrita e remoção.
3. **Banco.** **Row-Level Security com `FORCE`** no PostgreSQL, com policy por contexto de
   sessão. Contexto ausente MUST resultar em **zero linhas**, nunca em todas as linhas.

A **separação de privilégios** é obrigatória e é o que faz a camada 3 existir de fato:

- migrations rodam com role **owner não-superusuário**, dono do schema, com DDL;
- a aplicação conecta com role de **runtime não-owner**, apenas com DML;
- as credenciais dos dois roles vivem em **secrets distintos**.

**Racional:** as camadas 1 e 2 são código e falham como código falha, por engano. A camada
3 é a única que continua valendo quando o engano acontece.

### IV. Migrations são Código de Produção

Toda mudança de schema MUST ser uma migration com **SQL explícito**, versionada e revisável
em PR. Sincronização automática de schema é **PROIBIDA** em qualquer ambiente.

Convenções obrigatórias:

- chave primária **`SERIAL`** por padrão;
- **coluna anulável declara o tipo explicitamente**. Tipo de coluna nunca depende de
  inferência;
- migrations executam como **passo anterior à subida da aplicação**, com o role owner,
  nunca pelo processo da aplicação.

**Racional:** schema é o único artefato do sistema que não se recupera por rollback de
deploy. Revisar o SQL que vai rodar em produção é mais barato que restaurar backup.

### V. Contratos Invariantes de Erro, Configuração e Saúde

**Erro.** Toda resposta de erro MUST sair no formato `{ code, message }`, garantido por
filter global. É **PROIBIDO** formato de erro por módulo, por controller ou por rota. O
consumidor trata um contrato, não uma coleção.

**Configuração.** Toda configuração nova MUST ter **namespace tipado** e **entrada no
schema de validação de boot**. **Variável sem validação não existe**: o serviço não sobe com
configuração ausente ou inválida, em vez de degradar em runtime. Validação de ambiente vive
em um único lugar.

**Saúde.** Todo serviço MUST expor duas probes, **fora do prefixo da API**:

- **liveness**: o processo responde. **Sem nenhuma dependência externa.** Dependência aqui
  derruba o pod em loop de restart por culpa alheia;
- **readiness**: pode receber tráfego. Verifica as dependências estruturais do serviço.

**Racional:** invariantes de borda são o que permite à infraestrutura, ao orquestrador e aos
outros serviços tratarem qualquer serviço da Suprema de forma uniforme, sem conhecer sua
implementação.

### VI. Fronteiras de Módulo e de Serviço

**Entre módulos do mesmo serviço:** colaboração acontece **apenas via service exportado**. É
**PROIBIDO** importar repositório ou entidade de outro módulo.

**Entre serviços:** não existe guard interno nem rota de serviço adormecida. Toda rota exige
JWT de usuário ou é explicitamente pública. Necessidade real de chamada serviço-a-serviço
MUST passar por **avaliação de arquitetura registrada em ADR**, caso a caso, e nunca é
default.

**Acesso a dado de outro serviço:** é **PROIBIDO** ler o banco, mapear as entidades ou
reproduzir o schema de outro serviço, direta ou indiretamente. A integração acontece por
contrato declarado: evento ou API.

**Consumo de evento** MUST ser idempotente, com chave de deduplicação persistida, **DLQ**
configurada e **backoff** em retentativa. Mensagem que esgota as tentativas vai para DLQ,
nunca é descartada em silêncio.

**Upload de binário** está fora do escopo do serviço. Quando o domínio exigir, usa-se
armazenamento de objeto com URL pré-assinada: o arquivo nunca atravessa o pod.

**Racional:** acoplamento por banco é irreversível na prática e transforma qualquer evolução
de um serviço em incidente de outro. Contrato declarado é o único acoplamento que se pode
versionar e testar.

### VII. Observabilidade Fail-Open

Todo serviço MUST emitir **traces e métricas via OTLP** e **logs JSON estruturados** com o
identificador de trace injetado, escritos em `stdout`. Arquivo de log e agente dentro do
processo são **PROIBIDOS**.

A telemetria MUST ser governada por **interruptor de ambiente**, com a **mesma imagem** nos
três estados: desligada por padrão, ligada localmente por opt-in do desenvolvedor, ligada no
cluster por configuração do SRE.

**Observabilidade NUNCA derruba a aplicação.** Coletor indisponível, lento ou inexistente
MUST resultar em serviço funcionando normalmente. Esse comportamento MUST ser provado por
teste automatizado, não presumido.

Probe de saúde **não** é sinal de negócio e MUST ficar fora da instrumentação automática.

**Racional:** telemetria que derruba produção é pior que ausência de telemetria, porque
transforma a ferramenta de diagnóstico em causa de incidente.

### VIII. Cadeia de Suprimentos e Empacotamento

O ecossistema de pacotes é o principal vetor de ataque contra o serviço. A defesa é em
camadas e todas são obrigatórias:

- **lockfile versionado** e instalação **sempre pelo lockfile exato**, em máquina de
  desenvolvimento, imagem e CI. Divergência entre lockfile e manifesto MUST falhar o build;
- **scripts de pós-instalação de terceiros bloqueados** em toda instalação;
- **transitiva vulnerável sem correção no pai** MUST ser tratada por override escopado, não
  por convivência;
- **auditoria de dependências** como gate: severidade alta ou crítica reprova. Severidade
  moderada só passa com registro escrito;
- **imagem final sem toolchain de build**, executando como **usuário não-root**, com base
  pinada. O runtime é o processo da aplicação e nada mais;
- **scan da imagem** como gate em severidade alta e crítica. Exceção **somente** por
  registro formal contendo CVE, justificativa, dono, data de expiração e aval do
  responsável por segurança;
- **manifestos de deploy** com contexto de segurança endurecido: não-root, sistema de
  arquivos raiz somente-leitura, capabilities removidas;
- **política de rede** com negação padrão de entrada, liberando apenas o caminho do gateway.

O que **não** é opção diante de um gate vermelho: reduzir a severidade do gate, remover o
passo, ou mergear sem registro.

**Racional:** cada camada cobre o que a anterior não vê. A auditoria cobre o lockfile da
aplicação; o scan da imagem cobre o sistema base e o que vem embutido nele.

### IX. Qualidade é Gate, não Recomendação

Regra de arquitetura que não executa é comentário. Toda regra verificável MUST rodar como
**teste executável** e **barrar o PR**.

Limites vinculantes, calibrados para nascerem verdes e barrarem a regressão:

| Métrica | Limite |
|---|---|
| Complexidade cognitiva | 15 |
| Complexidade ciclomática | 15 |
| Linhas por função | 80 |
| Linhas por arquivo | 400 |
| Profundidade de aninhamento | 4 |
| Parâmetros por função | 5 |
| Densidade de duplicação | 3% |
| Ciclos de dependência | zero |

Regras de arquitetura obrigatórias como teste:

- o esqueleto do serviço **não** depende do módulo de exemplo;
- controller **não** acessa a camada de persistência;
- service **não** depende de controller;
- entidades e DTOs organizados pelo nome, nas pastas correspondentes;
- toda rota declara permissão ou é explicitamente pública;
- capacidades ausentes da variante escolhida **não** são importadas.

A mesma régua MUST valer em **três pontos de contato**: no editor enquanto se escreve, no
pre-commit, e no CI. Não são três ferramentas, é a mesma configuração em três momentos.

**Racional:** limite verificado por ferramenta é limite. Limite verificado por boa vontade em
code review é ruído sob prazo.

## Restrições Técnicas do Golden Path

**Runtime e stack:** Node `>=22 <23`, NestJS 11, TypeScript `strict`, TypeORM sobre Aurora
PostgreSQL.

**API:** REST com contrato **code-first**, gerado do código, publicado pelo próprio serviço.
Validação de entrada por DTO com whitelist estrita: propriedade fora do DTO é rejeitada.

**Identidade:** JWT RS256 da SayPlus, validado por chave pública, com issuer, audience e
expiração conferidos. Permissões em `modulo.recurso.acao` com verbos
`read | create | edit | delete`.

**Banco:** `tenant_id` em toda tabela de domínio, unicidades compostas, RLS com `FORCE`,
role owner não-superusuário para DDL, role de runtime sem DDL, secrets distintos.

**Entrega:** imagem multi-stage não-root sem toolchain, chart com contexto de segurança
endurecido, migrations como passo anterior à subida da aplicação, política de rede com
negação padrão de entrada.

**Declaração de infraestrutura:** todo serviço MUST entregar sua própria declaração do que
exige para operar, com os outputs esperados. O serviço **declara**; o SRE **aprova em PR e
realiza** via IaC. Nenhum serviço provisiona infraestrutura por conta própria.

**Registro no catálogo:** todo serviço MUST estar registrado no catálogo da plataforma, com
**owner sendo um grupo real**, nunca uma pessoa.

**Variante completa:** TODO(VARIANTE_COMPLETA) confirmar o repositório oficial. Bloqueante
para qualquer serviço que exija cache, mensageria ou HTTP externo.

## Decisões que Exigem ADR

ADR registrado **antes** do código existir, com contexto, alternativas consideradas, decisão
e consequências:

1. Divergência de qualquer ponto do golden path.
2. Escolha da variante do archetype, quando não for óbvia pelo critério do Princípio I.
3. Chamada serviço-a-serviço direta.
4. Introdução de cache, mensageria ou integração HTTP externa.
5. Nova superfície de integração entre serviços.
6. Adoção de componente de terceiro que não seja biblioteca do golden path.
7. Alteração de qualquer limite do Princípio IX.

**Não existe exceção informal. O que não está em ADR está proibido.**

## Fluxo de Desenvolvimento e Portões de Qualidade

1. **Decisão antes da especificação.** Ideia MUST ter problema, metas, não-metas e métricas
   registrados, e um veredicto explícito, antes de virar especificação.
2. **Especificação antes do plano.** A feature nasce em documento de especificação que trata
   do **que** e do **por quê**, sem tecnologia.
3. **Constitution Check antes das tasks.** Todo plano de feature MUST declarar, princípio por
   princípio, conformidade ou o ADR que a justifica. **Plano com violação não declarada não
   vira tasks.**
4. **Implementação em ondas.** Feature grande MUST ser implementada por faixas de tarefas,
   não de uma vez.
5. **Convergência antes do PR.** O código construído MUST ser comparado contra especificação,
   plano e tasks, e o que faltar volta como tarefa. Repete-se até convergir.
6. **PR barrado por gate automatizado**, sem exceção manual:
   - testes de arquitetura e de negócio verdes;
   - limites do Princípio IX respeitados;
   - toda rota com permissão declarada ou explicitamente pública;
   - migrations em SQL explícito, revisadas no diff;
   - configuração nova com namespace tipado e validação de boot;
   - auditoria de dependências e scan de imagem sem achado alto ou crítico não registrado;
   - `strict` do TypeScript sem supressão nova (`any`, `@ts-ignore`, `eslint-disable`) sem
     justificativa no PR.
7. **Revisão humana verifica o que a ferramenta não vê:** fronteira entre serviços,
   isolamento de tenant, contrato de erro e adequação da especificação ao problema.
8. **Divergência descoberta durante a implementação para o trabalho e abre ADR.** Não se
   resolve por commit.

**Persistência dos artefatos (modelo spec-anchored):** especificação, plano e tasks
**sobrevivem** à implementação e são a fonte de verdade para a mudança seguinte. Quando o
requisito muda, o artefato correspondente MUST ser atualizado **antes** do código, e a
alteração entra no mesmo PR da mudança. Artefato desatualizado é dívida, tratada como
dívida. É **PROIBIDO** tratar a especificação como andaime descartável.

## Governance

Esta constituição **supersede** qualquer outra prática, convenção informal ou preferência
individual em serviços de backend da Suprema. Onde houver conflito entre esta constituição e
um documento de feature, esta constituição prevalece e o documento de feature MUST ser
corrigido.

**Hierarquia de documentos:**

1. Esta constituição, em matéria de engenharia.
2. A constituição do serviço, em matéria de domínio, risco e regulatório.
3. ADR do serviço.
4. Documento de feature.

Constituição de serviço que contradiga esta em matéria de engenharia é **inválida** naquele
ponto.

**Emenda:** toda alteração exige PR dedicado com justificativa explícita, o impacto sobre os
artefatos dependentes e o novo número de versão. Emenda não entra por edição direta em
`main`. Alteração dos Princípios II, III e VIII exige aval do responsável por segurança.

**Versionamento (semântico):**

- **MAJOR** — remoção ou redefinição incompatível de princípio ou regra de governança;
- **MINOR** — novo princípio ou seção, ou ampliação material de exigência;
- **PATCH** — esclarecimento, redação, correção sem mudança semântica.

**Conformidade:** todo plano de feature passa por Constitution Check antes de gerar tasks;
todo PR verifica conformidade nos gates do fluxo acima. Complexidade MUST ser justificada.
"Foi mais rápido assim" não é justificativa.

**Adoção por serviço existente:** serviço anterior a esta constituição MUST registrar, em
até um ciclo de planejamento, o inventário das divergências e o plano de convergência.
Divergência conhecida e registrada é dívida gerenciada. Divergência não registrada é
violação.

**Version**: 1.0.0 | **Ratified**: 2026-08-27 | **Last Amended**: 2026-08-27
