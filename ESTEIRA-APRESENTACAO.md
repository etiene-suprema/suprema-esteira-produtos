# Esteira de Criação Suprema

Documento de apresentação para arquitetura. Explica o processo completo pelo qual produto e
serviço nascem na Suprema, o contexto de cada trilha e o que muda com a decisão de rodar
**local-first**.

> **Status**: proposta para revisão do arquiteto. Os pontos que dependem de decisão sua estão
> reunidos na última seção.

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
TRILHA 2 · Nascimento      uma vez por serviço  tecnologia + (SRE depois) local-first
TRILHA 3 · Construção      por feature          tecnologia
TRILHA 4 · Sustentação     contínuo             time do serviço
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

---

## 5 · Trilha 1 · Definição do produto

Transforma a decisão em um PRD completo e uma spec de uso validada. É onde o produto fica
concreto tela por tela, antes de qualquer linha de código.

| # | Passo | Comando | Artefato | Para que serve |
|---|---|---|---|---|
| 1 | **Constituição do domínio** | `/speckit-constitution` | `constitution.md` | as restrições de domínio, risco e regulatório do produto. Vem **antes** da spec |
| 2 | Especificar | `/speckit-specify` | `spec.md` | histórias priorizadas, requisitos numerados, aceite, sucesso mensurável, bordas |
| 3 | Clarificar | `/speckit-clarify` | `spec.md` atualizado | resolve as indefinições antes de desenhar |
| 4 | **Propor e aprovar a superfície** | `/speckit-produto-desenho` | `desenho.md` | perfis, navegação, telas, ações, estados de vazio e erro, notificações, eventos a medir |
| 5 | **Mockup de validação** | `/speckit-produto-mockup` | `mockup/index.html` | HTML descartável, prova o entendimento e gera ideia nova |
| 6 | **Portão: checklist e aceite** | `/speckit-checklist` | `checklist.md` | fronteira com tecnologia |

Por que a constituição vem antes da spec: ela carrega a régua de domínio. Especificar primeiro
produz requisito que viola a própria régua, e a violação só apareceria semanas depois, com o
PRD aprovado.

O passo 4 é **proposta primeiro, não entrevista**: o agente lê os artefatos e escreve um
desenho completo, marcando `[SUPOSTO]` no que deduziu e `[INDEFINIDO]` no que não soube supor.
Reagir a uma proposta custa uma fração de responder quarenta perguntas. O mockup é
**descartável**: nada dele entra no código, que nasce do archetype na Trilha 3.

---

## 6 · Trilha 2 · Nascimento do serviço (local-first)

Aqui o produto aprovado vira um serviço de pé na máquina do desenvolvedor. **A decisão desta
revisão: rodar tudo localmente e adiar o SRE.** O archetype já foi feito para isso, sobe inteiro
com `docker compose` (Postgres, Redis, LocalStack) e roda os mesmos gates do CI localmente.

| # | Passo | Artefato / prova | Contexto |
|---|---|---|---|
| 1 | Subir a SayPlus localmente | host de pé na máquina | pré-requisito: o módulo precisa de um lugar onde encaixar |
| 2 | Escolher o archetype | ADR de variante | pela matriz da seção 9, decidido com a spec na mão |
| 3 | Gerar o módulo e adaptar lendo os `.md` do archetype | repo `<serviço>-api` | a documentação do archetype orienta a criação; não se copia sem entender |
| 4 | Rodar o módulo local | `docker compose up` + migrations + **gates verdes** | verde aqui é verde no CI |
| 5 | Consolidar a constituição do serviço | `constitution.md` (mãe + domínio) | junta a Constituição de Engenharia com a de domínio da Trilha 1 |
| 6 | Remover o módulo de exemplo | ausência de `users`/`petstore` | o `[EXEMPLO]` sai antes do primeiro merge |
| 7 | Conectar o módulo à SayPlus localmente | integração funcionando local | fim da Trilha 2 nesta fase |
| — | ~~Declarar infra e abrir PR ao SRE~~ | **adiado** | os manifestos `deploy/` e `catalog-info.yaml` ficam no repo como contrato para quando o SRE entrar |

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
| 6 | **Portão: convergir** | `/speckit-converge` | `tasks.md` com pendências | compara código contra spec/plano/tasks; o que faltar volta como tarefa |
| 7 | **Portão: PR com gates** | — | PR aprovado | gates automatizados, sem exceção manual |

**PR fica no seu domínio.** Back commita em `<serviço>-api`, front em `<serviço>-web`, cada um
com seus docs de construção junto do código. Nada de código de produção fora do passo
`implement`: "ajuste rápido" é recusado com a pergunta de qual task cobre.

---

## 8 · Trilha 4 · Sustentação

Contínuo, pelo time do serviço, com o serviço já em produção.

| Situação | Caminho |
|---|---|
| Bug | `/speckit-bug-assess` → `/speckit-bug-fix` → `/speckit-bug-test` |
| Requisito mudou | atualiza o artefato **antes** do código, no mesmo PR do domínio |
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

---

## 11 · Portões e assinatura

| Portão | Executa | Assina | Regra de separação |
|---|---|---|---|
| `decide` (Trilha 0) | Etiene e Daniel, com operações | operações co-assina | quem propõe não assina sozinho |
| `checklist` / aceite (Trilha 1) | produto | operações co-assina | quem escreve a spec não aceita sozinho |
| Constitution Check (Trilha 3) | agente declara | revisor humano | violação sem ADR não passa |
| PR final (Trilha 3) | dev responsável | revisor humano | autor não aprova o próprio PR |
| `requirements.yaml` / SRE | tech lead | SRE aprova em PR | **adiado** enquanto local-first |

Revisão humana verifica o que a ferramenta não vê: fronteira entre serviços, isolamento de
tenant, contrato de erro, e se a spec resolve o problema descrito.

---

## 12 · Pontos abertos que dependem de você

1. **Critério tradicional vs hexagonal.** Proposta: hexagonal quando o domínio é complexo com
   muita regra ou integração isolável; tradicional no resto. Confirma ou ajusta?
2. **Reentrada do SRE.** Local-first agora. Qual o gatilho para reativar a declaração de infra e
   o provisionamento: antes do primeiro ambiente compartilhado? Antes de tráfego real? Um ADR?
3. **Migração de telas.** Os comandos de migração do front, executados um a um pela SayPlus,
   ficam melhor documentados onde: no `frontend-engineer.md` da SayPlus, no `-web`, ou no `-prod/docs`?
4. **Dono de segurança.** A Constituição de Engenharia cita um responsável por segurança para
   exceção de CVE e para emenda dos princípios de identidade, tenant e supply chain. Quem é?
5. **Convenção de docs de construção.** Confirmado que ficam junto do código, no repo do
   domínio. Alguma estrutura mínima que você queira padronizar (pasta, índice)?

---

**Versão** rascunho para revisão · **Régua** Constituição de Engenharia da Suprema v1.0.0 ·
**Ferramenta** Spec Kit v1.0.1 pinada · Archetypes: simplified-traditional, traditional, layered
