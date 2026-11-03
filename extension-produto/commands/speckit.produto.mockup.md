---
description: "Gera um mockup HTML navegável do desenho e conduz a entrevista de validação, devolvendo o que emergir para a especificação"
---

# Validar (mockup navegável, ou conferência de contrato)

É o passo 7 da Trilha 1 da Esteira de Criação Suprema, e a validação tem **duas formas conforme o
tipo de produto** declarado no desenho:

- **Interface** (web, app, back-office): produz `specs/<feature>/mockup/index.html`, um mockup
  **navegável e descartável**, e conduz a entrevista. É o corpo deste comando.
- **Jogo**: **não há mockup HTML**. A validação é a **conferência do contrato de evento** contra o
  contrato vigente do RGS. Ver a seção "Produto de jogo" mais abaixo. É o entregável que a
  tecnologia consome, e por isso ele, não a tela, é o que se valida.

Para produto de interface, o mockup existe por dois motivos, nesta ordem:

1. **Provar entendimento.** Ver a tela revela divergência que o texto esconde. Se o mockup
   estiver errado, o desenho estava errado, e é mais barato descobrir agora.
2. **Gerar ideia.** Quem desenha um produto pensa em coisa nova ao ver a tela. Este passo captura
   isso e devolve para os artefatos, em vez de deixar virar pedido solto depois.

## Entrada do usuário

```text
$ARGUMENTS
```

Considere a entrada antes de prosseguir, se não estiver vazia.

## O que este mockup NÃO é

Escreva estas regras no topo do arquivo gerado, como comentário, e obedeça a todas:

- **Não é implementação.** Nada em `mockup/` é aproveitado no código de produção. Quando a
  Trilha 3 acontecer, o produto é construído a partir do Archetype Backend NestJS da Suprema, e
  este mockup é descartado.
- **Não decide stack.** HTML e CSS puros, sem framework, sem biblioteca, sem build. Se você
  escolher React, Tailwind ou qualquer dependência aqui, estará decidindo arquitetura num passo
  de produto, o que é proibido pela esteira. Isso vale também com o design system SayPlus: os
  componentes dele são referência visual, recriados em HTML e CSS, nunca importados.
- **Não usa dado real.** Todo dado é fictício e obviamente fictício. É proibido usar nome, CPF,
  e-mail, telefone ou valor de pessoa real, ainda que de teste.
- **Não é protótipo funcional.** Nada persiste, nada calcula de verdade, nada chama serviço.

## Pré-condições

1. Rode `.specify/scripts/bash/check-prerequisites.sh --json` e leia os caminhos.
2. `spec.md` e `desenho.md` MUST existir. Se `desenho.md` não existir, **pare** e diga que o
   passo 6 (`/speckit-produto-desenho`) ainda não aconteceu. Sem ele não há o que mockar.
3. `desenho.md` MUST estar com `**Status**: aprovado` no cabeçalho. Se estiver como `proposta`,
   **pare** e diga que o desenho ainda está em iteração: mockar proposta que vai mudar é
   desperdício de trabalho seu e de atenção do usuário. Volte para `/speckit-produto-desenho`.
4. Leia `spec.md`, `desenho.md` e `.specify/memory/constitution.md` inteiros.
5. Leia o `**Hospedeiro**` no cabeçalho do `desenho.md`. Se for **SayPlus**, siga a seção
   "Hospedeiro SayPlus: design system obrigatório" abaixo. Se o campo não existir (desenho
   anterior a esta regra), **pergunte** se o produto será acoplado à SayPlus e registre a
   resposta no cabeçalho do `desenho.md` antes de mockar.
6. Se `desenho.md` foi aprovado com pendências registradas, mocke as telas mesmo assim e
   **marque visualmente** cada ponto pendente na interface (ver abaixo). Pendência que aparece
   na tela é pendência que alguém resolve.

## O que construir

Um **único arquivo** `specs/<feature>/mockup/index.html`, autossuficiente, com CSS embutido e o
mínimo de JavaScript necessário para navegar entre telas.

Arquivo único e sem dependência externa é requisito, não preferência: é o que permite publicar
como artefato e compartilhar com o time sem servidor. A única exceção é a fonte e os ícones do
design system SayPlus, quando o hospedeiro for SayPlus (ver seção própria).

### Cobertura obrigatória

- **Toda tela** do inventário do `desenho.md`, na navegação da seção 2
- **Navegação real e clicável** entre as telas, refletindo o mapa desenhado
- **Um seletor de perfil** no topo, que troca o que está visível conforme as permissões da
  seção 1. É a forma mais rápida de a pessoa conferir se as permissões fazem sentido
- **Os estados de cada tela** alcançáveis: além do estado normal, um controle que mostra vazio,
  carregando, erro e sem permissão. Não deixe estado só descrito em texto
- **Filtros e ordenações** presentes como controle visível, mesmo sem funcionar de verdade
- **Todos os botões** da seção 4, cada um com o resultado indicado (navega para outra tela, abre
  confirmação, ou mostra a mensagem de retorno)
- **Seletor de marca**, se a seção 8 disse que o produto é multi-marca

### Marcações visuais obrigatórias

- **Faixa fixa no topo**, sempre visível: `MOCKUP DE VALIDAÇÃO — não é o produto, dados
  fictícios`, mais o nome da feature
- **Todo ponto indefinido** com marca destacada e o texto da pergunta em aberto, para a pessoa
  ver na tela o que ainda falta decidir
- **Legenda ao pé**, listando o que está mockado e o que ficou de fora

### Qualidade visual

Sóbrio e legível, não bonito (com hospedeiro SayPlus, o visual é o do design system, ver
seção abaixo). O objetivo é conferir estrutura, hierarquia e completude, não
aprovar identidade visual. Cuidado específico: use dado fictício **plausível e brasileiro** nas
tabelas e listas, porque dado genérico esconde problema de layout que dado real revela (nome
comprido, valor grande, texto que estoura a coluna). Inclua ao menos uma linha com valor
extremo em cada tabela.

Deve funcionar em tela de celular e de desktop, porque em vários produtos da Suprema a operação
usa desktop e o usuário final usa celular, e isso muda o desenho.

## Hospedeiro SayPlus: design system obrigatório

Se o `desenho.md` diz `**Hospedeiro**: SayPlus`, o mockup é desenhado **com o design system
SayPlus**, e não no estilo neutro. O motivo é de produto: a pessoa valida como a tela vai ficar
dentro do backoffice que o time já usa, e o que o DS não cobre aparece agora, não na Trilha 3.

**Fonte única:** o projeto "SayPlus sistema de componentes", em
`https://claude.ai/artifact/2D7bqjuHS5BSji4tsuQdyx`. Leia os arquivos dele com a ferramenta de
artefatos (leitura por caminho), nesta ordem:

| Arquivo no DS | Para quê |
|---|---|
| `project/readme.md` | regras de conteúdo e fundamentos visuais (leia inteiro) |
| `project/tokens/colors.css`, `typography.css`, `spacing.css`, `radius.css`, `base.css` | os tokens, copiados **literalmente** para o `<style>` do mockup |
| `project/components/<grupo>/*.card.html` e `*.prompt.md` | aparência e estados de cada componente usado |
| `project/ui_kits/backoffice/` (`AppShell.jsx` e telas) | o casco do backoffice: sidebar, header, cabeçalho de página |
| `project/Menu com submenus.dc.html` | o menu lateral de 3 níveis |

Se o DS não puder ser lido (sem a ferramenta de artefatos, sem acesso, link fora do ar),
**pare** e peça à pessoa acesso ou uma exportação dos tokens. Nunca invente cor, fonte ou medida
"parecida com a SayPlus", e nunca caia para o estilo neutro sem avisar.

**Como aplicar:**

- **Tokens copiados, não importados.** Cole as variáveis CSS do DS no `<style>` do arquivo,
  com tema claro em `:root` e escuro em `.dark`, e um botão de tema no header. O mockup continua
  arquivo único.
- **Duas dependências externas permitidas, e só elas:** a fonte IBM Plex (Google Fonts, como no
  `tokens/fonts.css`) e os ícones `lucide-static@0.460.0` (versão pinada do DS). Nada de React,
  Tailwind ou dos `.jsx` do DS: eles são referência visual, recriados em HTML e CSS.
- **Casco do backoffice:** sidebar fixa de 232px com o menu de 3 níveis, header de 56px, ação
  principal à direita do cabeçalho de página, filtros acima da tabela. As telas do produto
  entram como páginas do módulo no menu, onde o `desenho.md` posicionou.
- **Componentes do DS** para tudo que o DS cobre, conforme o mapeamento da seção 6 do
  `desenho.md`: Table, Pagination, Dialog, ConfirmDialog, campos, Badge, KpiCard, EmptyState,
  Skeleton, Toast, Alert, Tabs, PageHeader.
- **Regras de conteúdo do DS:** caixa de frase, sem travessão, botão com verbo e objeto,
  confirmação com título em pergunta, números e datas em pt-BR.
- **Componente fora do DS:** quando uma tela precisa de algo que o DS não tem, desenhe o mínimo
  com os tokens e marque na tela com o selo `fora do DS`. Cada um entra na legenda do pé e volta
  como pendência de design para a seção 6 do `desenho.md`. Não estenda o DS neste passo.
- **Escopo do DS é desktop.** Se o `desenho.md` prevê uso no celular, mocke o celular com os
  mesmos tokens e marque como `fora do DS (mobile ainda não desenhado)`.

As outras regras deste comando não mudam: faixa de aviso no topo, dado fictício, seletor de
perfil, estados alcançáveis, marcação de indefinição. Usar o DS deixa o mockup parecido com o
produto real, e por isso a faixa de aviso é ainda mais necessária.

## Publicação

Depois de escrever o arquivo, **publique como artefato** para a pessoa poder abrir e
compartilhar com o time. Informe o link.

Se a publicação não estiver disponível no ambiente, informe o caminho local do arquivo e como
abrir no navegador.

## Produto de jogo: conferência do contrato de evento

Se o tipo declarado no `desenho.md` for **Jogo**, pule a construção do HTML acima. A validação é
documental e confronta o contrato de evento do desenho (seção J2) com o **contrato vigente do
RGS** (`spin_event.v1` em `TECH_DESIGN.md` §4, schema em `DATA_SPEC-analytics.md`). Localize esses
arquivos no repositório do jogo; se não achar, **pergunte o caminho**, nunca invente campo.

Produza `specs/<feature>/validacao-contrato.md` respondendo:

- **Cada evento e campo do desenho existe no contrato vigente?** Aponte o que casa e o que diverge.
- **Há valor novo em enum fechado** (`action`, `feature_type`, `reject_reason`)? Se sim, é
  **mudança de contrato**, sujeita à disciplina de versão: se o `v1` já emitiu em produção, vira
  `v2`.
- **Cada métrica do `spec.md` é servida pelo contrato?** Uma de três respostas por métrica: serve
  (aponte o campo), é dimensão (onde vive, join por qual chave), ou falta stream (o achado caro).

A entrevista abaixo, adaptada, também vale para jogo: troque "telas" por "eventos e métricas". O
bloco 5 (a ideia nova) continua obrigatório.

> **[A DEFINIR] — decisão de processo pendente:** o anexo de arquitetura registra que a validação
> por contrato precisa do **aval de quem responde pelo contrato de evento**. Enquanto esse dono não
> for nomeado, registre a conferência mesmo assim e marque o aprovador como `[INDEFINIDO]`.

## A entrevista de validação

Este é o coração do passo. Depois de entregar o mockup (interface) ou a conferência de contrato
(jogo), conduza a conversa nesta ordem, em blocos, esperando resposta a cada bloco:

**Bloco 1 — o que está errado.**
"Alguma tela não é o que você quis dizer? Alguma coluna, botão ou filtro está sobrando ou
faltando?"

**Bloco 2 — o que está faltando.**
"Olhando as telas juntas, falta alguma etapa entre elas? Existe algo que você faria nesse
produto e não tem onde fazer?"

**Bloco 3 — os perfis.**
"Troque o perfil no seletor. Alguém está vendo algo que não deveria, ou não está vendo algo de
que precisa?"

**Bloco 4 — o pior dia.**
"Olhe os estados de erro e de vazio. No primeiro dia, sem nenhum dado, esse produto é usável?
Quando o serviço externo cair, a pessoa entende o que fazer?"

**Bloco 5 — a ideia nova.**
"O que você pensou vendo isso que não estava na especificação?"

O bloco 5 é o mais valioso e o mais fácil de esquecer. Pergunte sempre, mesmo que os quatro
anteriores tenham vindo limpos.

## O retorno para os artefatos

Tudo que emergir na entrevista precisa **voltar para os artefatos**, senão o passo não serviu
para nada. Classifique cada ponto e trate assim:

| Tipo do ponto | Vai para |
|---|---|
| Tela, botão, filtro, estado, permissão | `desenho.md` |
| Requisito, regra, história, critério de sucesso novo | `spec.md`, **avisando explicitamente** |
| Escopo que cresceu além do que foi decidido | proponha registrar como não-meta ou como iniciativa separada, **não** incorpore em silêncio |
| Restrição de domínio, risco ou regulatório | proponha emenda à constituição do serviço |
| Decisão que é de tecnologia | anote como pendência para a Trilha 3, **não decida agora** |

Ao alterar `spec.md`, diga em uma linha o que mudou e por quê. Esses arquivos são fonte de
verdade versionada, não rascunho.

Se o escopo cresceu de forma relevante, **diga isso na cara**: "isso não é ajuste, é escopo
novo, e a decisão de incluir é de quem assina o portão". Mockup é o momento em que escopo cresce
sem ninguém perceber.

## Iteração

Se a entrevista mudou o desenho, atualize `desenho.md`, **regere o mockup** e rode a entrevista
de novo, mais curta, só nos pontos alterados. Repita até a pessoa dizer que o mockup representa
o produto que ela quer.

Só então ofereça o passo seguinte: `/speckit-produto-compilar` (passo 8), que gera os itens de
entrega e o PRD antes do portão de aceite.

## Ao terminar

1. Diga quantas telas foram mockadas e quantas ficaram com indefinição visível. Com hospedeiro
   SayPlus, diga também quantos componentes ficaram `fora do DS` e quais.
2. Liste o que voltou para `desenho.md`, o que voltou para `spec.md` e o que ficou pendente.
3. Informe o link do mockup publicado.
4. Lembre que o mockup é descartável e que a construção acontece a partir do archetype, na
   Trilha 3.

Escreva **apenas** dentro de `specs/<feature>/`. Não toque em templates, scripts ou qualquer
arquivo do núcleo da ferramenta.
