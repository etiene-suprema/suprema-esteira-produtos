# Esteira de Criação Suprema — comece aqui

Este é o caminho pelo qual produto nasce na Suprema. Não há caminho paralelo: serviço não
nasce de um jeito diferente por time, por pressa ou por preferência.

**Se você veio para escrever um PRD, seu ponto de partida é
[`PROMPT-NOVO-PRD.md`](./PROMPT-NOVO-PRD.md).** Copie o prompt, preencha três campos, cole na
sessão do agente. O resto desta página é o mapa, para você entender onde está.

---

## O que existe nesta pasta

| Arquivo | Para quê |
|---|---|
| **`PROMPT-NOVO-PRD.md`** | o prompt que inicia um PRD novo. É por aqui que você começa |
| `ESTEIRA.md` | a esteira completa: trilhas, passos, critérios de pulo, regras de bloqueio. Vira o `CLAUDE.md` de cada projeto novo |
| `CONSTITUICAO-ENGENHARIA.md` | os 9 princípios de engenharia que valem para todo serviço do grupo |
| `extension-produto/` | a extensão da Suprema que entrega os passos 7, 8, 11, 12 e 13 (perfis, histórias, desenho, validar, compilar). Instalada no bootstrap, não precisa ser aberta |

---

## As cinco trilhas

```
TRILHA 0 · Descoberta      por ideia            produto + operações
TRILHA 1 · Definição       por iniciativa       produto + operações
   ───────── aqui produto entrega para tecnologia ─────────
TRILHA 2 · Nascimento      uma vez por serviço  tecnologia (local, sem SRE)
TRILHA 3 · Construção      por feature          tecnologia
TRILHA 4 · Entrega e Sustentação  contínuo      time do serviço + SRE
```

**Se o seu trabalho é PRD, você opera nas Trilhas 0 e 1 e para na fronteira.** As Trilhas 2 e 3
são de tecnologia e acontecem em outra sessão, depois.

### Trilha 0 · Descoberta

Responde uma pergunta: **vale construir isso?** A maioria das ideias deve morrer aqui, e
matar ideia com motivo escrito é resultado, não fracasso.

| # | Passo | Comando | Artefato |
|---|---|---|---|
| 1 | Captar | `/speckit-assess-intake` | `intake.md` |
| 2 | Pesquisar | `/speckit-assess-research` | `research.md` |
| 3 | Definir o problema | `/speckit-assess-define` | `problem.md` |
| 4 | Modelar opções | `/speckit-assess-shape` | `concept.md` |
| 5 | **Portão: decidir** | `/speckit-assess-decide` | `decision.md` |

O portão pontua sempre pelos mesmos quatro critérios: **impacto, esforço, risco regulatório,
reversibilidade**. Quem propôs a ideia não assina o veredicto sozinho.

### Trilha 1 · Definição do produto

A Trilha 1 tem **nove passos**: dois novos (perfis e atores, e histórias) e quatro ampliados
(desenho, validar, compilar e o portão). Nenhuma trilha foi criada ou reordenada.

| # | Passo | Comando | Artefato |
|---|---|---|---|
| 6 | **Constituição do domínio** | `/speckit-constitution` | `constitution.md` |
| 7 | **Perfis e atores** · novo | `/speckit-produto-perfis` | `perfis.md` |
| 8 | **Histórias** · novo | `/speckit-produto-historias` | `historias.md` |
| 9 | Especificar | `/speckit-specify` | `spec.md` |
| 10 | Clarificar | `/speckit-clarify` | `spec.md` atualizado |
| 11 | **Desenho da superfície** · ampliado | `/speckit-produto-desenho` | `desenho.md` |
| 12 | **Validar** · ampliado | `/speckit-produto-mockup` (tela) · conferência de contrato (jogo) | `mockup/index.html` ou nota de conferência |
| 13 | **Compilar a entrega** · ampliado | `/speckit-produto-compilar` | `entregaveis/`, `PRD.md` |
| 14 | **Portão: checklist e aceite** · ampliado | `/speckit-checklist` | `checklists/` |

A constituição vem **antes** de tudo. Ela carrega as restrições de domínio, risco e regulatório.
Especificar sobre régua que ainda não existe produz requisito que nasce ilegal, e a violação só
aparece semanas depois, com o PRD já aprovado.

Os passos 7 e 8 são os **dois novos**, e são o ponto mais estreito da esteira. **Perfis e atores**
lista quem usa o produto e o que cada um pode ver e fazer, incluindo operação, suporte e
back-office, os perfis sempre esquecidos; vem antes da história porque história sem ator é
história sem dono, e a tabela de perfis **sai do desenho** para nascer aqui. **Histórias** é onde
a história de usuário nasce, com formato único, critério de tamanho e régua de prioridade: o que
faz algo ser P1, quem decide, e o que P1 obriga adiante.

Os passos 11 e 12 são o **produto concreto**. A especificação (passo 9) diz o que o produto faz; o
desenho (passo 11) diz como a pessoa usa, tela por tela: quais menus existem, o que cada tela
mostra, quais botões e filtros tem, o que aparece quando não há dado, o que aparece no erro, o que
muda por marca, e que evento precisa ser medido para as métricas do PRD serem verificáveis. O
desenho passa a entregar também a **matriz de permissões no formato da plataforma** (permissões
`modulo.recurso.acao` prontas para o catálogo SayPlus) e uma lista de **sinais de comportamento**
do produto (avisa por notificação, depende de outro sistema, tem volume alto, roda em horário),
que são fatos de negócio e servem de evidência para a escolha do archetype na Trilha 2.

**Você não responde a um questionário.** O agente lê os artefatos e escreve uma proposta completa;
você lê e redireciona. Ele é obrigado a marcar `[SUPOSTO]` em tudo que deduziu e `[INDEFINIDO]` no
que não soube supor, então você varre as marcas em vez de reler o documento inteiro. Itera em
rodadas até você aprovar de forma explícita.

O passo 12 (**validar**) prova o entendimento e gera ideia nova. Para produto de tela, gera um
**mockup navegável** e conduz uma entrevista sobre ele: confirmar que o entendimento está certo
(ver a tela revela divergência que o texto esconde) e **gerar ideia nova** (quem vê a tela pensa
em coisa que não estava escrita). O que sair volta para o `desenho.md` e para o `spec.md`. Para
**jogo**, o equivalente é a **conferência do contrato de evento** contra o que já está valendo,
porque em jogo o entregável para tecnologia é o contrato, não o menu. O mockup é **descartável**:
HTML puro, dado fictício, faixa de aviso no topo, nunca aproveitado no código, que nasce do
archetype na Trilha 3.

O passo 13 resolve a **fragmentação**. Os artefatos anteriores são o raciocínio; a unidade de
execução é o **item de entrega**, que viaja sozinho para o backlog. A compilação gera um arquivo
autossuficiente por item, com contexto, requisito, **a história e o requisito de origem**,
critérios de aceite, métricas, recorte do desenho, dependências e fase, mais o PRD consolidado.
**Os dois são gerados, nunca editados à mão**: para mudar, muda-se a especificação ou o desenho e
roda o comando de novo.

O passo 14 é o **portão de fronteira**, com **quatro assinaturas** (produto, operações, tech lead e
segurança quando toca dinheiro, identidade ou comunicação com apostador). Depois dele, **pare**. A
fronteira com tecnologia é esse portão.

---

## Onde cada parte do PRD acaba

Não existe um arquivo único chamado PRD. Ele fica distribuído, e cada parte tem o seu lugar:

| Seção de um PRD | Arquivo |
|---|---|
| Contexto e origem da demanda | `intake.md` |
| Evidência, mercado, o que já existe | `research.md` |
| Problema, quem sofre, custo de não fazer nada | `problem.md` |
| Metas e **não-metas** | `problem.md` |
| Métricas de negócio | `problem.md` |
| Alternativas e trade-offs | `concept.md` |
| Escopo e apetite | `concept.md` |
| Decisão e justificativa | `decision.md` |
| Restrições de domínio e regulatórias | `constitution.md` |
| Perfis, atores e o que cada um pode ver e fazer | `perfis.md` |
| Histórias de usuário, formato e régua de prioridade | `historias.md` |
| Requisitos funcionais numerados | `spec.md` |
| Critérios de aceite | `spec.md` |
| Critérios de sucesso mensuráveis | `spec.md` |
| Casos de borda e premissas | `spec.md` |
| Menus e navegação | `desenho.md` |
| Telas, colunas, botões, filtros | `desenho.md` |
| Estados de erro, vazio e sem permissão | `desenho.md` |
| Fluxos entre telas | `desenho.md` |
| Notificações e comunicação | `desenho.md` |
| O que muda por marca | `desenho.md` |
| Eventos a instrumentar | `desenho.md` |
| Matriz de permissões (formato SayPlus) | `desenho.md` |
| Sinais de comportamento do produto (evidência da variante) | `desenho.md` |
| Protótipo visual para validação | `mockup/index.html` |
| Contrato de evento (produto de jogo) | `desenho.md` |
| Item pronto para o backlog | `entregaveis/<PREFIXO>-NN.md` |
| História e requisito de origem do item | `entregaveis/<PREFIXO>-NN.md` |
| PRD consolidado, para circular | `PRD.md` |

Todos ficam versionados no repositório de produto do serviço (o `<serviço>-prod`). O código
vem depois, na Trilha 3, em repositórios de domínio separados (`<serviço>-api` para o back,
`<serviço>-web` para o front). É esse conjunto de artefatos que faz o PRD continuar achável e
verdadeiro seis meses depois.

---

## Oito coisas que fazem diferença na prática

1. **Os comandos têm hífen**, não ponto: `/speckit-specify`.
2. **Nunca rode um comando pelado.** Sem argumento, o agente infere de um repositório vazio ou
   faz entrevista genérica. Passe o texto.
3. **Chegue com dado.** No passo de pesquisa e no de definição, o que você não trouxer o agente
   preenche com o que parece plausível. Plausível em PRD é pior que lacuna assumida.
4. **Lacuna é para ficar marcada.** Se o agente perguntar algo que você não sabe, diga que não
   sabe. A marcação de indefinição é recurso, não falha. O passo de clarificação existe para
   isso.
5. **Um único slug** para os cinco comandos da Trilha 0.
6. **Não pule passo com "a gente já pensou nisso".** O critério de pulo é o artefato existir no
   disco e estar atual. Os critérios completos estão em `ESTEIRA.md`, seção 4.
7. **Oito passos nunca se pulam nestas duas trilhas:** definir o problema, modelar opções,
   decidir, constituição do domínio, escrever as histórias, especificar, desenhar a superfície e
   compilar a entrega. Perfis e atores pula só quando já estão escritos e não há ator novo; a
   validação por mockup pula só em feature sem efeito visível para quem usa (mas em jogo a
   conferência do contrato não pula); a compilação pula só quando a mesma pessoa especifica e
   executa na sequência.
8. **Se o `shape` não fechar sem resposta que só o código dá**, isso é um **spike**: pergunta
   escrita, prazo, saída registrada e código descartável. É o único caso em que se toca
   tecnologia antes da Trilha 2, e é autorizado, não improvisado. Detalhe em `ESTEIRA.md`.

---

## Os portões e quem assina

Portão sem dono nomeado não é portão.

| Portão | Executa | Assina |
|---|---|---|
| Decidir (Trilha 0) | Etiene e Daniel, com operações | operações co-assina |
| Aceite / fronteira (Trilha 1) | produto | operações, **tech lead** e **segurança** co-assinam |

A regra é a mesma: **quem propõe ou escreve não assina sozinho**. É operação que descobre na
prática o que a especificação esqueceu. No aceite de fronteira, são **quatro assinaturas**: além
de produto e operações, o **tech lead** que vai receber o trabalho, e **segurança** quando a
feature toca dinheiro, dado de identidade ou comunicação com apostador.

---

## Se algo travar

- **O agente recusou um comando e citou um passo que falta.** Está correto. Faça o passo que
  falta.
- **O agente quer discutir stack, banco ou arquitetura.** Está fora de escopo. A parte técnica
  já está resolvida pelos archetypes da Suprema (simples, completo tradicional e completo
  hexagonal). Redirecione.
- **O agente propôs escrever código.** Recuse. Código só acontece na Trilha 3, em outra sessão.
  A única exceção é o mockup do passo 12 (validar), que é HTML descartável dentro de `specs/<feature>/mockup/`.
- **Você precisa fazer algo que a esteira não cobre.** Fale com Etiene ou Daniel antes de
  seguir por fora. Divergência combinada é decisão registrada; divergência silenciosa é
  retrabalho.

---

**Versão** 0.5 · **Régua** Constituição de Engenharia da Suprema v1.2.0 · **Ferramenta** Spec Kit
pinado na tag indicada em `ESTEIRA.md`
