---
description: "Lista quem usa o produto e o que cada ator pode ver e fazer (incluindo operação, suporte e back-office), antes de escrever histórias"
---

# Perfis e atores

Produz `specs/<feature>/perfis.md`: **quem usa o produto e o que cada um pode ver e fazer**. É o
passo 2 da Trilha 1 da Esteira de Criação Suprema, e um dos dois passos novos.

Existe porque **história sem ator definido é história sem dono**. Antes deste passo os perfis só
apareciam dentro do desenho, um passo depois de a história já estar escrita. Agora eles nascem
primeiro, e a história (passo 3) e o desenho (passo 6) apenas os consomem.

**Este passo NÃO é técnico.** Nada de stack, banco, endpoint ou arquitetura. Aqui se decide quem
são os atores do produto e o que cada um pode, em linguagem de negócio.

## Entrada do usuário

```text
$ARGUMENTS
```

Considere a entrada antes de prosseguir, se não estiver vazia.

## Pré-condições

1. Rode `.specify/scripts/bash/check-prerequisites.sh --json` e leia os caminhos.
2. `.specify/memory/constitution.md` MUST existir **sem placeholder** `[ALL_CAPS]`. Se ainda tem
   placeholder, **pare**: o passo 1 (constituição do domínio) não terminou.
3. Leia **inteiros**: a constituição e os artefatos de `.specify/assessments/<slug>/` que
   existirem (`problem.md`, `concept.md`, `decision.md`). São a base para propor os perfis.
4. A especificação ainda **não existe** neste ponto (ela é o passo 4). Não a procure.

> **Nota de fiação com engenharia [A DEFINIR]:** perfis e histórias rodam **antes** de
> `/speckit-specify`, que é o comando que cria a pasta da feature no spec-kit. Se
> `check-prerequisites.sh` não resolver uma feature, derive o slug do `decision.md` (ou pergunte),
> crie `specs/<NNN-slug>/` seguindo a convenção do spec-kit e escreva `perfis.md` ali, de modo que
> o `/speckit-specify` reutilize a mesma feature em vez de criar outra. Confirme com a engenharia,
> ao instalar a extensão, qual é o mecanismo exato de criação da feature na tag pinada.

## O método: proposta primeiro

Você tem constituição e descoberta no disco. Isso basta para **propor** os perfis. O usuário
reage, em vez de responder a um questionário. Duas marcas obrigatórias, mesma regra dos outros
passos de produto:

| Marca | Significa |
|---|---|
| *(sem marca)* | rastreável à constituição ou aos artefatos de descoberta |
| `[SUPOSTO]` | você deduziu, precisa de confirmação |
| `[INDEFINIDO]` | você não conseguiu supor, é decisão do usuário |

## O que escrever

Escreva `specs/<feature>/perfis.md` com o cabeçalho `**Status**: proposta · rodada 1` e as seções
abaixo.

### 1 · Inventário de atores

Tabela: **ator**, quem é (uma linha), interno ou externo, e a marca/tenant a que pertence quando
for o caso.

Pergunta que você MUST responder explicitamente, mesmo como `[SUPOSTO]`: além do usuário final,
existe **operação, suporte ou back-office**? Em produto da Suprema quase sempre existe, e é o
perfil mais esquecido. Não entregue perfis só do usuário final.

### 2 · O que cada ator pode

Para cada ator: **o que pode ver**, **o que pode fazer**, e **o que NÃO pode** (o limite é tão
importante quanto a capacidade). Em linguagem de negócio, não de permissão de sistema.

A tradução disso para o **formato da plataforma** (permissões `modulo.recurso.acao`, para o
catálogo SayPlus) é feita no passo 6 (desenho), não aqui. Este arquivo é a visão de negócio; a
matriz técnica de permissões deriva dele depois.

### 3 · Multi-marca e multi-tenant

O grupo opera marcas distintas (ULTRA Bet, Maxima Bet, Suprema Bet, OuroPix, Suprema Poker, entre
outras). Responda: um mesmo ator existe em mais de uma marca? Um ator vê mais de uma marca ao
mesmo tempo? O que muda de um ator para o equivalente em outra marca?

### 4 · Indefinições em aberto

Lista dos `[INDEFINIDO]`, cada um com quem responde.

## Fase de iteração e aprovação

Entregue um resumo (quantos atores, quantos `[SUPOSTO]` e `[INDEFINIDO]`, e as suposições de maior
consequência), faça **uma** pergunta sobre o que mudar, e itere em rodadas até a **aprovação
explícita**, que grava `**Status**: aprovado · rodada N · <AAAA-MM-DD>` no cabeçalho. Silêncio não
é aprovação.

## Ao terminar

1. Confirme o status gravado no arquivo.
2. Liste os `[INDEFINIDO]` e quem responde cada um.
3. Ofereça o passo seguinte: `/speckit-produto-historias`.

Escreva **apenas** `specs/<feature>/perfis.md`. Não toque em templates, scripts ou qualquer
arquivo do núcleo da ferramenta.
