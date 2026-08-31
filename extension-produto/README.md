# Extensão Produto (Suprema)

Acrescenta os passos 4 e 5 da Trilha 1 da Esteira de Criação Suprema. Extensão interna, não
publicada em catálogo.

## Por que ela existe

O `spec.md` do spec-kit resolve bem o **o quê** e o **por quê**: histórias priorizadas,
requisitos numerados, critérios de sucesso mensuráveis. O que ele não cobre é o **produto
concreto**: quais menus existem, o que cada tela mostra, quais colunas, botões e filtros tem, o
que aparece quando não há dado nenhum, o que aparece quando dá erro, o que cada perfil pode
fazer, e o que muda por marca.

Sem isso, o PRD termina abstrato e essas decisões acabam sendo tomadas por quem implementa,
tarde e sem quem responde pelo produto na sala.

## Os dois comandos

| Comando | Artefato | O que faz |
|---|---|---|
| `/speckit-produto-desenho` | `specs/<feature>/desenho.md` | Propõe a superfície completa do produto em 11 seções e itera em rodadas até a aprovação explícita |
| `/speckit-produto-mockup` | `specs/<feature>/mockup/index.html` | Gera um mockup navegável, conduz a entrevista de validação e devolve o que emergir para `desenho.md` e `spec.md` |

### O método: proposta primeiro

O agente lê `spec.md`, a constituição e os artefatos da Trilha 0, e **escreve** um desenho
completo. O usuário reage. Reagir a uma proposta concreta custa uma fração do que responder a
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

### O que o desenho cobre

1. Perfis e permissões, incluindo o perfil de operação ou back-office, que é o mais esquecido
2. Mapa de navegação, com qual perfil vê cada item
3. Inventário de telas numerado
4. Por tela: dados exibidos, ações e o que acontece depois delas, filtros e ordenação padrão,
   **estados de vazio e de erro** (obrigatórios), validações e mensagens
5. Fluxos entre telas para cada história P1, incluindo o caminho de erro
6. Componentes recorrentes que devem se comportar igual em toda tela
7. Comunicação e notificação, confrontadas com a constituição
8. Multi-marca e multi-tenant: o que muda entre ULTRA, Maxima, Suprema Bet e as demais
9. Instrumentação: que evento cada métrica do PRD exige, e em que tela
10. Fora de escopo visual
11. Indefinições em aberto, com quem responde cada uma

### O que o mockup entrega

Só roda com o desenho aprovado: a pré-condição é o `**Status**: aprovado` no cabeçalho. Mockar
proposta que ainda vai mudar é desperdício.

Arquivo único, HTML e CSS puros, sem dependência, publicável como artefato e compartilhável.
Cobre toda tela do inventário, com navegação clicável, seletor de perfil, seletor de marca
quando aplicável, e **todos os estados alcançáveis** por controle, não apenas descritos.

Depois de entregar, conduz cinco blocos de entrevista: o que está errado, o que está faltando,
os perfis, o pior dia (estado vazio e erro), e **a ideia nova**. O último é o mais valioso e o
mais fácil de esquecer.

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
| `after_clarify` | `/speckit-produto-desenho` | logo depois de clarificar a spec |
| `before_checklist` | `/speckit-produto-mockup` | antes do portão de aceite |

## Instalação

Extensão local, instalada com `--dev` apontando para esta pasta:

```bash
specify extension add "$ESTEIRA_DIR"/extension-produto --dev
```

Confirme que as duas skills apareceram:

```bash
ls .claude/skills | grep produto
```

Devem aparecer `speckit-produto-desenho` e `speckit-produto-mockup`. Com as três extensões da
esteira instaladas (`assess`, `bug`, `produto`), o projeto tem **20 skills**.

## Manutenção

Alteração nos prompts é alteração de processo: PR com justificativa, e versão em `extension.yml`
incrementada por versionamento semântico. Depois de alterar, reinstale com `--force` nos
projetos ativos, porque os arquivos de skill são copiados na instalação e não resolvidos em
tempo de execução.

---

**Versão** 1.1.0 · **Requer** Spec Kit >= 1.0.0 · **Rege** Trilha 1, passos 4 e 5
