---
description: "Gera um mockup HTML navegável do desenho e conduz a entrevista de validação, devolvendo o que emergir para a especificação"
---

# Mockup navegável de validação

Produz `specs/<feature>/mockup/index.html`: um mockup **navegável e descartável** do produto
desenhado, e conduz a entrevista que confirma se o entendimento está certo. É o passo 5 da
Trilha 1 da Esteira de Criação Suprema.

O mockup existe por dois motivos, nesta ordem:

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
  de produto, o que é proibido pela esteira.
- **Não usa dado real.** Todo dado é fictício e obviamente fictício. É proibido usar nome, CPF,
  e-mail, telefone ou valor de pessoa real, ainda que de teste.
- **Não é protótipo funcional.** Nada persiste, nada calcula de verdade, nada chama serviço.

## Pré-condições

1. Rode `.specify/scripts/bash/check-prerequisites.sh --json` e leia os caminhos.
2. `spec.md` e `desenho.md` MUST existir. Se `desenho.md` não existir, **pare** e diga que o
   passo 4 (`/speckit-produto-desenho`) ainda não aconteceu. Sem ele não há o que mockar.
3. `desenho.md` MUST estar com `**Status**: aprovado` no cabeçalho. Se estiver como `proposta`,
   **pare** e diga que o desenho ainda está em iteração: mockar proposta que vai mudar é
   desperdício de trabalho seu e de atenção do usuário. Volte para `/speckit-produto-desenho`.
4. Leia `spec.md`, `desenho.md` e `.specify/memory/constitution.md` inteiros.
5. Se `desenho.md` foi aprovado com pendências registradas, mocke as telas mesmo assim e
   **marque visualmente** cada ponto pendente na interface (ver abaixo). Pendência que aparece
   na tela é pendência que alguém resolve.

## O que construir

Um **único arquivo** `specs/<feature>/mockup/index.html`, autossuficiente, com CSS embutido e o
mínimo de JavaScript necessário para navegar entre telas.

Arquivo único e sem dependência externa é requisito, não preferência: é o que permite publicar
como artefato e compartilhar com o time sem servidor.

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

Sóbrio e legível, não bonito. O objetivo é conferir estrutura, hierarquia e completude, não
aprovar identidade visual. Cuidado específico: use dado fictício **plausível e brasileiro** nas
tabelas e listas, porque dado genérico esconde problema de layout que dado real revela (nome
comprido, valor grande, texto que estoura a coluna). Inclua ao menos uma linha com valor
extremo em cada tabela.

Deve funcionar em tela de celular e de desktop, porque em vários produtos da Suprema a operação
usa desktop e o usuário final usa celular, e isso muda o desenho.

## Publicação

Depois de escrever o arquivo, **publique como artefato** para a pessoa poder abrir e
compartilhar com o time. Informe o link.

Se a publicação não estiver disponível no ambiente, informe o caminho local do arquivo e como
abrir no navegador.

## A entrevista de validação

Este é o coração do passo. Depois de entregar o mockup, conduza a conversa nesta ordem, em
blocos, esperando resposta a cada bloco:

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

Só então ofereça o passo seguinte: `/speckit-checklist`, o portão de aceite da Trilha 1.

## Ao terminar

1. Diga quantas telas foram mockadas e quantas ficaram com indefinição visível.
2. Liste o que voltou para `desenho.md`, o que voltou para `spec.md` e o que ficou pendente.
3. Informe o link do mockup publicado.
4. Lembre que o mockup é descartável e que a construção acontece a partir do archetype, na
   Trilha 3.

Escreva **apenas** dentro de `specs/<feature>/`. Não toque em templates, scripts ou qualquer
arquivo do núcleo da ferramenta.
