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
- **`produto`** entrega os passos 2, 3, 6, 7 e 8 da Trilha 1: perfis e atores, histórias, a
  proposta da superfície do produto, a validação (mockup) e a compilação da entrega. É extensão da
  própria Suprema, por isso instala de diretório local com `--dev`, apontando para a pasta
  `extension-produto` deste repositório. Sem ela, o PRD sai sem ator, sem história padronizada e
  sem tela, e o produto só vira concreto na mão do desenvolvedor.

Em CI ou sessão sem teclado, acrescente `--non-interactive` ao `init`. Para inicializar dentro
de diretório que já tem arquivos, acrescente `--force`.

### 1.3 Estado esperado ao fim do bootstrap

```
<projeto>/
├── CLAUDE.md                      ← este arquivo, copiado do template
├── .gitignore                     ← inclui .claude/ e .DS_Store
├── .claude/skills/                ← 23 skills (10 core + 5 assess + 3 bug + 5 produto)
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

Confira a contagem de skills antes de começar (esperado: 23):

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
TRILHA 2 · Nascimento          uma vez por serviço  tech (local, sem SRE)
TRILHA 3 · Construção          por feature          tech
TRILHA 4 · Entrega e Sustentação  contínuo          time do serviço + SRE
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

Nenhuma trilha foi criada, removida ou reordenada. A Trilha 1 passa a ter **nove passos**: dois
**novos** (perfis e atores, e histórias) e quatro **ampliados** (desenho, validar, compilar e o
portão). O que muda fecha os seis gaps de rastreabilidade entre produto e Engenharia.

| # | Passo | Comando | Artefato |
|---|---|---|---|
| 1 | **Constituição do domínio** | `/speckit-constitution` | `.specify/memory/constitution.md` |
| 2 | **Perfis e atores** · novo | `/speckit-produto-perfis` | `specs/NNN-nome/perfis.md` |
| 3 | **Histórias** · novo | `/speckit-produto-historias` | `specs/NNN-nome/historias.md` |
| 4 | Especificar | `/speckit-specify` | `spec.md` |
| 5 | Clarificar | `/speckit-clarify` | `spec.md` atualizado |
| 6 | **Desenho da superfície** · ampliado | `/speckit-produto-desenho` | `desenho.md` |
| 7 | **Validar** · ampliado | `/speckit-produto-mockup` (tela) · conferência de contrato (jogo) | `mockup/index.html` ou nota de conferência |
| 8 | **Compilar a entrega** · ampliado | `/speckit-produto-compilar` | `entregaveis/`, `PRD.md` |
| 9 | **Portão: checklist e aceite** · ampliado | `/speckit-checklist` | `checklists/` |

A constituição vem **antes** de tudo, sempre. Ela contém as restrições de domínio, risco e
regulatório. Especificar sobre uma régua que ainda não existe produz requisito que nasce ilegal,
e a violação só aparece na Trilha 3, com a spec já aprovada.

**Os passos 2 e 3, os dois novos, são o ponto mais estreito da esteira: tudo o que vem depois
herda a qualidade do que sai deles.**

- **Perfis e atores (passo 2).** Lista quem usa o produto e o que cada um pode ver e fazer,
  incluindo **operação, suporte e back-office**, que são os perfis sempre esquecidos. Vem antes
  da história porque história sem ator definido é história sem dono. A tabela de perfis **sai do
  desenho** e passa a nascer aqui; o desenho (passo 6) apenas a consome.
- **Histórias (passo 3).** É onde a história de usuário **nasce**, com **formato único, critério
  de tamanho e régua de prioridade**: o que faz algo ser P1, quem decide, e o que essa marca
  obriga adiante (P1 força a validação por mockup e aparece nos itens de entrega). Antes deste
  passo a história nascia por hábito, sem padrão.

O passo 4 (**especificar**) converte as histórias do passo 3 em **requisitos numerados**, cada
um com critério de aceite e métrica de sucesso, sempre sobre o **quê** e o **porquê**, nunca
tecnologia. O passo 5 (**clarificar**) fecha o que ficou em aberto; marca visível é recurso, não
falha, e nada avança com lacuna escondida.

O passo 6 (**desenho**) é o **produto concreto**, tela por tela: menus, colunas, botões, filtros,
estados de vazio e de erro, o que muda por marca, e que evento precisa ser medido para cada
métrica ser verificável. O método é **proposta primeiro, não entrevista**: o agente lê os
artefatos, a constituição e a especificação e escreve um desenho completo, marcando `[SUPOSTO]`
no que deduziu e `[INDEFINIDO]` no que não soube supor; o que fica sem marca é rastreável a um
artefato. Itera em rodadas até a **aprovação explícita**, gravada como `**Status**: aprovado`.

O desenho passa a entregar **duas coisas novas**, ambas fatos de negócio, sem tecnologia:

- **Matriz de permissões no formato da plataforma** (SayPlus): cada permissão no padrão
  `modulo.recurso.acao`, com os verbos `read | create | edit | delete`, pronta para o registro no
  catálogo que o Princípio II exige. É o que faz permissão e segurança deixarem de cruzar a
  fronteira sem dono.
- **Sinais de comportamento do produto**: avisa por notificação, depende de outro sistema, tem
  volume alto, roda em horário. São a **evidência escrita** que embasa a escolha da variante do
  archetype na Trilha 2, hoje feita sem registro.

O passo 7 (**validar**) prova o entendimento e gera ideia nova. Para produto de **tela**, gera um
mockup navegável e conduz a entrevista: é onde aparece a divergência que o texto esconde e a
ideia que ninguém escreveu. Para **jogo**, o equivalente é a **conferência do contrato de evento**
contra o que já está valendo, porque em jogo é o contrato, e não o menu, que a tecnologia consome.
O mockup é **descartável**: HTML e CSS puros, dado fictício, nunca aproveitado no código, que
nasce do archetype na Trilha 3.

O passo 8 (**compilar**) resolve a **fragmentação**. **Unidade de execução, definição única (é
esta a régua, não há outra):** o **item de entrega** é a unidade que viaja sozinha para o backlog;
a história e o requisito são os insumos que o originam. Cada item passa a carregar, em campo
próprio, a **história e o requisito de origem**, para a rastreabilidade não se perder no caminho.
A compilação gera **um arquivo autossuficiente por item** (contexto, requisito, origem, critérios
de aceite, métricas que move, recorte do desenho, dependências, fase) mais o **PRD consolidado**.
As duas saídas são **geradas, nunca editadas à mão**: mudou a especificação ou o desenho, roda de
novo e regera. A **granularidade** do item — um por requisito ou um por história — é decisão de
processo pendente (ver o bloco de decisões abaixo); até fechar, a compilação gera um por requisito
com o campo de origem apontando a história.

Requisito é numerado **por subsistema**, não global: o prefixo diz o dono e roteia o item para a
sub-frente certa. Exemplo real do Projeto Selva: `C-` cliente do jogo, `S-` servidor, `I-`
integração com operadores, `A-` painel administrativo.

O passo 9 (**portão de fronteira**) é o aceite, e é a única passagem para tecnologia. Passa de
duas para **quatro assinaturas**: produto, operações, o **tech lead** que vai receber o trabalho,
e **segurança** quando a feature toca dinheiro, dado de identidade ou comunicação com apostador.

> **Cinco decisões de processo a fechar antes da adoção plena** (do anexo de arquitetura). Não
> criam trilha nem bloqueiam desenhar; são governança, e ficam marcadas como pendência até
> alguém assinar:
> 1. **Dono da régua de prioridade.** O que torna uma história P1 e quem assina. Sem esse nome, o
>    passo 3 nasce sem autoridade.
> 2. **Granularidade do item de entrega:** um por requisito ou um por história. Muda o formato do
>    backlog inteiro e se decide uma vez.
> 3. **Quem registra as permissões na plataforma.** A régua exige registro antes do uso, e nenhum
>    passo tem esse dono hoje.
> 4. **Validação equivalente ao mockup em produto de jogo.** A proposta é a conferência do
>    contrato de evento; precisa de aval de quem responde pelo contrato.
> 5. **Se a variante hexagonal exige decisão registrada sempre.** As duas primeiras linhas da
>    matriz de escolha têm gate automático; a terceira depende de julgamento, e julgamento sem
>    registro não é verificável.

### Trilha 2 · Nascimento do serviço (local-first)

Roda **local-first**: o serviço nasce e é provado na máquina, sem depender do SRE. O archetype
sobe inteiro com `docker compose` (Postgres, mais Redis e LocalStack na variante completa) e
roda os **mesmos gates do CI localmente**. Verde aqui é verde no CI.

| # | Passo | Artefato / prova |
|---|---|---|
| 0 | Subir a SayPlus localmente | host de pé na máquina (pré-requisito do módulo) |
| 1 | Escolher o archetype | ADR de variante |
| 2 | Gerar o serviço a partir do archetype, adaptando pela documentação `.md` dele | repo `<serviço>-api` |
| 3 | Rodar local: `docker compose up`, migrations, **gates verdes** | serviço de pé, gates passando |
| 4 | Consolidar a constituição do serviço | `constitution.md` (mãe + domínio) |
| 5 | Remover o módulo de exemplo | ausência de `src/modules/users/` (ou `petstore`) |
| 6 | Conectar o módulo à SayPlus localmente | integração funcionando local |

**Escolha do archetype**, decidida **com a spec na mão** e registrada em ADR:

| Precisa de cache distribuído, mensageria ou HTTP externo? | Desenho | Archetype |
|---|---|---|
| Não | tradicional em camadas | `simplified-traditional-archetype` (simples) |
| Sim | tradicional em camadas | `traditional-archetype` (completa) |
| Sim, e o domínio é complexo, com muita regra ou integração isolável | hexagonal (ports/adapters) | `layered-archetype` (completa) |

Errar a escolha não é ajuste de config: a variante simples carrega um gate de arquitetura que
**derruba o build** ao encontrar import de cache, mensageria ou HTTP externo. A correção depois
é retrabalho.

**O SRE não entra aqui.** A Trilha 2 é local do começo ao fim. O archetype já traz `deploy/` e
`catalog-info.yaml`, que ficam no repo como referência e contrato. **Provisionar é a Trilha 4**,
no primeiro go-live, não agora.

### Trilha 3 · Construção

| # | Passo | Comando | Artefato |
|---|---|---|---|
| 1 | **Portão: planejar com Constitution Check** | `/speckit-plan` | `plan.md` |
| 2 | Quebrar em tasks | `/speckit-tasks` | `tasks.md` |
| 3 | Analisar consistência | `/speckit-analyze` | relatório |
| 4 | Implementar em ondas (back em `-api`, front em `-web`) | `/speckit-implement` | código |
| 5 | Migrar as telas da SayPlus (front) | via `frontend-engineer.md` | código em `<serviço>-web` |
| 6 | **Portão: convergir** | `/speckit-converge` | `tasks.md` com pendências |
| 7 | **Portão: PR com gates** | — | PR aprovado |

**PR fica no seu domínio.** Back commita em `<serviço>-api`, front em `<serviço>-web`, cada um
com os docs de construção junto do código. O passo 5 executa os comandos de migração de tela
**um por vez**, validando o resultado de cada etapa, conforme o guia do módulo na SayPlus. Os
comandos e as notas de migração ficam versionados no próprio `<serviço>-web`.

### Trilha 4 · Entrega e Sustentação

Abre com o **go-live**: é aqui que o SRE entra e o serviço passa a existir fora da máquina. O
resto é a operação contínua.

**Passo 1 · Provisionar (portão de go-live).** Disparado pelo **primeiro PR aprovado na Trilha
3**. O tech lead ajusta `deploy/infra/requirements.yaml` ao serviço e abre PR ao SRE; o SRE
aprova em PR e provisiona. Serviço não provisiona a própria infra. **Re-dispara** sempre que
`requirements.yaml` mudar (feature futura que acrescente cache, mensageria ou HTTP externo).

**Depois do go-live, a sustentação contínua:**

| Situação | Caminho |
|---|---|
| Bug | `/speckit-bug-assess` → `/speckit-bug-fix` → `/speckit-bug-test` |
| Requisito mudou | atualiza o artefato **antes** do código, no mesmo PR do domínio |
| Mudança de infra | novo `requirements.yaml`, novo PR ao SRE |
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

**Quando a sub-frente vira serviço:** na Trilha 2 o serviço nasce em um **container de três
repositórios**, e os artefatos de produto de `.specify/` são copiados para o `-prod`:

```text
<serviço>/
├── <serviço>-prod/   entregáveis de produto (Trilhas 0 e 1) + docs de referência
├── <serviço>-api/    back: nascido de um dos archetypes; docs de back junto do código
└── <serviço>-web/    front: convenções SayPlus + frontend-engineer.md; docs de front junto do código
```

A partir daí a feature seguinte roda no repositório do **domínio**: back em `-api`, front em
`-web`, cada um com seus docs de construção junto do código. O `-prod` guarda o PRD e o que é
fonte de verdade de produto.

Os docs de construção seguem um **padrão fixo** em cada repo de domínio, para que todo serviço
fique igual:

```text
<serviço>-api/docs/            (idem em <serviço>-web/docs/)
├── README.md      índice
├── plan.md
├── tasks.md
└── adr/0001-*.md  decisões de arquitetura
```

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
| `/speckit-produto-perfis` | `decision.md` com veredicto `seguir` **e** `constitution.md` sem placeholder | falta a Trilha 0 ou a constituição |
| `/speckit-produto-historias` | `perfis.md` existe | rode `produto-perfis` |
| `/speckit-specify` | `historias.md` existe, `decision.md` com veredicto `seguir` **e** `constitution.md` sem placeholder | falta perfis, histórias, a Trilha 0 ou a constituição |
| `/speckit-clarify` | `spec.md` existe | rode `specify` |
| `/speckit-produto-desenho` | `spec.md` existe e `perfis.md` existe | rode `specify` e `produto-perfis` |
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
   **Única exceção:** o mockup do passo 7 (validar) da Trilha 1, que é HTML descartável dentro de
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
| Perfis e atores | os perfis já estão escritos em `perfis.md` e a feature não introduz ator novo | |
| Histórias | | ✱ ponto mais estreito: tudo herda a qualidade daqui |
| `specify` | | ✱ |
| `clarify` | não há marcação de indefinição na spec (verificável por busca) | |
| Desenho do produto | a feature não acrescenta nem altera nenhuma tela, menu, coluna, filtro, ação ou permissão. Se acrescenta ou altera qualquer um deles, **não pula** | |
| Validação (mockup ou contrato) | feature que só muda regra de cálculo ou processamento, sem efeito visível para quem usa. Obrigatório em tela nova, em mudança de navegação e em qualquer feature de prioridade P1. Em **jogo**, a conferência do contrato de evento **não pula** | |
| Compilar a entrega | **nunca pula** quando o trabalho vai para o backlog de outra pessoa. Pula só em feature que a mesma pessoa especifica e executa na sequência | ✱ |
| `checklist` | feature de prioridade baixa, **a critério de produto**. Obrigatório em feature que toque dinheiro, dado de identidade ou comunicação com apostador | |
| Trilha 2 inteira | o serviço já existe **e** o inventário de divergências está registrado | |
| Escolha da variante | | ✱ erro aqui é retrabalho, não config |
| Provisionar / PR ao SRE (Trilha 4) | | ✱ portão de go-live; dispara no 1º PR aprovado e a cada mudança de infra |
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
| `checklist` / aceite (fronteira) | produto | operações, **tech lead** e **segurança** co-assinam | quatro assinaturas: tech lead recebe o trabalho; segurança entra quando a feature toca dinheiro, identidade ou comunicação com apostador; quem escreve não aceita sozinho |
| Provisionar / go-live (Trilha 4) | tech lead | SRE aprova em PR | 1º PR aprovado da Trilha 3 dispara; serviço não provisiona a própria infra |
| Constitution Check | agente declara | revisor humano confere | violação sem ADR não passa |
| PR final | dev responsável | revisor humano | autor não aprova o próprio PR |

Revisão humana verifica o que a ferramenta não vê: fronteira entre serviços, isolamento de
tenant, contrato de erro, e se a especificação resolve o problema que foi descrito.

**Dono de segurança: Rian.** Aprova exceção de CVE registrada e a emenda dos Princípios II, III
e VIII da Constituição de Engenharia.

---

## 7 · Persistência dos artefatos

Modelo **spec-anchored**. Os artefatos **sobrevivem** à implementação e são a fonte de
verdade para a mudança seguinte.

- Requisito mudou? O artefato correspondente é atualizado **antes** do código.
- A alteração do artefato de construção entra no **mesmo PR** da mudança de código, **dentro do
  seu domínio**: back em `-api`, front em `-web`. Com back e front em repositórios separados, o
  "mesmo PR" vale por domínio, não cruzando repositório.
- O artefato de produto (PRD, spec, desenho) é fonte de verdade em `-prod`; quando ele muda, a
  mudança é referenciada no PR de código que a implementa.
- Na **convergência** (Trilha 3) o código é comparado contra **a especificação, o desenho e os
  itens de entrega**, não só contra a spec. É o que faz decisão de produto — estado de erro,
  permissão por perfil, evento que alimenta a métrica — ser conferida contra o que foi aceito, e
  não só o requisito em prosa.
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
| Archetype simples (tradicional) | `rian-suprema/simplified-traditional-archetype` | golden path sem cache/mensageria |
| Archetype completo (tradicional) | `rian-suprema/traditional-archetype` | golden path com cache/mensageria/HTTP externo |
| Archetype completo (hexagonal) | `rian-suprema/layered-archetype` | golden path para domínio complexo, ports/adapters |
| Sistema hospedeiro | `SupremaCO/sayplus` | onde cada módulo é abrigado |

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

**Versão**: 0.6 | **Depende de**: Constituição de Engenharia da Suprema v1.2.0 · Spec Kit v1.0.1
pinada · Archetypes simplified-traditional / traditional / layered | **Atualizado**: 2026-09-18

Nesta versão (0.6): a **Trilha 1 ganha nove passos** — dois novos (perfis e atores; histórias) e
quatro ampliados (desenho, validar, compilar, portão) —, fechando os seis gaps de rastreabilidade
entre produto e Engenharia do anexo de arquitetura: história com padrão próprio, perfis antes da
história, definição única do item de entrega com campo de origem, convergência contra desenho e
itens, sinais de comportamento como evidência da variante, e matriz de permissões com assinatura
de tech lead e segurança no portão. Cinco decisões de processo ficam marcadas como pendentes.
Versão anterior (0.5): Trilha 2 **100% local**; provisionamento com SRE na **Trilha 4**; três
archetypes com matriz de escolha; modelo de três repositórios (`-prod` / `-api` / `-web`).
