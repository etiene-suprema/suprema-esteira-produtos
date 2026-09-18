# Extensão Produto (Suprema)

Acrescenta os passos 2, 3, 6, 7 e 8 da Trilha 1 da Esteira de Criação Suprema. Extensão interna,
não publicada em catálogo.

## Por que ela existe

O `spec.md` do spec-kit resolve bem o **o quê** e o **por quê**: requisitos numerados, critérios
de sucesso mensuráveis. O que ele não cobre são três coisas que alimentam a especificação e
sobrevivem a ela: **quem** usa o produto (perfis e atores), a **história de usuário** com padrão e
régua de prioridade, e o **produto concreto** (menus, telas, colunas, botões, estados, o que muda
por marca).

Sem isso, a história nasce sem dono, o PRD termina abstrato, e essas decisões acabam sendo tomadas
por quem implementa, tarde e sem quem responde pelo produto na sala.

## Os cinco comandos

| Comando | Artefato | O que faz |
|---|---|---|
| `/speckit-produto-perfis` | `specs/<feature>/perfis.md` | Lista os atores e o que cada um pode ver e fazer, incluindo operação, suporte e back-office. Vem **antes** da história |
| `/speckit-produto-historias` | `specs/<feature>/historias.md` | Escreve as histórias com formato único, critério de tamanho e régua de prioridade (o que é P1, quem decide, o que P1 obriga) |
| `/speckit-produto-desenho` | `specs/<feature>/desenho.md` | Propõe a superfície do produto em 12 seções e itera até a aprovação. Entrega também a **matriz de permissões** (formato SayPlus) e os **sinais de comportamento** |
| `/speckit-produto-mockup` | `specs/<feature>/mockup/index.html` (tela) · `validacao-contrato.md` (jogo) | Valida: mockup navegável + entrevista para tela; conferência do contrato de evento para jogo |
| `/speckit-produto-compilar` | `specs/<feature>/entregaveis/`, `specs/<feature>/PRD.md` | Compila em um arquivo autossuficiente por item, com **história e requisito de origem**, mais o PRD consolidado no formato Suprema |

### Os dois passos novos: perfis e histórias

`perfis` e `historias` são os passos 2 e 3, e correm **antes** de especificar. Existem porque
história sem ator é história sem dono, e história sem padrão contamina tudo o que vem depois:
especificação, desenho, itens e código herdam a qualidade do que sai daqui. A tabela de perfis,
que antes vivia dentro do desenho, **sai de lá** e nasce em `perfis.md`; o desenho passa a
consumi-la. As histórias ganham formato único, critério de tamanho e régua de prioridade.

Os dois seguem o mesmo método de proposta primeiro dos demais, com as marcas `[SUPOSTO]` e
`[INDEFINIDO]` e aprovação explícita gravada no cabeçalho.

### O método: proposta primeiro

O agente lê os artefatos anteriores, a constituição e a descoberta, e **escreve** uma proposta
completa. O usuário reage. Reagir a uma proposta concreta custa uma fração do que responder a
quarenta perguntas abertas.

Contra a ancoragem que isso poderia gerar, duas marcas obrigatórias:

| Marca | Significa |
|---|---|
| *(sem marca)* | rastreável a um artefato do disco |
| `[SUPOSTO]` | o agente deduziu, precisa de confirmação |
| `[INDEFINIDO]` | o agente não conseguiu supor, é decisão do usuário |

Na entrega, o agente resume: quantas telas, quantos `[SUPOSTO]`, quantos `[INDEFINIDO]`, e **as
três suposições de maior consequência** por extenso. O usuário varre as marcas em vez de reler
tudo.

Itera em rodadas (`**Status**: proposta · rodada N`) até a **aprovação explícita**, que grava
`**Status**: aprovado` no cabeçalho. Silêncio não é aprovação.

### Dois tipos de produto

O desenho (passo 6) decide o tipo antes de propor, porque ele troca o conjunto de seções:

| Tipo | Seções |
|---|---|
| **Interface** (web, app, back-office) | perfis e matriz de permissões, navegação, inventário de telas, detalhe por tela, fluxos, componentes, notificação, multi-marca, instrumentação, sinais de comportamento, conformidade |
| **Jogo** (slot, crash, mesa) | o jogo em uma página, **contrato de evento**, estados de rodada, regras de aposta, carteira, jogo responsável e auditoria, telas mínimas, instrumentação, sinais de comportamento |
| **Híbrido** | os dois, em blocos separados |

Em jogo, o entregável do upstream para tecnologia é o **contrato de evento**, não o menu. O
comando **não inventa taxonomia**: localiza o contrato vigente do RGS no repositório do jogo e
valida contra ele. Valor novo em enum fechado é mudança de contrato, sujeita à disciplina de
versão.

### O que o desenho cobre (tipo interface)

1. Perfis (consumidos de `perfis.md`) e a **matriz de permissões no formato da plataforma**
   (`modulo.recurso.acao`, pronta para o catálogo SayPlus)
2. Mapa de navegação, com qual perfil vê cada item
3. Inventário de telas numerado
4. Por tela: dados exibidos, ações e o que acontece depois delas, filtros e ordenação padrão,
   **estados de vazio e de erro** (obrigatórios), validações e mensagens
5. Fluxos entre telas para cada história P1, incluindo o caminho de erro
6. Componentes recorrentes que devem se comportar igual em toda tela
7. Comunicação e notificação, confrontadas com a constituição
8. Multi-marca e multi-tenant: o que muda entre ULTRA, Maxima, Suprema Bet e as demais
9. Instrumentação: que evento cada métrica do PRD exige, e em que tela
10. **Sinais de comportamento do produto** (notificação, dependência, volume, horário): fatos de
    negócio que viram evidência para a escolha da variante do archetype na Trilha 2
11. Fora de escopo visual
12. Conformidade com a constituição, princípio por princípio

### O que a validação entrega

Só roda com o desenho aprovado: a pré-condição é o `**Status**: aprovado` no cabeçalho. Validar
proposta que ainda vai mudar é desperdício.

**Para produto de tela:** arquivo único, HTML e CSS puros, sem dependência, publicável como
artefato e compartilhável. Cobre toda tela do inventário, com navegação clicável, seletor de
perfil, seletor de marca quando aplicável, e **todos os estados alcançáveis** por controle, não
apenas descritos.

**Para jogo:** não há mockup HTML. A validação é a **conferência do contrato de evento** contra o
contrato vigente do RGS (`validacao-contrato.md`), porque em jogo é o contrato, não o menu, que a
tecnologia consome.

Depois de entregar, conduz cinco blocos de entrevista: o que está errado, o que está faltando,
os perfis, o pior dia (estado vazio e erro), e **a ideia nova**. O último é o mais valioso e o
mais fácil de esquecer.

### O que a compilação resolve

A Trilha 1 produz raciocínio fragmentado por natureza, e isso é bom: cada artefato tem um
propósito e junto eles são a fonte de verdade. Mas a **unidade de execução** é o item, que viaja
sozinho para o backlog. Quem abre o card não tem os outros seis arquivos ao lado.

Duas saídas:

- **`entregaveis/<PREFIXO>-NN.md`**, um por item: **origem (história e requisito)**, contexto,
  requisito, critérios de aceite, métricas que move, recorte do desenho (telas, ações, estados,
  permissões), dependências, fora de escopo, fase. O campo de origem é o que faz a rastreabilidade
  não se perder entre a história e o item de backlog. A **granularidade** (um por requisito ou um
  por história) é decisão de processo pendente; até fechar, gera-se um por requisito com a origem
  preenchida
- **`PRD.md`**, consolidado no formato Suprema: produto em uma página, requisitos por
  subsistema, roadmap faseado com critério de saída por fase, riscos com mitigação, premissas

Três regras:

1. **Numeração por subsistema, não global.** `C-` cliente, `S-` servidor, `I-` integração, `A-`
   admin. O prefixo diz o dono e roteia o item para a sub-frente certa.
2. **Gerado, nunca editado à mão.** Mudança se faz na especificação ou no desenho, com
   regeração. Editar o compilado cria segunda fonte de verdade.
3. **PRD é só produto.** A parte técnica é apontada, não duplicada. Duplicar stack entre PRD e
   design técnico é a origem do drift.

Em produto de jogo, a compilação confronta **cada métrica** com o contrato de evento e responde
uma de três coisas: serve, é dimensão, ou falta stream. O terceiro caso é o achado caro.

## Guardas obrigatórias do mockup

- **Não é implementação.** Nada de `mockup/` entra no código de produção. O produto nasce do
  Archetype Backend NestJS na Trilha 3.
- **Não decide stack.** HTML e CSS puros. Escolher framework aqui seria decidir arquitetura num
  passo de produto.
- **Dado fictício sempre.** Proibido nome, documento, e-mail, telefone ou valor de pessoa real.
- **Faixa de aviso fixa no topo**, sempre visível.
- **Escopo que cresce é declarado**, nunca incorporado em silêncio.

## Hooks

Registrados automaticamente na instalação, ambos opcionais e com confirmação:

| Evento | Oferece | Momento na esteira |
|---|---|---|
| `before_specify` | `/speckit-produto-perfis` (prioridade 5) | antes de especificar, logo após a constituição |
| `before_specify` | `/speckit-produto-historias` (prioridade 10) | depois dos perfis, antes de especificar |
| `after_clarify` | `/speckit-produto-desenho` | logo depois de clarificar a spec |
| `before_checklist` | `/speckit-produto-mockup` (prioridade 5) | antes do portão de aceite |
| `before_checklist` | `/speckit-produto-compilar` (prioridade 10) | depois da validação, antes do aceite |

## Instalação

Extensão local, instalada com `--dev` apontando para esta pasta:

```bash
specify extension add "$ESTEIRA_DIR"/extension-produto --dev
```

Confirme que as cinco skills apareceram:

```bash
ls .claude/skills | grep produto
```

Devem aparecer `speckit-produto-perfis`, `speckit-produto-historias`, `speckit-produto-desenho`,
`speckit-produto-mockup` e `speckit-produto-compilar`. Com as três extensões da esteira instaladas
(`assess`, `bug`, `produto`), o projeto tem **23 skills**.

## Manutenção

Alteração nos prompts é alteração de processo: PR com justificativa, e versão em `extension.yml`
incrementada por versionamento semântico. Depois de alterar, reinstale com `--force` nos
projetos ativos, porque os arquivos de skill são copiados na instalação e não resolvidos em
tempo de execução.

---

**Versão** 1.3.0 · **Requer** Spec Kit >= 1.0.0 · **Rege** Trilha 1, passos 2, 3, 6, 7 e 8
