---
description: "Compila os artefatos fragmentados da Trilha 1 em itens de entrega autossuficientes e num PRD consolidado no formato da Suprema"
---

# Compilar a entrega

Produz duas saídas a partir dos artefatos da Trilha 1. É o passo 6 da Trilha 1 da Esteira de
Criação Suprema.

| Saída | O que é | Para quem |
|---|---|---|
| `specs/<feature>/entregaveis/<PREFIXO>-NN.md` | um arquivo **autossuficiente por item** | quem vai executar, e o tracker |
| `specs/<feature>/PRD.md` | o **documento consolidado**, formato Suprema | quem aprova e quem circula |

## Por que este passo existe

A Trilha 1 produz raciocínio fragmentado por natureza: problema num arquivo, opções em outro,
requisitos num terceiro, superfície num quarto. Isso é bom para pensar e é a fonte de verdade.

Mas a **unidade de execução** é o item: uma história, um épico, uma task. Ela viaja sozinha para
o backlog, e quem abre o card não tem os outros seis arquivos ao lado. Item incompleto obriga
quem executa a decidir produto, tarde e sem quem responde por ele na sala.

Este passo entrega o formato de execução **sem** substituir os artefatos de raciocínio.

## Regra que não se quebra

**As duas saídas são GERADAS. Nunca editadas à mão.**

Escreva isso no topo de cada arquivo produzido. Quando `spec.md` ou `desenho.md` mudarem, este
comando roda de novo e regera. Editar o compilado à mão cria uma segunda fonte de verdade, que
é exatamente o problema que a esteira existe para evitar.

## Entrada do usuário

```text
$ARGUMENTS
```

Considere a entrada antes de prosseguir, se não estiver vazia.

## Pré-condições

1. Rode `.specify/scripts/bash/check-prerequisites.sh --json` e leia os caminhos.
2. `spec.md` MUST existir.
3. `desenho.md` MUST existir com `**Status**: aprovado` no cabeçalho. Se estiver como
   `proposta`, **pare**: compilar desenho em iteração gera item que muda amanhã.
4. Leia **inteiros**: `spec.md`, `desenho.md`, `.specify/memory/constitution.md`, e o que
   existir em `.specify/assessments/<slug>/` (`problem.md`, `concept.md`, `decision.md`).
5. Se existir `checklists/`, leia. O que estiver reprovado lá **não** é compilado como pronto.

## Passo 1 · Declarar os subsistemas e os prefixos

A Suprema numera requisito **por subsistema**, não de forma global. O prefixo diz quem é o dono,
e é o que faz o item ser roteável para a sub-frente certa.

Antes de compilar, declare os subsistemas deste produto e o prefixo de cada um. Derive do
`desenho.md` (perfis, navegação, componentes) e do `spec.md`. Exemplo real, do Projeto Selva:

```text
C-  Cliente do jogo
S-  Servidor de jogo (RGS)
I-  Integração com operadores
A-  Painel administrativo
```

Regras dos prefixos:

- Uma letra, maiúscula, seguida de hífen. Numeração de dois dígitos por subsistema (`C-01`).
- Se `spec.md` já usa `FR-xxx` global, **mapeie** para os prefixos e registre a tabela de
  correspondência no `PRD.md`. Não renumere o `spec.md`.
- Se você não conseguir decidir o corte de subsistema com segurança, **pergunte**. Corte errado
  aqui contamina todo o backlog.

Mostre a lista de prefixos ao usuário e **confirme antes de gerar os arquivos.**

## Passo 2 · Gerar um arquivo por item

Para cada requisito, um arquivo `entregaveis/<PREFIXO>-NN.md` com **todas** as seções:

```markdown
# <PREFIXO>-NN · <título curto do item>

> GERADO por /speckit-produto-compilar. Não edite à mão: rode o comando de novo.
> Fonte: spec.md, desenho.md · Compilado em <AAAA-MM-DD>

**Subsistema**: <nome> · **Prioridade**: <P1|P2|P3> · **Fase**: <onda a que pertence>

## Contexto
<um parágrafo, do problem.md: quem sofre e o que dói. Sem repetir o PRD inteiro.>

## O requisito
<o texto do requisito, imperativo e verificável.>

## Critérios de aceite
- [ ] <verificável, no formato Dado/Quando/Então quando couber>
- [ ] <um por comportamento, incluindo o caminho de erro>

## Métricas que este item move
| Métrica | Origem | O contrato de evento serve? |
|---|---|---|
| <SC-xxx ou KPI> | spec.md §<x> | <sim | não, falta <evento/campo>> |

## Recorte do desenho
**Telas**: <T-xxx, T-yyy>
**Ações**: <botões e controles que este item cria ou altera>
**Estados**: <vazio, erro, sem permissão — só os que este item precisa>
**Permissões**: <perfis afetados>

## Dependências
- <outro item, decisão pendente, insumo externo>

## Fora do escopo deste item
- <o que alguém poderia assumir que está incluso e não está>

## Pendências
- <[INDEFINIDO] herdado do desenho, com quem responde>
```

Regras de conteúdo:

- **Copie o texto, não referencie.** O item precisa ser legível sozinho no tracker. A
  consistência é garantida por regeração, não por link.
- **Critério de aceite é obrigatório.** Se o `spec.md` não tem para aquele requisito, escreva a
  partir do comportamento descrito no `desenho.md` e **marque como proposto**, para o usuário
  conferir.
- **Estado de erro e estado vazio** aparecem nos critérios de aceite quando o item toca tela.
- **Nenhum item sem métrica.** Se um requisito não move nenhuma métrica declarada, diga isso
  explicitamente e pergunte se ele deveria existir. É o filtro mais barato contra escopo órfão.

### Produto de jogo: a checagem do contrato de evento

Se o produto for um jogo, a coluna "o contrato de evento serve?" **não é opinião**. Confronte
cada métrica com o contrato de evento vigente do RGS.

O contrato da Suprema é o **`spin_event.v1`**, definido em `TECH_DESIGN.md` §4 do projeto do
jogo, com o schema espelhado em `DATA_SPEC-analytics.md`. Localize esses arquivos no repositório
do jogo. Se não os encontrar, **pergunte o caminho** em vez de supor campos.

Para cada métrica, responda uma de três coisas:

1. **Serve**: aponte o campo do evento que a alimenta
2. **Não serve, e é dimensão**: o dado vive em `dim_math_version` ou equivalente, join por chave
3. **Não serve, e falta stream**: o dado não existe no contrato nem como dimensão

O caso 3 é o achado caro e MUST ser destacado no `PRD.md` como risco. Precedente real do
Projeto Selva: o `spin_events` só enxerga rodadas, e FTD, registro e depósito vivem no operador
(wallet B2B). Os KPIs de FTD do brief dependiam de um segundo stream operador-side que não
existia. Isso foi descoberto tarde, por olho humano. A compilação existe para pegar antes.

Lembre também da disciplina de versão: valor novo em enum fechado (`action`, `feature_type`,
`reject_reason`) é **mudança de contrato**. Se o `v1` já emitiu em produção, vira `v2`.

## Passo 3 · Gerar o PRD consolidado

`specs/<feature>/PRD.md`, no formato da Suprema, **só de produto**. A parte técnica vive no
plano e no design técnico, e este documento **aponta** para eles em vez de duplicar.

Isso é decisão registrada, não preferência: duplicar stack entre PRD e design técnico é a
origem do drift, e o Projeto Selva já tem drift documentado entre contrato real e especificação.

Estrutura:

```markdown
# PRD — <produto>

> GERADO por /speckit-produto-compilar. Não edite à mão.

**Versão**: <n> · **Data**: <AAAA-MM-DD> · **Autor**: <quem>
**Status**: <o que está fechado e o que está pendente, com ponteiro para o artefato>

## 1 · O produto em uma página
<como funciona, do ponto de vista de quem usa. É o resumo que alguém lê antes da reunião.>

## 2 · Problema e oportunidade
<do problem.md: quem sofre, o que dói, custo de não fazer.>

## 3 · Metas, não-metas e métricas
<metas e NÃO-metas explícitas, métricas com valor-alvo.>

## 4 · Decisão e alternativas
<do concept.md e decision.md: a opção escolhida, as descartadas e o porquê.>

## 5 · Escopo
### 5.1 Requisitos por subsistema
<uma tabela por subsistema: | ID | Requisito | Prioridade | Fase |>
### 5.2 Fora de escopo
<das não-metas e do "fora de escopo visual" do desenho.>

## 6 · Superfície do produto
<resumo do desenho: perfis, mapa de navegação, inventário de telas. Aponta para desenho.md
e para o mockup em vez de repetir o detalhe por tela.>

## 7 · Restrições de domínio e compliance
<da constituição: o que não pode acontecer neste domínio, e por quê.>

## 8 · Roadmap faseado
<uma seção por fase, com tabela de itens e uma linha "**Saída:**" nomeando o critério de
saída da fase. Item concluído fica riscado com marca de feito, nunca é apagado.>

## 9 · Riscos e premissas
<riscos numerados R1..Rn com mitigação. Premissas declaradas em lista.>

## 10 · Referências
<ponteiros: desenho.md, mockup, constituição, design técnico, contrato de evento, artefatos
da descoberta. Com o que cada um manda.>
```

Padrões obrigatórios do formato, observados no PRD do Projeto Selva:

- **Status nomeia o que está congelado e o que está pendente**, com ponteiro para o artefato que
  prova. Não basta "em construção".
- **Toda fase tem "Saída:"** com critério de saída explícito.
- **Item concluído fica riscado e marcado**, nunca apagado. Preserva histórico no documento.
- **Riscos numerados com mitigação ao lado.** Risco sem mitigação é lamento.

## Ao terminar

1. Quantos itens foram gerados, por subsistema
2. Quantos critérios de aceite foram **propostos por você** e precisam de conferência
3. Quantos itens ficaram **sem métrica** e a pergunta se deveriam existir
4. Para jogo: quantas métricas caíram no caso 3 (falta stream), listadas
5. Pendências herdadas do desenho, com quem responde
6. Lembre que os arquivos são gerados e que a edição é por regeração

Escreva **apenas** dentro de `specs/<feature>/`. Não altere `spec.md`, `desenho.md`, templates,
scripts ou o núcleo da ferramenta. Se a compilação revelar contradição entre `spec.md` e
`desenho.md`, **aponte e pergunte** qual dos dois está certo.
