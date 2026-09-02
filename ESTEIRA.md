# Esteira de Criação Suprema — instruções operacionais

> **Este arquivo é copiado como `CLAUDE.md` na raiz de todo projeto novo da Suprema.**
> É carregado automaticamente em toda sessão do agente. Não renomear, não mover.
> Para agentes que não sejam o Claude Code, o nome portável é `AGENTS.md`.

Este documento define **a ordem obrigatória** em que o trabalho acontece neste repositório.
Ele não é sugestão, não é referência opcional e não é documentação. É a instrução que governa
o comportamento do agente neste projeto.

**Regra zero:** na dúvida entre avançar e parar, **pare e pergunte**. Avançar fora de ordem
custa mais que esperar.

---

## 1 · Bootstrap (uma vez, ao criar o projeto)

Pré-requisitos na máquina: **[uv](https://docs.astral.sh/uv/)**, **Python 3.11+**, **git**,
**Node 22** e **Docker** (necessário para os testes e2e do archetype).

### 1.1 Instalar a CLI, pinada por tag

A CLI MUST ser instalada de forma **persistente**, porque os comandos seguintes (`init`,
`extension add`, `workflow`) dependem de `specify` estar no PATH.

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v1.0.1
```

**A tag é obrigatória.** Nunca instalar da branch principal: o projeto libera cerca de 285
commits por mês e a versão 1.0 foi declarada pelo próprio mantenedor como "apenas um número",
sem promessa de estabilidade de API.

Confirme antes de seguir:

```bash
specify version
```

> **Alternativa sem instalar nada** (deixa a máquina limpa, mas exige prefixo em **todo**
> comando, inclusive nos de extensão):
> `uvx --from git+https://github.com/github/spec-kit.git@v1.0.1 specify <subcomando>`
> Usar `uvx` só no `init` e depois chamar `specify` puro **falha**: o `uvx` é efêmero e não
> deixa o binário no PATH.

### 1.2 Criar o projeto e instalar as extensões

```bash
specify init <nome-do-projeto> --integration claude --script sh
cd <nome-do-projeto>
specify extension add assess
specify extension add bug
specify extension add "$ESTEIRA_DIR"/extension-produto --dev
```

- **`assess`** entrega a Trilha 0. Sem ela, os comandos `/speckit-assess-*` não existem e a
  trilha de descoberta não tem como rodar.
- **`bug`** entrega a Trilha 4. Sem ela, correção de bug não tem caminho e vira commit avulso.
- **`produto`** entrega os passos 4, 5 e 6 da Trilha 1: a proposta da superfície do produto, o
  mockup de validação e a compilação da entrega. É extensão da própria Suprema, por isso instala de diretório local com
  `--dev`, apontando para a pasta `extension-produto` deste repositório. Sem ela, o PRD
  sai sem tela, sem menu e sem botão, e o produto só vira concreto na mão do desenvolvedor.

Em CI ou sessão sem teclado, acrescente `--non-interactive` ao `init`. Para inicializar dentro
de diretório que já tem arquivos, acrescente `--force`.

### 1.3 Estado esperado ao fim do bootstrap

```
<projeto>/
├── CLAUDE.md                      ← este arquivo, copiado do template
├── .gitignore                     ← inclui .claude/ e .DS_Store
├── .claude/skills/                ← 21 skills (10 core + 5 assess + 3 bug + 3 produto)
└── .specify/
    ├── memory/constitution.md     ← ainda com placeholder neste momento
    ├── templates/                 ← 5 templates
    ├── scripts/bash/              ← 6 scripts, executáveis
    ├── extensions.yml             ← extensões instaladas e hooks registrados
    ├── extensions/assess/
    ├── extensions/bug/
    ├── extensions/produto/
    └── workflows/speckit/
```

Confira a contagem de skills antes de começar (esperado: 21):

```bash
ls .claude/skills | wc -l
```

O aviso "Configuration may be required" na instalação de extensão é normal: aponta o diretório
`.specify/extensions/<nome>/` onde a configuração opcional vive.

### 1.4 Antes de qualquer trabalho começar

Três arquivos MUST estar no lugar:

| Arquivo | Origem | Estado exigido |
|---|---|---|
| `CLAUDE.md` | este template | na raiz do projeto |
| `.specify/memory/constitution.md` | Constituição de Engenharia da Suprema + a do domínio | **sem placeholder** `[ALL_CAPS]` |
| `.gitignore` | inclui `.claude/` e `.DS_Store` | o diretório do agente pode guardar credencial |

Se `constitution.md` ainda tem placeholder, o projeto **não está pronto**. Ver Trilha 1, passo 1.

---

## 2 · A esteira

Cinco trilhas, em ordem. Cadência diferente em cada uma: uma trilha inteira pula, ou roda
inteira, ou pula passos com critério verificável. Nunca "meio pula".

```
TRILHA 0 · Descoberta          por ideia            produto + operações
TRILHA 1 · Definição           por iniciativa       produto + operações
     ─────────── fronteira: aqui produto entrega para tech ───────────
TRILHA 2 · Nascimento          uma vez por serviço  tech + SRE
TRILHA 3 · Construção          por feature          tech
TRILHA 4 · Sustentação         contínuo             time do serviço
```

### Trilha 0 · Descoberta

Responde apenas: **vale construir isso?** A maioria das ideias deve morrer aqui. Matar ideia
com motivo escrito é resultado, não fracasso.

| # | Passo | Comando | Artefato |
|---|---|---|---|
| 1 | Captar | `/speckit-assess-intake` | `intake.md` |
| 2 | Pesquisar | `/speckit-assess-research` | `research.md` |
| 3 | Definir o problema | `/speckit-assess-define` | `problem.md` |
| 4 | Modelar opções | `/speckit-assess-shape` | `concept.md` |
| 5 | **Portão: decidir** | `/speckit-assess-decide` | `decision.md` |

Tudo em `.specify/assessments/<slug>/`.

O portão pontua sempre pelos **mesmos quatro critérios**: impacto, esforço, risco regulatório,
reversibilidade. O veredicto é `seguir`, `esclarecer` ou `matar`.

#### Spike: desvio autorizado a partir do passo 4

Às vezes o `shape` não fecha sem uma resposta que só o código dá: "isso encaixa na plataforma
sem alterar o hospedeiro?", "esse provedor entrega o que promete?". Isso é um **spike**, e ele é
o único caso em que se toca tecnologia antes da Trilha 2.

O spike é **autorizado**, não improvisado. Quatro exigências, todas obrigatórias:

| Exigência | Por quê |
|---|---|
| **Pergunta escrita**, uma só, respondível com sim ou não | spike sem pergunta vira projeto paralelo |
| **Prazo** definido na autorização | o custo do spike é o tempo, e ele precisa de teto |
| **Saída em `spike-<slug>.md`**: a pergunta, o que foi tentado, a resposta, a recomendação | sem registro, o aprendizado morre com a sessão |
| **Código produzido é descartável** | mesma regra do mockup: não entra em produção, não é referência de estrutura |

Depois do spike, volta-se ao `shape` com a resposta, e o `decide` a considera.

Por que isto existe declarado em vez de "resolver depois": sem caminho legítimo, tocar
tecnologia na descoberta acontece **por fora**, e acontece exatamente nos casos de maior risco,
que são os que mais precisavam de registro. Nomear custa meia página e fecha o furo.

### Trilha 1 · Definição do produto

| # | Passo | Comando | Artefato |
|---|---|---|---|
| 1 | **Constituição do domínio** | `/speckit-constitution` | `.specify/memory/constitution.md` |
| 2 | Especificar | `/speckit-specify` | `specs/NNN-nome/spec.md` |
| 3 | Clarificar | `/speckit-clarify` | `spec.md` atualizado |
| 4 | **Propor e aprovar a superfície do produto** | `/speckit-produto-desenho` | `desenho.md` |
| 5 | **Mockup navegável de validação** | `/speckit-produto-mockup` | `mockup/index.html` |
| 6 | **Compilar a entrega** | `/speckit-produto-compilar` | `entregaveis/`, `PRD.md` |
| 7 | **Portão: checklist e aceite** | `/speckit-checklist` | `checklists/` |

A constituição vem **antes** da especificação, sempre. Ela contém as restrições de domínio,
risco e regulatório. Especificar primeiro produz requisito que viola a própria régua, e a
violação só aparece na Trilha 3, com a spec já aprovada.

Os passos 4 e 5 são o **produto concreto**. A especificação diz o que o produto faz; o desenho
diz como a pessoa usa: menus, telas, colunas, botões, filtros, estados de erro e de vazio,
permissões por perfil, notificações, o que muda por marca, e que evento precisa ser medido em
cada tela. Sem eles o PRD termina abstrato e as decisões de produto acabam sendo tomadas por
quem implementa.

O método do passo 4 é **proposta primeiro, não entrevista**. O agente lê os artefatos da Trilha
0, a constituição e a especificação, e escreve um desenho completo. Reagir a uma proposta
concreta custa uma fração do que responder a quarenta perguntas abertas. Para isso não virar
ancoragem, ele MUST marcar `[SUPOSTO]` em tudo que deduziu e `[INDEFINIDO]` no que não conseguiu
supor: o que fica sem marca precisa ser rastreável a um artefato. Assim você varre só as
suposições em vez de reler tudo.

O desenho itera em rodadas até a **aprovação explícita**, gravada no cabeçalho do arquivo como
`**Status**: aprovado`. O passo 5 só roda depois disso, porque mockar proposta que vai mudar é
desperdício.

O passo 5 tem duas funções, nesta ordem: **provar entendimento** (ver a tela revela divergência
que o texto esconde) e **gerar ideia** (quem vê a tela pensa em coisa nova). O que emergir na
entrevista do mockup volta para `desenho.md` e para `spec.md`, em vez de virar pedido solto
depois.

O mockup é **descartável**: HTML e CSS puros, dado fictício, nunca aproveitado no código. A
construção acontece a partir do archetype, na Trilha 3.

O passo 4 escolhe o **conjunto de seções pelo tipo de produto**. Interface (web, app,
back-office) usa perfis, navegação, telas, estados e permissões. **Jogo** usa contrato de
evento, estados de rodada, regras de aposta, integração de carteira, jogo responsável e
auditoria, e só então as telas mínimas. Em jogo, menu é quase irrelevante: o entregável do
upstream para tecnologia é o **contrato de evento**, e ele não é inventado, é validado contra o
contrato vigente do RGS.

O passo 6 resolve a **fragmentação**. Os artefatos anteriores são o raciocínio e a fonte de
verdade, mas a unidade de execução é o item: uma história, um épico, uma task, que viaja sozinha
para o backlog. A compilação gera **um arquivo autossuficiente por item** (contexto, requisito,
critérios de aceite, métricas que move, recorte do desenho, dependências, fase) mais o **PRD
consolidado** no formato da Suprema. As duas saídas são **geradas, nunca editadas à mão**:
quando a especificação ou o desenho mudarem, o comando roda de novo e regera.

Requisito é numerado **por subsistema**, não global: o prefixo diz quem é o dono e é o que faz o
item ser roteável para a sub-frente certa. Exemplo real do Projeto Selva: `C-` cliente do jogo,
`S-` servidor, `I-` integração com operadores, `A-` painel administrativo.

### Trilha 2 · Nascimento do serviço

| # | Passo | Artefato |
|---|---|---|
| 1 | Escolher a variante do archetype | ADR de variante |
| 2 | Gerar o serviço a partir do archetype | repositório |
| 3 | Consolidar a constituição do serviço | `constitution.md` (mãe + domínio) |
| 4 | Declarar infraestrutura e abrir PR ao SRE | `deploy/infra/requirements.yaml` |
| 5 | Registrar no catálogo | `catalog-info.yaml` |
| 6 | Remover o módulo de exemplo | ausência de `src/modules/users/` |

Critério do passo 1, decidido **com a spec na mão**: o domínio precisa de cache distribuído,
mensageria ou HTTP externo? Não, variante **simples**. Sim, variante **completa**.

O passo 4 começa **cedo de propósito**: o PR ao SRE tem espera externa, e paralelizar essa
fila com o planejamento evita bloqueio na hora de implementar.

### Trilha 3 · Construção

| # | Passo | Comando | Artefato |
|---|---|---|---|
| 1 | **Portão: planejar com Constitution Check** | `/speckit-plan` | `plan.md` |
| 2 | Quebrar em tasks | `/speckit-tasks` | `tasks.md` |
| 3 | Analisar consistência | `/speckit-analyze` | relatório |
| 4 | Implementar em ondas | `/speckit-implement` | código |
| 5 | **Portão: convergir** | `/speckit-converge` | `tasks.md` com pendências |
| 6 | **Portão: PR com gates** | — | PR aprovado |

### Trilha 4 · Sustentação

| Situação | Caminho |
|---|---|
| Bug | `/speckit-bug-assess` → `/speckit-bug-fix` → `/speckit-bug-test` |
| Requisito mudou | atualiza o artefato **antes** do código, no **mesmo PR** |
| Divergência do padrão | para o trabalho e abre ADR |
| Regra da casa mudou | emenda à constituição por PR dedicado |

---

## 3 · Onde os artefatos moram

A ferramenta é **escopada por diretório**: o projeto é qualquer diretório que contenha
`.specify/`. A resolução prefere o `.specify/` **mais próximo**, não a raiz do git. Isso permite
vários projetos independentes num só repositório, cada um com **constituição, numeração de
feature e artefatos próprios**.

É assim que a esteira acomoda sub-frentes:

```text
suprema-produtos/
├── .git/
├── growth/
│   ├── .specify/memory/constitution.md    ← domínio: growth
│   └── specs/001-…, 002-…                 ← numeração própria
├── jogos/
│   ├── .specify/memory/constitution.md    ← domínio: jogos
│   └── specs/001-…
└── kyc/
    ├── .specify/memory/constitution.md    ← domínio: kyc
    └── specs/001-…
```

Uma sub-frente é inicializada como projeto independente:

```bash
specify init growth --integration claude --script sh
```

**Uma constituição por sub-frente, não uma para todas.** É o ponto que decide a estrutura: as
regras de domínio de jogos não são as de KYC. Teto de exposição de campanha não diz nada sobre
retenção de documento. Pasta única forçaria constituição única, e ela viraria genérica, que é o
mesmo que não existir.

O que **não** se repete por sub-frente: a Constituição de Engenharia da Suprema. Ela é
organizacional, vale para todas, e a constituição da sub-frente a herda e complementa.

**Prefixo de requisito acompanha a sub-frente.** A compilação numera por subsistema (`C-`, `S-`,
`I-`, `A-`), e o prefixo é o que roteia o item para o dono certo no backlog.

**Para rodar de fora do diretório**, sem `cd`, aponte a variável de ambiente que seleciona o
projeto para a pasta que contém o `.specify/`. Útil em automação. A seleção do projeto e a
seleção da feature são eixos independentes.

**Quando a sub-frente vira serviço:** na Trilha 2 o serviço nasce do archetype em repositório
próprio, e os artefatos de `.specify/` da sub-frente são copiados para lá. A partir daí a
feature seguinte daquele serviço roda no repositório dele.

---

## 4 · Regras de bloqueio (a parte que morde)

**Antes de executar qualquer comando abaixo, verifique a pré-condição no disco.** Se o
arquivo exigido não existe, ou existe mas não satisfaz a condição, **NÃO execute o comando**.
Informe qual passo falta e pare.

| Comando pedido | Pré-condição verificável | Se faltar |
|---|---|---|
| `/speckit-assess-shape` | `problem.md` existe | rode `define` primeiro |
| `/speckit-assess-decide` | `problem.md` existe; veredicto `seguir` exige `concept.md` | rode `define` e `shape` |
| `/speckit-constitution` | nenhuma | — |
| `/speckit-specify` | `decision.md` com veredicto `seguir` **e** `constitution.md` sem placeholder | falta a Trilha 0 ou a constituição |
| `/speckit-clarify` | `spec.md` existe | rode `specify` |
| `/speckit-produto-desenho` | `spec.md` existe | rode `specify` |
| `/speckit-produto-mockup` | `desenho.md` com `**Status**: aprovado` no cabeçalho | o desenho ainda está em iteração |
| `/speckit-produto-compilar` | `desenho.md` com `**Status**: aprovado` | o desenho ainda está em iteração |
| `/speckit-checklist` | `spec.md`, `desenho.md` e `entregaveis/` existem | falta especificar, desenhar ou compilar |
| `/speckit-plan` | `spec.md` sem indefinição pendente, mais `desenho.md`, `entregaveis/` e `checklists/` presentes | rode `clarify`, `produto-desenho`, `produto-compilar` e `checklist` |
| `/speckit-tasks` | `plan.md` com a seção de Constitution Check **preenchida**, declarando conformidade princípio por princípio | o plano está incompleto |
| `/speckit-implement` | `tasks.md` existe | rode `tasks` |
| `/speckit-converge` | `tasks.md` existe e há código implementado | rode `implement` |

Parte dessa verificação já é mecânica: `.specify/scripts/bash/check-prerequisites.sh` valida
a existência dos artefatos anteriores e é chamado pelos próprios comandos. As condições de
**conteúdo** (placeholder na constituição, marcação pendente na spec, Constitution Check
vazio) são responsabilidade sua, agente, e MUST ser conferidas lendo o arquivo.

### O que você NUNCA faz neste projeto

1. **Escrever código de produção fora do passo `implement`.** Pedido de "só um ajuste
   rápido", "muda só essa linha" ou "faz direto que é simples" MUST ser recusado com a
   pergunta: qual task em `tasks.md` cobre isso? Se nenhuma cobre, o caminho é Trilha 4, não
   um commit avulso. Correção de bug segue a trilha de bug.
   **Única exceção:** o mockup do passo 5 da Trilha 1, que é HTML descartável dentro de
   `specs/<feature>/mockup/`, com dado fictício e sem nenhuma dependência. Ele não é código de
   produção e não é aproveitado na implementação.
2. **Executar `/speckit-plan` com marcação de indefinição pendente na spec.** Planejar sobre
   requisito ambíguo é inventar requisito.
3. **Gerar `tasks.md` a partir de plano com violação de princípio não declarada.** Plano que
   viola a constituição e não aponta o ADR correspondente **não vira tasks**.
4. **Escolher, trocar ou sugerir stack fora do golden path do archetype.** Runtime,
   framework, ORM e banco são fixos. Divergência exige ADR antes do código.
5. **Rodar `implement` na lista inteira de tasks de uma vez.** Máximo de 10 tasks ou uma fase
   por invocação. Sempre relate progresso e pare.
6. **Marcar um passo como concluído sem o artefato no disco.** O artefato é a prova. Sem
   arquivo, o passo não aconteceu.
7. **Preencher lacuna inventando.** Informação que falta vira marcação de indefinição na
   spec ou pergunta ao humano, nunca suposição silenciosa.
8. **Alterar `spec.md`, `plan.md` ou `tasks.md` sem dizer explicitamente o que mudou e por
   quê.** Esses arquivos são fonte de verdade versionada, não rascunho.
9. **Tocar em `.specify/templates/`, `.specify/scripts/` ou no core do spec-kit.**
   Customização se faz em preset ou extensão, nunca editando o que veio da ferramenta.
10. **Aproveitar o mockup como implementação.** Nada de `specs/<feature>/mockup/` entra no
    código de produção, é importado, copiado ou usado como referência de estrutura. O produto
    nasce do Archetype Backend NestJS na Trilha 3. Mockup que vira produção é o jeito mais
    rápido de perder todos os gates de qualidade de uma vez.
11. **Incorporar escopo novo em silêncio.** Se a entrevista do mockup fizer o escopo crescer,
    diga na cara que é escopo novo e que a decisão de incluir é de quem assina o portão.
12. **Editar à mão o que foi gerado.** `entregaveis/` e `PRD.md` são saída da compilação. Mudança
    neles se faz mudando `spec.md` ou `desenho.md` e regerando. Editar o compilado cria uma
    segunda fonte de verdade, que é o problema que a esteira existe para evitar.
13. **Inventar contrato de evento de jogo.** O contrato vigente do RGS é a régua. Localize-o no
    repositório do jogo ou pergunte o caminho. Valor novo em enum fechado é mudança de contrato,
    sujeita à disciplina de versão.

---

## 5 · Critérios de pulo

Um passo só é pulável se o **artefato de saída existe e está atual**. "A gente já pensou
nisso" não é critério. O critério é o arquivo.

| Passo | Pula quando | Nunca pula |
|---|---|---|
| `intake` | a ideia vem de ticket ou ata formalizada; anexe a fonte | |
| `research` | existe evidência documentada e citável; anexe a fonte | |
| `define` | | ✱ único lugar das não-metas |
| `shape` | | ✱ é de onde sai o ADR |
| `decide` | | ✱ veredicto precisa de dono |
| Constituição do domínio | já existe, sem placeholder, e o domínio não mudou | |
| `specify` | | ✱ |
| `clarify` | não há marcação de indefinição na spec (verificável por busca) | |
| Desenho do produto | a feature não acrescenta nem altera nenhuma tela, menu, coluna, filtro, ação ou permissão. Se acrescenta ou altera qualquer um deles, **não pula** | |
| Mockup de validação | feature que só muda regra de cálculo ou processamento, sem efeito visível para quem usa. Obrigatório em tela nova, em mudança de navegação e em qualquer feature de prioridade P1 | |
| Compilar a entrega | **nunca pula** quando o trabalho vai para o backlog de outra pessoa. Pula só em feature que a mesma pessoa especifica e executa na sequência | ✱ |
| `checklist` | feature de prioridade baixa, **a critério de produto**. Obrigatório em feature que toque dinheiro, dado de identidade ou comunicação com apostador | |
| Trilha 2 inteira | o serviço já existe **e** o inventário de divergências está registrado | |
| Escolha da variante | | ✱ erro aqui é retrabalho, não config |
| `requirements.yaml` | | ✱ é o contrato com o SRE, não o pedido |
| `plan` | | ✱ é o passo que impede cada projeto nascer de um jeito |
| `tasks` | | ✱ |
| `analyze` | menos de 20 tasks | |
| `implement` | | ✱ |
| `converge` | | ✱ único passo que verifica o que foi construído |
| PR com gates | | ✱ sem exceção manual |

---

## 6 · Portões e assinatura

Portão sem dono nomeado não é portão.

| Portão | Executa | Assina | Regra de separação |
|---|---|---|---|
| `decide` | Etiene e Daniel, com operações | operações co-assina | quem propõe não assina sozinho |
| `checklist` (aceite da spec) | produto | operações co-assina | quem escreve a spec não aceita sozinho |
| `requirements.yaml` | tech lead | SRE aprova em PR | serviço não provisiona a própria infra |
| Constitution Check | agente declara | revisor humano confere | violação sem ADR não passa |
| PR final | dev responsável | revisor humano | autor não aprova o próprio PR |

Revisão humana verifica o que a ferramenta não vê: fronteira entre serviços, isolamento de
tenant, contrato de erro, e se a especificação resolve o problema que foi descrito.

---

## 7 · Persistência dos artefatos

Modelo **spec-anchored**. Os artefatos **sobrevivem** à implementação e são a fonte de
verdade para a mudança seguinte.

- Requisito mudou? O artefato correspondente é atualizado **antes** do código.
- A alteração do artefato entra no **mesmo PR** da mudança de código.
- Artefato desatualizado é **dívida** e é tratado como dívida.
- É **PROIBIDO** tratar a especificação como andaime descartável.

Sem essa regra, o passo `converge` perde sentido: não há como comparar código contra uma
especificação que ninguém manteve.

---

## 8 · Referências

| Documento | Onde | Rege |
|---|---|---|
| Constituição de Engenharia da Suprema | `CONSTITUICAO-ENGENHARIA.md` | engenharia, todo serviço backend |
| Constituição deste serviço | `.specify/memory/constitution.md` | domínio, risco, regulatório |
| Esteira de Criação Suprema | `LEIA-PRIMEIRO.md` | o processo, versão legível |
| Archetype Backend NestJS | `rian-suprema/simplified-traditional-archetype` | golden path técnico |

**Hierarquia em caso de conflito:** Constituição de Engenharia (em matéria de engenharia) →
constituição do serviço (em matéria de domínio) → ADR do serviço → documento de feature.
Constituição de serviço que contradiga a de engenharia é inválida naquele ponto.

---

## 9 · O que este arquivo garante, e o que não garante

**Garante:** o agente carrega estas instruções em toda sessão e passa a recusar comando fora
de ordem, com a pré-condição nomeada. Cobre o caso comum, que é alguém pedir para pular etapa
por pressa.

**Não garante:** não é gate mecânico. Um humano determinado consegue contornar, e uma sessão
longa pode diluir a instrução no contexto.

O gate mecânico existe em dois lugares e MUST ser tratado como a autoridade final:
- `check-prerequisites.sh`, que barra comando sem artefato anterior;
- os gates do CI no PR, que barram merge.

A esteira só passa a ser **verificada por máquina** de ponta a ponta no nível de workflow
(sequência codificada em YAML com portões e pulo condicional). Até lá, este arquivo mais os
dois gates acima são a defesa disponível.

---

**Versão**: 0.1 rascunho | **Depende de**: Constituição de Engenharia da Suprema v1.0.0 ·
Spec Kit v1.0.1 pinada | **Atualizado**: 2026-08-28
