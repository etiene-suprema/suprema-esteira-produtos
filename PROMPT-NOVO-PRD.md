# Prompt para iniciar um PRD novo

Copie **tudo** que está dentro do bloco abaixo, preencha os três campos entre colchetes, e
cole como sua primeira mensagem na sessão do agente.

Antes de colar, abra a sessão na raiz deste repositório:

```bash
claude
```

---

```text
Contexto: sou do time de tecnologia da Suprema. Estou iniciando um produto novo e
vou seguir a Esteira de Criação Suprema, que é o padrão de criação de software do
grupo. Esta sessão é de PRODUTO. Nada de tecnologia acontece aqui.

ANTES DE QUALQUER COISA, leia estes dois arquivos deste repositório e me confirme
em poucas linhas que entendeu a esteira e a régua:
1. ESTEIRA.md
2. CONSTITUICAO-ENGENHARIA.md

O PRODUTO:
Nome: [NOME-DO-PRODUTO-EM-KEBAB-CASE]
O que é: [3 A 5 LINHAS: o que faz, para quem, qual dor resolve]
Contexto de acoplamento: [EM QUE SISTEMA VAI SE ENCAIXAR, OU "produto autônomo"]

O QUE QUERO NESTA SESSÃO:
Rodar a Trilha 0 (Descoberta) e a Trilha 1 (Definição do produto), nesta ordem, e
nada além disso. O resultado esperado é um PRD completo distribuído nos artefatos:
intake.md, research.md, problem.md, concept.md, decision.md, constitution.md,
spec.md, desenho.md, um mockup HTML navegável, os itens de entrega em
entregaveis/ e o PRD consolidado.

COMECE ASSIM, sem me perguntar nada antes:
1. Execute o bootstrap da seção 1 do ESTEIRA.md. Crie o projeto num
   diretório irmão deste repositório, com o nome do produto. Instale a CLI pinada
   na tag indicada, use integração claude e scripts sh, instale as três extensões
   (assess, bug e a extensão produto deste repositório, com --dev), copie
   ESTEIRA.md como CLAUDE.md na raiz do projeto novo, e coloque .claude/
   e .DS_Store no .gitignore dele.
2. Valide o estado esperado da seção 1.3: confirme que existem 21 skills e que
   .specify/memory/constitution.md ainda está com placeholder.
3. Me mostre a árvore do projeto criado e só então pare para conversar comigo.

REGRAS DESTA SESSÃO, sem exceção:
- NÃO escreva código de produção. Nenhuma linha. A única exceção é o mockup do
  passo 10, que é HTML descartável com dado fictício, dentro de
  specs/<feature>/mockup/, e que nunca é aproveitado na implementação.
- NÃO execute /speckit-plan, /speckit-tasks nem /speckit-implement.
- NÃO escolha, sugira ou discuta stack, banco, framework ou arquitetura. A parte
  técnica já está resolvida pelo Archetype Backend NestJS da Suprema e não é
  assunto desta sessão.
- A constituição do domínio vem ANTES da especificação, sempre. Ela trata de
  domínio, risco e regulatório, nunca de engenharia.
- Pare em cada portão da esteira e peça minha confirmação antes de avançar.
- Se faltar informação, PERGUNTE ou marque como indefinição na especificação.
  Nunca preencha com o que parece plausível.
- Use um único slug para os cinco comandos da Trilha 0.
- Ao fim de cada passo, diga qual arquivo foi criado e o que ficou pendente.

NOTA DE HANDOFF: este repo é de trabalho de produto. Quando a Trilha 2 acontecer,
o repositório do serviço nasce do archetype e os artefatos de .specify/ são
copiados para lá. Não antecipe isso agora.
```

---

## Os três campos

| Campo | O que colocar |
|---|---|
| `[NOME-DO-PRODUTO-EM-KEBAB-CASE]` | vira o nome do diretório do projeto |
| `[3 A 5 LINHAS]` | insumo do passo de captação. Escreva do ponto de vista de quem sofre a dor, não da solução |
| `[Contexto de acoplamento]` | apague e escreva "produto autônomo" se não se encaixa em nada existente |

## O que acontece depois de colar

O agente executa o bootstrap sozinho, mostra a árvore e para. A partir daí você percorre os
doze passos das Trilhas 0 e 1, um por vez, com o agente parando em cada portão.

O percurso completo e os artefatos de cada passo estão em `LEIA-PRIMEIRO.md`.

Nos passos 9 a 11 o agente propõe a superfície do produto (você reage em vez de responder
questionário), gera um mockup navegável para você conferir se ele entendeu, e compila tudo em
itens prontos para o backlog mais o PRD consolidado. É no mockup que a maioria das ideias novas
aparece, então reserve tempo para olhar com calma.

Se o produto for um jogo, o passo 9 troca o conjunto de seções: o entregável para tecnologia
passa a ser o contrato de evento, não o menu.
