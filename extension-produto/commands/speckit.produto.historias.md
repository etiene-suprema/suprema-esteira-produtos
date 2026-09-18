---
description: "Escreve as histórias de usuário com formato único, critério de tamanho e régua de prioridade, antes de especificar"
---

# Histórias de usuário

Produz `specs/<feature>/historias.md`: é aqui que a **história de usuário nasce**, com formato
único, critério de tamanho e régua de prioridade. É o passo 3 da Trilha 1 da Esteira de Criação
Suprema, e o outro passo novo.

É o **ponto mais estreito de toda a esteira**: a especificação, o desenho, os itens de entrega e o
código herdam a qualidade do que sai daqui. Antes deste passo a história nascia por hábito, sem
padrão, sem tamanho e sem régua de prioridade.

**Este passo NÃO é técnico.** Trata do que a pessoa quer fazer e por quê, nunca de como se
constrói.

## Entrada do usuário

```text
$ARGUMENTS
```

Considere a entrada antes de prosseguir, se não estiver vazia.

## Pré-condições

1. Rode `.specify/scripts/bash/check-prerequisites.sh --json` e leia os caminhos.
2. `perfis.md` MUST existir e estar `**Status**: aprovado`. Se não existir ou estiver em proposta,
   **pare** e diga que o passo 2 (`/speckit-produto-perfis`) ainda não fechou: história sem ator
   definido é história sem dono.
3. Leia **inteiros**: `perfis.md`, a constituição e os artefatos de descoberta que existirem
   (`problem.md`, `concept.md`, `decision.md`).
4. A especificação ainda **não existe** (ela é o passo 4, e consome este arquivo).

## O método: proposta primeiro

Proponha as histórias a partir da descoberta e dos perfis; o usuário reage. Marcas obrigatórias,
mesma regra dos demais passos de produto: `[SUPOSTO]` para o que você deduziu, `[INDEFINIDO]` para
o que não soube supor, nada sem marca que não seja rastreável a um artefato.

## O que escrever

Escreva `specs/<feature>/historias.md` com o cabeçalho `**Status**: proposta · rodada 1` e as
seções abaixo.

### 1 · Formato único da história

Toda história usa o **mesmo formato**, e todo ator citado MUST existir em `perfis.md`:

```text
H-NN · <título curto>
Como <ator de perfis.md>, quero <ação>, para <resultado de negócio>.
Prioridade: <P1 | P2 | P3>   ·   Tamanho: <cabe numa entrega | grande demais, quebrar>
```

### 2 · Critério de tamanho

Uma história que não cabe em uma entrega **é quebrada** em histórias menores, aqui, antes de
especificar. Registre a história-mãe e as filhas. História grande demais que passa para o
`specify` vira requisito ambíguo.

### 3 · Régua de prioridade

O que torna uma história **P1**, **P2** ou **P3**, e o que cada marca **obriga adiante**. O padrão
da esteira: **P1 força a validação por mockup** (passo 7) e aparece nos itens de entrega.

> **[A DEFINIR] — decisão de processo pendente (dono da régua de prioridade).** O anexo de
> arquitetura registra que hoje nenhum documento diz **o que** torna uma história P1 nem **quem**
> assina essa classificação. Até essa decisão ser tomada, marque o dono da priorização como
> `[INDEFINIDO]` e proponha a classificação como `[SUPOSTO]`, para o usuário confirmar. Não invente
> o dono.

### 4 · Rastreabilidade

Cada história aponta a **origem** na descoberta (problema/decisão) que a justifica. Mais adiante,
o requisito (passo 4) e o item de entrega (passo 8) carregam de volta o número da história, para a
rastreabilidade fechar de ponta a ponta.

### 5 · Indefinições em aberto

Lista dos `[INDEFINIDO]`, cada um com quem responde.

## Fase de iteração e aprovação

Entregue um resumo (quantas histórias, quantas P1, quantos `[SUPOSTO]` e `[INDEFINIDO]`), faça
**uma** pergunta sobre o que mudar, e itere em rodadas até a **aprovação explícita**, que grava
`**Status**: aprovado · rodada N · <AAAA-MM-DD>`. Silêncio não é aprovação.

## Ao terminar

1. Confirme o status gravado no arquivo.
2. Diga quantas histórias são P1 e liste os `[INDEFINIDO]` com quem responde, incluindo o dono da
   régua de prioridade enquanto essa decisão estiver pendente.
3. Ofereça o passo seguinte: `/speckit-specify`, que converte estas histórias em requisitos
   numerados.

Escreva **apenas** `specs/<feature>/historias.md`. Não toque em `spec.md` (ele ainda não existe),
em templates, em scripts ou no núcleo da ferramenta.
