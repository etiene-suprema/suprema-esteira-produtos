# Graph Report - suprema-esteira-produtos  (2026-09-02)

## Corpus Check
- 9 files · ~12,342 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 104 nodes · 96 edges · 11 communities (10 shown, 1 thin omitted)
- Extraction: 100% EXTRACTED · 0% INFERRED · 0% AMBIGUOUS
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `f941888a`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
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
- bootstrap.sh

## God Nodes (most connected - your core abstractions)
1. `Fase A · Propor` - 12 edges
2. `Core Principles` - 10 edges
3. `Mockup navegável de validação` - 10 edges
4. `Esteira de Criação Suprema — instruções operacionais` - 9 edges
5. `Desenhar a superfície do produto` - 9 edges
6. `Esteira de Criação Suprema — comece aqui` - 7 edges
7. `Extensão Produto (Suprema)` - 7 edges
8. `Constituição de Engenharia da Suprema` - 6 edges
9. `2 · A esteira` - 6 edges
10. `Esteira de Criação Suprema — repositório do padrão` - 5 edges

## Surprising Connections (you probably didn't know these)
- None detected - all connections are within the same source files.

## Import Cycles
- None detected.

## Communities (11 total, 1 thin omitted)

### Community 0 - "Esteira de Criação Suprema — instruções operacionais"
Cohesion: 0.14
Nodes (13): 1.1 Instalar a CLI, pinada por tag, 1.2 Criar o projeto e instalar as extensões, 1.3 Estado esperado ao fim do bootstrap, 1.4 Antes de qualquer trabalho começar, 1 · Bootstrap (uma vez, ao criar o projeto), 3 · Regras de bloqueio (a parte que morde), 4 · Critérios de pulo, 5 · Portões e assinatura (+5 more)

### Community 1 - "Mockup navegável de validação"
Cohesion: 0.14
Nodes (13): A entrevista de validação, Ao terminar, Cobertura obrigatória, Entrada do usuário, Iteração, Marcações visuais obrigatórias, Mockup navegável de validação, O que construir (+5 more)

### Community 2 - "Esteira de Criação Suprema — comece aqui"
Cohesion: 0.14
Nodes (12): As quatro trilhas, Esteira de Criação Suprema — comece aqui, O que existe nesta pasta, Onde cada parte do PRD acaba, Os portões e quem assina, Se algo travar, Sete coisas que fazem diferença na prática, Trilha 0 · Descoberta (+4 more)

### Community 3 - "Fase A · Propor"
Cohesion: 0.17
Nodes (12): 10 · Fora de escopo visual, 11 · Conformidade com a constituição, 1 · Perfis e permissões, 2 · Mapa de navegação, 3 · Inventário de telas, 4 · Detalhe de cada tela, 5 · Fluxos principais, 6 · Componentes recorrentes (+4 more)

### Community 4 - "Extensão Produto (Suprema)"
Cohesion: 0.18
Nodes (10): Extensão Produto (Suprema), Guardas obrigatórias do mockup, Hooks, Instalação, Manutenção, O método: proposta primeiro, O que o desenho cobre, O que o mockup entrega (+2 more)

### Community 5 - "Core Principles"
Cohesion: 0.20
Nodes (10): Core Principles, I. Nasce do Archetype (Golden Path), II. Identidade Delegada à Plataforma SayPlus, III. Isolamento Multi-Tenant em Três Camadas, IV. Migrations são Código de Produção, IX. Qualidade é Gate, não Recomendação, V. Contratos Invariantes de Erro, Configuração e Saúde, VI. Fronteiras de Módulo e de Serviço (+2 more)

### Community 6 - "Desenhar a superfície do produto"
Cohesion: 0.22
Nodes (8): Ao terminar, As duas marcas, e por que elas existem, Desenhar a superfície do produto, Entrada do usuário, Fase B · Entregar a proposta, Fase C · Iterar, Fase D · Aprovar, Pré-condições

### Community 7 - "Esteira de Criação Suprema — repositório do padrão"
Cohesion: 0.33
Nodes (5): Como iniciar um produto novo, Esteira de Criação Suprema — repositório do padrão, O que este repositório contém, Regras neste repositório, Sua primeira ação

### Community 8 - "Constituição de Engenharia da Suprema"
Cohesion: 0.33
Nodes (5): Constituição de Engenharia da Suprema, Decisões que Exigem ADR, Fluxo de Desenvolvimento e Portões de Qualidade, Governance, Restrições Técnicas do Golden Path

### Community 9 - "2 · A esteira"
Cohesion: 0.33
Nodes (6): 2 · A esteira, Trilha 0 · Descoberta, Trilha 1 · Definição do produto, Trilha 2 · Nascimento do serviço, Trilha 3 · Construção, Trilha 4 · Sustentação

## Knowledge Gaps
- **79 isolated node(s):** `bootstrap.sh script`, `Sua primeira ação`, `Como iniciar um produto novo`, `Regras neste repositório`, `O que este repositório contém` (+74 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 86 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **1 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Fase A · Propor` connect `Fase A · Propor` to `Desenhar a superfície do produto`?**
  _High betweenness centrality (0.029) - this node is a cross-community bridge._
- **Why does `Esteira de Criação Suprema — instruções operacionais` connect `Esteira de Criação Suprema — instruções operacionais` to `2 · A esteira`?**
  _High betweenness centrality (0.028) - this node is a cross-community bridge._
- **Why does `Desenhar a superfície do produto` connect `Desenhar a superfície do produto` to `Fase A · Propor`?**
  _High betweenness centrality (0.024) - this node is a cross-community bridge._
- **What connects `bootstrap.sh script`, `Sua primeira ação`, `Como iniciar um produto novo` to the rest of the system?**
  _79 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Esteira de Criação Suprema — instruções operacionais` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._
- **Should `Mockup navegável de validação` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._
- **Should `Esteira de Criação Suprema — comece aqui` be split into smaller, more focused modules?**
  _Cohesion score 0.14285714285714285 - nodes in this community are weakly interconnected._