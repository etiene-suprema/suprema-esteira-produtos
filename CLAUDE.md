# Esteira de Criação Suprema — repositório do padrão

Este repositório **é o padrão de criação de software da Suprema**. Ele não é um projeto de
trabalho e não contém código de produto.

Uma pessoa que abre uma sessão aqui quer uma de duas coisas: **começar um produto novo** ou
**entender o processo**. Sua função é levá-la ao caminho certo, não improvisar um caminho.

## Sua primeira ação

Leia, nesta ordem:

1. `LEIA-PRIMEIRO.md` — o mapa das cinco trilhas e onde cada parte do PRD mora
2. `ESTEIRA.md` — o processo completo: passos, critérios de pulo, regras de bloqueio, bootstrap
3. `CONSTITUICAO-ENGENHARIA.md` — os 9 princípios que regem todo serviço backend do grupo

Depois disso, faça **uma** pergunta de triagem:

> Você quer iniciar um produto novo, ou trabalhar numa feature de um serviço que já existe?

- **Produto novo** → execute o bootstrap (abaixo) e depois use `PROMPT-NOVO-PRD.md`
- **Feature de serviço existente** → o trabalho acontece no repositório daquele serviço, nas
  Trilhas 1 e 3. Aqui você só orienta

## Como iniciar um produto novo

O bootstrap está scriptado e resolve os caminhos sozinho, independente de onde este
repositório foi clonado:

```bash
./bootstrap.sh <nome-do-projeto>
```

Ele instala a CLI do Spec Kit **pinada na tag**, cria o projeto como diretório **irmão** deste,
instala as três extensões da esteira (`assess`, `bug`, `produto`), copia `ESTEIRA.md` como
`CLAUDE.md` no projeto novo e valida a contagem de 20 skills.

Se o script falhar, os passos manuais equivalentes estão na seção 1 de `ESTEIRA.md`. Não
improvise uma sequência diferente.

Depois do bootstrap, o trabalho continua **no diretório do projeto**, com o `CLAUDE.md` dele
carregado. Não conduza trabalho de produto aqui.

## Regras neste repositório

1. **Não trabalhe neste diretório.** Projeto novo nasce em diretório próprio, criado pelo
   bootstrap.
2. **Não conduza trabalho de produto nem de código aqui.** A esteira acontece no repositório do
   projeto.
3. **Não proponha caminho alternativo à esteira.** Ela é o padrão do grupo, não uma sugestão
   entre outras. Se a pessoa precisa de algo que a esteira não cobre, a resposta é falar com
   Etiene ou Daniel antes de seguir, para a divergência ficar registrada.
4. **Não escolha nem discuta stack.** A parte técnica está resolvida pelo Archetype Backend
   NestJS da Suprema.
5. **Alteração no processo é alteração de padrão.** Mudança em `ESTEIRA.md`,
   `CONSTITUICAO-ENGENHARIA.md` ou nos comandos da extensão exige PR dedicado, com justificativa
   e versionamento semântico. Nunca edição direta em `main`.
6. **Não altere a tag pinada do Spec Kit** sem PR e sem teste. O projeto upstream libera cerca
   de 285 commits por mês e não promete estabilidade de API.

## O que este repositório contém

| Arquivo | Papel |
|---|---|
| `LEIA-PRIMEIRO.md` | entrada do time: o mapa das trilhas |
| `PROMPT-NOVO-PRD.md` | prompt de copiar e colar para iniciar um PRD |
| `ESTEIRA.md` | o processo. Vira o `CLAUDE.md` de cada projeto novo |
| `CONSTITUICAO-ENGENHARIA.md` | os 9 princípios de engenharia, v1.0.0 |
| `extension-produto/` | extensão própria: passos 4 e 5 da Trilha 1 |
| `bootstrap.sh` | cria e configura um projeto novo |

O código da ferramenta **não** vive aqui. A CLI vem da tag pinada, baixada no bootstrap.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).

<!-- GRAPHIFY-PT:BEGIN (gerado a partir do grafo) -->
## Grafo de conhecimento (graphify) — regras

O grafo do repo fica em `graphify-out/` (graph.json, GRAPH_REPORT.md, graph.html).

1. **Graphify primeiro.** Antes de qualquer pergunta ou alteração, consulte o grafo com `graphify query "<pergunta>"` (ou `graphify path "A" "B"`, `graphify explain "X"`). Não leia arquivos às cegas. (Reforçado pelo hook PreToolUse `hook-guard`.)
2. **Update automático.** Após qualquer alteração de código, rode `graphify update .` (incremental, AST, sem custo de API). (Reforçado pelo hook PostToolUse em Edit/Write.)
3. **Este CLAUDE.md se atualiza junto.** Se a arquitetura mudar (novos módulos, serviços, dependências), atualize as seções abaixo. Depois rode `graphify update .` e `graphify god-nodes` para reconferir os hubs.

### Arquitetura derivada do grafo
- **Resumo do grafo:** 104 nodes · 96 edges · 11 communities (10 shown, 1 thin omitted)
- **God Nodes (núcleos mais conectados, maior raio de impacto):**
  - `Fase A · Propor` (12 arestas)
  - `Core Principles` (10 arestas)
  - `Mockup navegável de validação` (10 arestas)
  - `Esteira de Criação Suprema — instruções operacionais` (9 arestas)
  - `Desenhar a superfície do produto` (9 arestas)
  - `Esteira de Criação Suprema — comece aqui` (7 arestas)
  - `Extensão Produto (Suprema)` (7 arestas)
  - `Constituição de Engenharia da Suprema` (6 arestas)
- **Comunidades principais / hubs de navegação:**
  - Esteira de Criação Suprema — instruções operacionais
  - Mockup navegável de validação
  - Esteira de Criação Suprema — comece aqui
  - Fase A · Propor
  - Extensão Produto (Suprema)
  - Core Principles
  - Desenhar a superfície do produto
  - Esteira de Criação Suprema — repositório do padrão
  - Constituição de Engenharia da Suprema
  - 2 · A esteira
- **Arquivos de alto risco (mexer com cuidado):**
  - Os God Nodes acima concentram dependências; mudanças neles propagam para todo o grafo.
  - Nenhum ciclo de import detectado.
- **Fluxo de desenvolvimento:** comece pelos hubs de navegação acima para localizar pontos de entrada; use `graphify query` para achar o subgrafo relevante antes de editar; edite; rode `graphify update .`; se a topologia mudar, atualize este bloco.

<!-- GRAPHIFY-PT:END -->
