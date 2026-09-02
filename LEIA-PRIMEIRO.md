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
| `extension-produto/` | a extensão da Suprema que entrega os passos 9, 10 e 11. Instalada no bootstrap, não precisa ser aberta |

---

## As quatro trilhas

```
TRILHA 0 · Descoberta      por ideia            produto + operações
TRILHA 1 · Definição       por iniciativa       produto + operações
   ───────── aqui produto entrega para tecnologia ─────────
TRILHA 2 · Nascimento      uma vez por serviço  tecnologia + SRE
TRILHA 3 · Construção      por feature          tecnologia
TRILHA 4 · Sustentação     contínuo             time do serviço
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

| # | Passo | Comando | Artefato |
|---|---|---|---|
| 6 | **Constituição do domínio** | `/speckit-constitution` | `constitution.md` |
| 7 | Especificar | `/speckit-specify` | `spec.md` |
| 8 | Clarificar | `/speckit-clarify` | `spec.md` atualizado |
| 9 | **Propor e aprovar a superfície do produto** | `/speckit-produto-desenho` | `desenho.md` |
| 10 | **Mockup navegável de validação** | `/speckit-produto-mockup` | `mockup/index.html` |
| 11 | **Compilar a entrega** | `/speckit-produto-compilar` | `entregaveis/`, `PRD.md` |
| 12 | **Portão: checklist e aceite** | `/speckit-checklist` | `checklists/` |

A constituição vem **antes** da especificação. Ela carrega as restrições de domínio, risco e
regulatório. Especificar primeiro produz requisito que viola a própria régua, e a violação só
aparece semanas depois, com o PRD já aprovado.

Os passos 9 e 10 são o **produto concreto**. A especificação diz o que o produto faz; o desenho
diz como a pessoa usa. Ele decide, tela por tela: quais menus existem, o que cada tela mostra,
quais botões e filtros tem, o que aparece quando não há dado nenhum, o que aparece quando dá
erro, o que cada perfil pode fazer, o que muda por marca, e que evento precisa ser medido para
as métricas do PRD serem verificáveis.

**Você não responde a um questionário.** O agente lê os artefatos e escreve uma proposta
completa; você lê e redireciona. Ele é obrigado a marcar `[SUPOSTO]` em tudo que deduziu e
`[INDEFINIDO]` no que não soube supor, então você varre as marcas em vez de reler o documento
inteiro. Itera em rodadas até você aprovar de forma explícita.

O passo 10 gera um **mockup navegável** e conduz uma entrevista sobre ele. Serve para duas
coisas: confirmar que o entendimento está certo (ver a tela revela divergência que o texto
esconde) e **gerar ideia nova** (quem vê a tela pensa em coisa que não estava escrita). O que
sair da entrevista volta para o `desenho.md` e para o `spec.md`.

O mockup é **descartável**: HTML puro, dado fictício, faixa de aviso no topo. Nunca é
aproveitado no código. O produto é construído do zero a partir do archetype, na Trilha 3.

O passo 9 escolhe o conjunto de seções pelo **tipo de produto**. Interface usa perfis,
navegação, telas e estados. **Jogo** usa contrato de evento, estados de rodada, regras de
aposta, carteira e auditoria, e só depois as telas mínimas: em jogo o entregável para tecnologia
é o contrato de evento, não o menu.

O passo 11 resolve a **fragmentação**. Os artefatos anteriores são o raciocínio; a unidade de
execução é o item que viaja sozinho para o backlog. A compilação gera um arquivo autossuficiente
por item, com contexto, requisito, critérios de aceite, métricas, recorte do desenho,
dependências e fase, mais o PRD consolidado. **Os dois são gerados, nunca editados à mão**: para
mudar, muda-se a especificação ou o desenho e roda o comando de novo.

Depois do passo 12, **pare**. A fronteira com tecnologia é esse portão.

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
| Histórias de usuário priorizadas | `spec.md` |
| Requisitos funcionais numerados | `spec.md` |
| Critérios de aceite | `spec.md` |
| Critérios de sucesso mensuráveis | `spec.md` |
| Casos de borda e premissas | `spec.md` |
| Perfis, permissões e menus | `desenho.md` |
| Telas, colunas, botões, filtros | `desenho.md` |
| Estados de erro, vazio e sem permissão | `desenho.md` |
| Fluxos entre telas | `desenho.md` |
| Notificações e comunicação | `desenho.md` |
| O que muda por marca | `desenho.md` |
| Eventos a instrumentar | `desenho.md` |
| Protótipo visual para validação | `mockup/index.html` |
| Contrato de evento (produto de jogo) | `desenho.md` |
| Item pronto para o backlog | `entregaveis/<PREFIXO>-NN.md` |
| PRD consolidado, para circular | `PRD.md` |

Todos ficam versionados no repositório do produto, ao lado do código que vier depois. É isso
que faz o PRD continuar achável e verdadeiro seis meses depois.

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
7. **Sete passos nunca se pulam nestas duas trilhas:** definir o problema, modelar opções,
   decidir, constituição do domínio, especificar, desenhar a superfície e compilar a entrega. O
   mockup pula só em feature sem efeito visível para quem usa; a compilação pula só quando a
   mesma pessoa especifica e executa na sequência.
8. **Se o `shape` não fechar sem resposta que só o código dá**, isso é um **spike**: pergunta
   escrita, prazo, saída registrada e código descartável. É o único caso em que se toca
   tecnologia antes da Trilha 2, e é autorizado, não improvisado. Detalhe em `ESTEIRA.md`.

---

## Os portões e quem assina

Portão sem dono nomeado não é portão.

| Portão | Executa | Assina |
|---|---|---|
| Decidir (Trilha 0) | Etiene e Daniel, com operações | operações co-assina |
| Aceite da especificação (Trilha 1) | produto | operações co-assina |

A regra dos dois é a mesma: **quem propõe ou escreve não assina sozinho**. É operação que
descobre na prática o que a especificação esqueceu.

---

## Se algo travar

- **O agente recusou um comando e citou um passo que falta.** Está correto. Faça o passo que
  falta.
- **O agente quer discutir stack, banco ou arquitetura.** Está fora de escopo. A parte técnica
  já está resolvida pelo Archetype Backend NestJS da Suprema. Redirecione.
- **O agente propôs escrever código.** Recuse. Código só acontece na Trilha 3, em outra sessão.
  A única exceção é o mockup do passo 10, que é HTML descartável dentro de `specs/<feature>/mockup/`.
- **Você precisa fazer algo que a esteira não cobre.** Fale com Etiene ou Daniel antes de
  seguir por fora. Divergência combinada é decisão registrada; divergência silenciosa é
  retrabalho.

---

**Versão** 0.1 · **Régua** Constituição de Engenharia da Suprema v1.0.0 · **Ferramenta** Spec Kit
pinado na tag indicada em `ESTEIRA.md`
