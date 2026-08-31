---
description: "Propõe a superfície do produto (perfis, navegação, telas, ações, filtros, estados, notificações, multi-marca, instrumentação) e itera com o usuário até a aprovação"
---

# Desenhar a superfície do produto

Produz `specs/<feature>/desenho.md`: o **produto concreto**, tela por tela. É o passo 4 da
Trilha 1 da Esteira de Criação Suprema.

A especificação diz **o que** o produto faz. Este passo diz **como a pessoa usa**: quais menus
existem, o que cada tela mostra, quais botões e filtros tem, o que acontece quando dá errado, e
o que muda por perfil e por marca.

**O método é proposta primeiro, não entrevista.** Você tem problema, conceito, decisão,
constituição e especificação no disco. Isso é material suficiente para propor um desenho
completo. Reagir a uma proposta concreta custa ao usuário uma fração do que responder a
quarenta perguntas abertas, e uma proposta errada revela mais que uma pergunta em branco.

**Este passo NÃO é técnico.** Nada de stack, banco, framework, endpoint, biblioteca de
componente ou arquitetura. Aqui se decide o que a pessoa vê e faz, não como se constrói.

## Entrada do usuário

```text
$ARGUMENTS
```

Considere a entrada antes de prosseguir, se não estiver vazia.

## Pré-condições

1. Rode `.specify/scripts/bash/check-prerequisites.sh --json` e leia os caminhos.
2. `spec.md` MUST existir. Se não existir, **pare** e diga que o passo 2 (`/speckit-specify`)
   ainda não aconteceu.
3. Leia **inteiros**, sem pular: `spec.md`, `.specify/memory/constitution.md`, e todos os
   artefatos de `.specify/assessments/<slug>/` que existirem (`problem.md`, `concept.md`,
   `decision.md`).
4. Se `spec.md` ainda tem marcação de indefinição pendente, avise e pergunte se o usuário quer
   clarificar primeiro.
5. Se `desenho.md` já existe e está aprovado, trate como revisão: mostre o que vai mudar antes
   de mudar.

## As duas marcas, e por que elas existem

Proposta sem marcação de origem produz ancoragem: o usuário aceita o enquadramento do agente e
o que o agente não pensou nunca aparece. As marcas resolvem isso.

| Marca | Significa | O usuário faz o quê |
|---|---|---|
| *(sem marca)* | rastreável a um artefato do disco | confia, ou corrige se o artefato estiver errado |
| `[SUPOSTO]` | **você** deduziu, não está escrito em nenhum artefato | confirma ou corrige |
| `[INDEFINIDO]` | você não conseguiu nem supor com segurança | decide |

Regras das marcas, sem exceção:

- Toda afirmação **sem marca** MUST ser rastreável a `spec.md`, à constituição ou aos artefatos
  de descoberta. Se você não consegue apontar de onde tirou, é `[SUPOSTO]`.
- **Nunca** apresente suposição como fato. É o erro mais caro deste passo: o usuário aprova sem
  perceber que decidiu algo.
- `[SUPOSTO]` é bom e esperado. Um desenho maduro tem muitos, e o valor está em o usuário poder
  varrer só eles.
- Onde a constituição já decidir, cite o princípio em vez de supor.

## Fase A · Propor

Escreva `specs/<feature>/desenho.md` completo, com **todas** as 11 seções abaixo. Nenhuma seção
é omitida: seção sem base recebe `[INDEFINIDO]`.

O cabeçalho do arquivo MUST conter, nesta forma exata, porque o passo seguinte depende dele:

```text
**Status**: proposta · rodada 1
```

### 1 · Perfis e permissões

Tabela: perfil, quem é, o que pode ver, o que pode fazer, o que **não** pode.

Pergunta que você MUST responder explicitamente, mesmo que como `[SUPOSTO]`: existe perfil de
**operação, suporte ou back-office** além do usuário final? Em produto da Suprema quase sempre
existe, e é o mais esquecido na especificação.

### 2 · Mapa de navegação

Árvore em texto do menu completo, marcando qual perfil vê cada item e qual é a tela inicial de
cada perfil.

```text
Menu principal
├── Painel                      [todos]            ← inicial de operador
├── Campanhas                   [gestor, operador]
│   ├── Lista de campanhas
│   ├── Nova campanha
│   └── Detalhe da campanha
└── Configurações               [gestor]
```

### 3 · Inventário de telas

Tabela numerada `T-001`, `T-002`, com: id, nome, objetivo em uma linha, perfis com acesso, e
tipo (lista, detalhe, formulário, painel, fluxo).

### 4 · Detalhe de cada tela

Para **cada** tela do inventário:

- **Objetivo**: a pergunta que a pessoa responde nessa tela
- **Dados exibidos**: cada campo ou coluna, em linguagem de negócio
- **Ações**: cada botão ou controle, o que faz, e o que acontece **depois** dele
- **Filtros e ordenações**: quais existem, e qual é o padrão ao abrir
- **Estados**: vazio, carregando, erro, sem permissão, volume alto. O que a pessoa vê em cada
- **Validações**: o que é impedido, e a mensagem que a pessoa lê
- **Navegação**: de onde se chega, para onde se vai

Estado vazio e estado de erro são **obrigatórios** em toda tela. Definem se o produto é usável
no primeiro dia e no pior dia, e são os que ninguém especifica.

### 5 · Fluxos principais

Para cada história de prioridade P1 da especificação, o passo a passo entre telas, do início ao
resultado, **incluindo o caminho quando dá errado**.

### 6 · Componentes recorrentes

O que se repete entre telas e deve se comportar igual em todas: tabela com paginação, filtro de
período, modal de confirmação, seletor de marca, indicador de estado. Comportamento esperado,
não implementação.

### 7 · Comunicação e notificação

O que o produto avisa, para quem, por qual canal, em que momento, e o que a pessoa desliga.
Confronte com a constituição: princípio de consentimento ou de janela de envio vale aqui.

### 8 · Multi-marca e multi-tenant

Obrigatório em produto da Suprema. O grupo opera marcas distintas (ULTRA Bet, Maxima Bet,
Suprema Bet, OuroPix, Suprema Poker, entre outras). Responda:

- O produto atende mais de uma marca?
- O que muda por marca: dado, regra, visual, permissão, catálogo?
- O que é compartilhado?
- Que tela precisa de seletor de marca? Alguém vê mais de uma ao mesmo tempo?

### 9 · Instrumentação

Para cada critério de sucesso mensurável da especificação, que evento precisa ser capturado, em
qual tela, em qual ação. **Métrica sem evento correspondente não é medível**, e isso se descobre
aqui, não depois do lançamento.

### 10 · Fora de escopo visual

O que deliberadamente **não** tem tela nesta versão, e por quê. Espelha as não-metas da
descoberta.

### 11 · Conformidade com a constituição

Princípio por princípio da constituição do domínio: **conforme**, ou a tela ou ação que
conflita. Desenho que viola a constituição e não declara o conflito não é entregue como pronto.

## Fase B · Entregar a proposta

**Não despeje o arquivo no chat.** Entregue um resumo que permita ao usuário decidir onde olhar:

1. Quantas telas foram inventariadas, e a lista dos ids com o nome
2. Quantos `[SUPOSTO]` e quantos `[INDEFINIDO]`, e **em quais seções eles se concentram**
3. As **três suposições de maior consequência**, escritas por extenso. São as que, se estiverem
   erradas, mudam o desenho todo. Diga por que cada uma importa
4. A lista numerada dos `[INDEFINIDO]`, que são as decisões que só o usuário pode tomar
5. O caminho do arquivo, para ele ler na íntegra

Depois disso, faça **uma** pergunta: o que ele quer mudar. Nada mais. Não faça bateria de
perguntas nesta fase.

## Fase C · Iterar

O usuário vai apontar por número ou por seção ("muda a 3, a 7 e a 12", "a tela de campanhas
está errada"). A cada rodada:

1. Aplique **exatamente** o que foi pedido. Não aproveite a rodada para mudar o que não foi
   apontado
2. Se um pedido tiver consequência em outra parte do desenho, **diga** antes de aplicar, e
   pergunte se aplica também
3. Incremente a rodada no cabeçalho: `**Status**: proposta · rodada 2`
4. Relate o que mudou em lista curta, e quantos `[SUPOSTO]` e `[INDEFINIDO]` restam
5. Se o usuário responder um `[INDEFINIDO]`, remova a marca e incorpore a resposta
6. Se o usuário responder algo que contradiz `spec.md`, **aponte a contradição e pergunte qual
   dos dois está certo**. Não corrija `spec.md` por conta própria

Continue até o usuário aprovar. Não force convergência: quantas rodadas forem necessárias.

## Fase D · Aprovar

Aprovação MUST ser **explícita**. Não interprete silêncio, "tá bom" ambíguo ou ausência de
crítica como aprovação. Se restar dúvida, pergunte: "posso marcar o desenho como aprovado?"

Quando o usuário aprovar, troque o cabeçalho para:

```text
**Status**: aprovado · rodada N · <AAAA-MM-DD>
```

Se ainda houver `[INDEFINIDO]` na aprovação, isso é permitido, mas MUST ser registrado logo
abaixo do status, como lista de pendências com quem responde cada item. Aprovar com pendência
conhecida é decisão; aprovar sem saber que existe pendência é acidente.

Só depois do status `aprovado` ofereça o passo seguinte: `/speckit-produto-mockup`. O mockup
não roda sobre proposta não aprovada, porque mockar desenho que vai mudar é desperdício.

## Ao terminar

1. Confirme o status gravado no arquivo
2. Liste as pendências que sobraram e quem responde cada uma
3. Ofereça `/speckit-produto-mockup`

Escreva **apenas** `specs/<feature>/desenho.md`. Não toque em `spec.md`, em templates, em
scripts ou em qualquer arquivo do núcleo da ferramenta.
