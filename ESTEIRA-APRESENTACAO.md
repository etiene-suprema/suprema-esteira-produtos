# Esteira de Criação Suprema

Documento de apresentação para arquitetura. Explica o processo completo pelo qual produto e
serviço nascem na Suprema, o contexto de cada trilha e o que muda com a decisão de rodar
**local-first**.

> **Status**: versão para apresentação, já com o redesenho da Trilha 1 do anexo de arquitetura
> (18/09). As decisões estão consolidadas na última seção; cinco decisões de processo ficam
> marcadas como pendentes de assinatura, e dois pontos a ratificar com engenharia.

---

## 1 · O que é a esteira, em uma frase

Um caminho único, em cinco trilhas, que leva uma ideia de produto até um serviço em produção,
com portões de qualidade onde importam e artefatos que sobrevivem ao código. O veículo é o
**GitHub Spec Kit** pinado na tag `v1.0.1`, customizado só por **extensão e preset**, nunca por
fork, sempre com versão pinada.

Ela existe para resolver três problemas: ideia que vira código sem passar por decisão, produto
que só fica concreto na mão de quem implementa, e serviço que nasce diferente por time. A
esteira mata a ideia ruim cedo, força o produto a ficar concreto antes do código, e faz todo
serviço nascer do mesmo golden path.

---

## 2 · Cinco princípios que atravessam tudo

1. **Spec-anchored.** Os artefatos (PRD, spec, desenho, plano, tasks) são fonte de verdade
   versionada, não andaime. Requisito muda, o artefato muda antes do código. Artefato
   desatualizado é dívida, tratada como dívida.
2. **Portão sem dono não é portão.** Todo portão tem quem executa e quem assina, e quem propõe
   ou escreve nunca assina sozinho.
3. **Na dúvida, pare e pergunte.** Avançar fora de ordem custa mais que esperar.
4. **Não inventar.** Informação que falta vira marcação de indefinição ou pergunta, nunca
   suposição silenciosa.
5. **Customização por extensão ou preset, com tag pinada.** Nunca editando o core do Spec Kit,
   nunca da branch principal (o upstream libera cerca de 285 commits por mês, sem promessa de
   estabilidade de API).

---

## 3 · Visão geral

```
TRILHA 0 · Descoberta      por ideia            produto + operações      pode matar a ideia
TRILHA 1 · Definição       por iniciativa       produto + operações      termina no aceite
     ─────────────── fronteira: produto entrega para tecnologia ───────────────
TRILHA 2 · Nascimento      uma vez por serviço  tecnologia (local, sem SRE)
TRILHA 3 · Construção      por feature          tecnologia
TRILHA 4 · Entrega e Sustentação  contínuo      time do serviço + SRE
```

A **fronteira** entre produto e tecnologia é o portão de aceite da spec (fim da Trilha 1).
Antes dela, nenhuma decisão de stack. Depois dela, nenhuma decisão de produto sem voltar o
artefato.

---

## 4 · Trilha 0 · Descoberta

**Pergunta que responde:** vale construir isso? A maioria das ideias deve morrer aqui, e matar
ideia com motivo escrito é resultado, não fracasso. Tudo em `.specify/assessments/<slug>/`.

| # | Passo | Comando | Artefato | Para que serve |
|---|---|---|---|---|
| 1 | Captar | `/speckit-assess-intake` | `intake.md` | registra a origem da demanda: quem pediu, o gatilho, por que agora |
| 2 | Pesquisar | `/speckit-assess-research` | `research.md` | evidência, mercado, o que já existe. Chega com dado, senão o agente preenche com plausível |
| 3 | Definir o problema | `/speckit-assess-define` | `problem.md` | o problema, quem sofre, custo de não fazer, metas, **não-metas** e métricas |
| 4 | Modelar opções | `/speckit-assess-shape` | `concept.md` | 2 a 3 caminhos com trade-offs, escopo e apetite, e uma recomendação |
| 5 | **Portão: decidir** | `/speckit-assess-decide` | `decision.md` | veredicto explícito |

O portão pontua sempre os **mesmos quatro critérios**: impacto, esforço, risco regulatório,
reversibilidade. Veredicto `seguir`, `esclarecer` ou `matar`. Só `seguir` avança.

Exceção autorizada: quando o `shape` não fecha sem uma resposta que só o código dá, roda-se um
**spike** (pergunta escrita, prazo, saída registrada, código descartável). É o único caso em que
se toca tecnologia antes da Trilha 2.

---

## 5 · Trilha 1 · Definição do produto

Transforma a decisão em um PRD completo e uma spec de uso validada. É onde o produto fica
concreto tela por tela, antes de qualquer linha de código.

Nenhuma trilha foi criada ou reordenada. A Trilha 1 passa a ter **nove passos**: dois novos
(perfis e atores; histórias) e quatro ampliados (desenho, validar, compilar, portão).

| # | Passo | Comando | Artefato | Para que serve |
|---|---|---|---|---|
| 1 | **Constituição do domínio** | `/speckit-constitution` | `constitution.md` | as restrições de domínio, risco e regulatório; vem **antes** de tudo |
| 2 | **Perfis e atores** · novo | `/speckit-produto-perfis` | `perfis.md` | quem usa e o que cada um pode ver e fazer, incluindo operação, suporte e back-office |
| 3 | **Histórias** · novo | `/speckit-produto-historias` | `historias.md` | história com formato único, critério de tamanho e régua de prioridade (o que é P1, quem decide) |
| 4 | Especificar | `/speckit-specify` | `spec.md` | converte histórias em requisitos numerados, aceite, sucesso mensurável, bordas |
| 5 | Clarificar | `/speckit-clarify` | `spec.md` atualizado | resolve as indefinições antes de desenhar |
| 6 | **Desenho da superfície** · ampliado | `/speckit-produto-desenho` | `desenho.md` | telas, ações, estados; **+ matriz de permissões (formato SayPlus)** e **sinais de comportamento** |
| 7 | **Validar** · ampliado | `/speckit-produto-mockup` (tela) · conferência de contrato (jogo) | `mockup/index.html` ou nota | prova o entendimento e gera ideia nova |
| 8 | **Compilar a entrega** · ampliado | `/speckit-produto-compilar` | `entregaveis/`, `PRD.md` | itens autossuficientes **com história e requisito de origem** + PRD consolidado, gerados |
| 9 | **Portão: checklist e aceite** · ampliado | `/speckit-checklist` | `checklists/` | fronteira; **quatro assinaturas** (produto, operações, tech lead, segurança) |

Por que a constituição vem antes: ela carrega a régua de domínio. Especificar sobre régua que
não existe produz requisito que nasce ilegal, e a violação só apareceria semanas depois, com o
PRD aprovado.

Os passos 2 e 3 são os **dois novos**, e são o ponto mais estreito da esteira: história sem ator
é história sem dono, e história sem padrão contamina tudo o que vem depois. Perfis e atores sai
do desenho para nascer antes; histórias ganha formato, tamanho e régua de prioridade.

O passo 6 é **proposta primeiro, não entrevista**: o agente lê os artefatos e escreve um desenho
completo, marcando `[SUPOSTO]` e `[INDEFINIDO]`. Ele passa a entregar também a **matriz de
permissões no formato da plataforma** (pronta para o catálogo SayPlus, fechando a lacuna de
segurança na fronteira) e os **sinais de comportamento do produto** (notificação, dependência,
volume, horário), que são a evidência escrita para a escolha da variante do archetype na Trilha
2. A validação (passo 7) prova o entendimento; para jogo, o equivalente é a **conferência do
contrato de evento**. O mockup é **descartável**: nada dele entra no código.

O passo 8 compila tudo em **itens prontos para o backlog** mais o **PRD consolidado**, agora com
a **história e o requisito de origem** em cada item, para a rastreabilidade não se perder. Os
dois são gerados da spec e do desenho, nunca editados à mão. O passo 9 fecha a fronteira com
**quatro assinaturas**.

---

## 6 · Trilha 2 · Nascimento do serviço (local-first)

Aqui o produto aprovado vira um serviço de pé na máquina do desenvolvedor. **A Trilha 2 é 100%
local, sem SRE.** O archetype já foi feito para isso, sobe inteiro com `docker compose` (Postgres,
mais Redis e LocalStack na variante completa) e roda os mesmos gates do CI localmente. O
provisionamento com SRE fica na Trilha 4 (go-live).

| # | Passo | Artefato / prova | Contexto |
|---|---|---|---|
| 1 | Subir a SayPlus localmente | host de pé na máquina | pré-requisito: o módulo precisa de um lugar onde encaixar |
| 2 | Escolher o archetype | ADR de variante | pela matriz da seção 9, decidido com a spec na mão |
| 3 | Gerar o módulo e adaptar lendo os `.md` do archetype | repo `<serviço>-api` | a documentação do archetype orienta a criação; não se copia sem entender |
| 4 | Rodar o módulo local | `docker compose up` + migrations + **gates verdes** | verde aqui é verde no CI |
| 5 | Consolidar a constituição do serviço | `constitution.md` (mãe + domínio) | junta a Constituição de Engenharia com a de domínio da Trilha 1 |
| 6 | Remover o módulo de exemplo | ausência de `users`/`petstore` | o `[EXEMPLO]` sai antes do primeiro merge |
| 7 | Conectar o módulo à SayPlus localmente | integração funcionando local | fim da Trilha 2 |
| — | Infra como contrato | referência | `deploy/` e `catalog-info.yaml` já vêm no archetype; **provisionar é a Trilha 4** |

Isso segue o seu guia de "novo módulo na SayPlus": preparar a SayPlus, entender e adaptar o
archetype, criar o repositório do módulo, rodar local, conectar. A migração das telas entra na
Trilha 3, por ser construção.

---

## 7 · Trilha 3 · Construção

Por feature. É o único lugar onde código de produção nasce. Aqui entram back e front.

| # | Passo | Comando | Artefato | Contexto |
|---|---|---|---|---|
| 1 | **Portão: planejar com Constitution Check** | `/speckit-plan` | `plan.md` | declara conformidade princípio por princípio, ou o ADR que justifica a exceção |
| 2 | Quebrar em tasks | `/speckit-tasks` | `tasks.md` | plano com violação não declarada não vira tasks |
| 3 | Analisar consistência | `/speckit-analyze` | relatório | pula com menos de 20 tasks |
| 4 | Implementar em ondas | `/speckit-implement` | código | máximo 10 tasks ou uma fase por vez; relata e para |
| 5 | Migrar as telas da SayPlus (front) | via `frontend-engineer.md` | código em `<serviço>-web` | comandos de migração um por vez, validando cada etapa |
| 6 | **Portão: convergir** | `/speckit-converge` | `tasks.md` com pendências | compara código contra spec, **desenho e itens de entrega**, plano e tasks; o que faltar volta como tarefa |
| 7 | **Portão: PR com gates** | — | PR aprovado | gates automatizados, sem exceção manual |

**PR fica no seu domínio.** Back commita em `<serviço>-api`, front em `<serviço>-web`, cada um
com seus docs de construção junto do código. Nada de código de produção fora do passo
`implement`: "ajuste rápido" é recusado com a pergunta de qual task cobre.

---

## 8 · Trilha 4 · Entrega e Sustentação

Abre com o go-live, e é aqui que o SRE entra.

**Passo 1 · Provisionar (portão de go-live).** Disparado pelo **primeiro PR aprovado na Trilha
3**. O tech lead ajusta `deploy/infra/requirements.yaml` ao serviço e abre PR ao SRE; o SRE
aprova em PR e provisiona. Re-dispara a cada mudança de infra. Serviço não provisiona a própria
infra.

**Depois do go-live, a sustentação contínua:**

| Situação | Caminho |
|---|---|
| Bug | `/speckit-bug-assess` → `/speckit-bug-fix` → `/speckit-bug-test` |
| Requisito mudou | atualiza o artefato **antes** do código, no mesmo PR do domínio |
| Mudança de infra | novo `requirements.yaml`, novo PR ao SRE |
| Divergência do padrão | para o trabalho e abre ADR |
| Regra da casa mudou | emenda à constituição por PR dedicado |

---

## 9 · Os três archetypes

A variante é decidida com a spec na mão, e é registrada em ADR. A escolha errada não é ajuste
de config: a variante simples derruba o build ao encontrar import de cache, mensageria ou HTTP
externo.

| Precisa de cache distribuído, mensageria ou HTTP externo? | Desenho | Archetype |
|---|---|---|
| Não | tradicional em camadas | `simplified-traditional-archetype` (simples) |
| Sim | tradicional em camadas | `traditional-archetype` (completa) |
| Sim, e o domínio é complexo, com muita regra ou integração isolável | hexagonal (ports/adapters) | `layered-archetype` (completa) |

Isto **resolve o `TODO(VARIANTE_COMPLETA)`** da Constituição de Engenharia: a variante completa
existe e são duas, tradicional e hexagonal.

---

## 10 · Modelo de repositórios

Um container por serviço, com três repos:

```
<serviço>/
├── <serviço>-prod/   entregáveis de produto (Trilhas 0 e 1) + docs de referência
├── <serviço>-api/    back: nascido de um dos archetypes; docs de construção de back junto do código
└── <serviço>-web/    front: convenções SayPlus + frontend-engineer.md; docs de front junto do código
```

Consequência sobre o spec-anchored: como back e front vivem em repos separados, o "mesmo PR" do
código com o artefato vale **dentro de cada domínio**. O PR de back atualiza os docs de back no
mesmo PR, o de front idem. O `-prod` guarda o PRD e os docs de referência.

Os docs de construção seguem um **padrão fixo** em cada repo de domínio, igual em todo serviço:

```
<serviço>-api/docs/            (idem em <serviço>-web/docs/)
├── README.md      índice
├── plan.md
├── tasks.md
└── adr/0001-*.md  decisões de arquitetura
```

---

## 11 · Portões e assinatura

| Portão | Executa | Assina | Regra de separação |
|---|---|---|---|
| `decide` (Trilha 0) | Etiene e Daniel, com operações | operações co-assina | quem propõe não assina sozinho |
| `checklist` / aceite (Trilha 1) | produto | operações, **tech lead** e **segurança** co-assinam | quatro assinaturas; segurança entra quando toca dinheiro, identidade ou comunicação com apostador; quem escreve não aceita sozinho |
| Constitution Check (Trilha 3) | agente declara | revisor humano | violação sem ADR não passa |
| PR final (Trilha 3) | dev responsável | revisor humano | autor não aprova o próprio PR |
| Provisionar / go-live (Trilha 4) | tech lead | SRE aprova em PR | 1º PR aprovado da Trilha 3 dispara |

Revisão humana verifica o que a ferramenta não vê: fronteira entre serviços, isolamento de
tenant, contrato de erro, e se a spec resolve o problema descrito.

---

## 12 · Decisões desta revisão

1. **Trilha 2 local-first.** O serviço nasce e é provado na máquina; o SRE não entra na Trilha 2.
2. **Provisionamento na Trilha 4.** É o passo 1 (go-live), disparado pelo primeiro PR aprovado
   da Trilha 3 e a cada mudança de `requirements.yaml`.
3. **Três archetypes** com matriz de escolha; tradicional vs hexagonal pelo critério de
   complexidade do domínio (hexagonal quando há muita regra ou integração isolável).
4. **Modelo de três repositórios** por serviço (`-prod` / `-api` / `-web`), PR por domínio, com
   `docs/` em padrão fixo nos repos de código. Migração de telas do front versionada no `-web`.
5. **Dono de segurança: Rian.** Aprova exceção de CVE e a emenda dos Princípios II, III e VIII.
6. **Redesenho da Trilha 1** (anexo de arquitetura, 18/09). Nove passos: dois novos (perfis e
   atores; histórias) e quatro ampliados (desenho com matriz de permissões e sinais de
   comportamento; validação com contrato de evento em jogo; compilação com origem por item;
   portão com quatro assinaturas). Fecha os seis gaps de rastreabilidade entre produto e
   Engenharia. `ESTEIRA.md` v0.6, `LEIA-PRIMEIRO.md` v0.5, extensão de produto v1.3.0,
   Constituição de Engenharia v1.2.0 (convergência compara também contra desenho e itens).

**Decisões de processo pendentes** (do anexo, a fechar antes da adoção plena; ficam marcadas na
esteira até alguém assinar):

1. Dono da régua de prioridade (o que é P1 e quem assina).
2. Granularidade do item de entrega: um por requisito ou um por história.
3. Quem registra as permissões na plataforma.
4. Validação equivalente ao mockup em produto de jogo (proposta: conferência do contrato de
   evento, com aval de quem responde pelo contrato).
5. Se a variante hexagonal exige decisão registrada sempre.

A ratificar com engenharia (Rian), caso queira ajustar: o critério tradicional vs hexagonal e a
cadência de reentrada do SRE.

---

**Versão** para apresentação · inclui o redesenho da Trilha 1 (ESTEIRA.md v0.6) · **Régua**
Constituição de Engenharia da Suprema v1.2.0 · **Ferramenta** Spec Kit v1.0.1 pinada ·
Archetypes: simplified-traditional, traditional, layered
