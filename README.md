# Esteira de Criação Suprema

Este repositório **é o padrão de criação de software da Suprema**: o caminho único pelo qual uma
ideia de produto vira um serviço em produção. Não é um projeto de trabalho e não contém código de
produto. O veículo é o [GitHub Spec Kit](https://github.com/github/spec-kit) pinado na tag
`v1.0.1`, customizado **só por extensão e preset**, nunca por fork.

## Por onde começar

| Se você quer… | Abra |
|---|---|
| entender o processo, o mapa das trilhas | [`LEIA-PRIMEIRO.md`](./LEIA-PRIMEIRO.md) |
| iniciar um PRD novo (copiar e colar) | [`PROMPT-NOVO-PRD.md`](./PROMPT-NOVO-PRD.md) |
| a esteira completa (passos, bloqueios, bootstrap) | [`ESTEIRA.md`](./ESTEIRA.md) |
| os 9 princípios de engenharia do grupo | [`CONSTITUICAO-ENGENHARIA.md`](./CONSTITUICAO-ENGENHARIA.md) |
| apresentar a esteira para arquitetura | [`ESTEIRA-APRESENTACAO.md`](./ESTEIRA-APRESENTACAO.md) |
| a extensão de produto da Suprema | [`extension-produto/`](./extension-produto) |

## As cinco trilhas

```
TRILHA 0 · Descoberta            por ideia            vale construir isso?
TRILHA 1 · Definição             por iniciativa       o que faz e como se usa (nove passos)
   ─────── portão de fronteira: quatro assinaturas · produto entrega para tecnologia ───────
TRILHA 2 · Nascimento            uma vez por serviço  serviço de pé na máquina (local, sem SRE)
TRILHA 3 · Construção            por feature          único lugar onde nasce código de produção
TRILHA 4 · Entrega e Sustentação contínuo             go-live (SRE) e operação
```

A **Trilha 1** tem nove passos: constituição, **perfis e atores**, **histórias**, especificar,
clarificar, desenho, validar, compilar e o portão de aceite. Os dois passos em negrito são novos, e
quatro outros foram ampliados, para fechar seis gaps de rastreabilidade entre produto e Engenharia.

## Iniciar um produto novo

```bash
./bootstrap.sh <nome-do-projeto>
```

Cria o projeto como diretório irmão deste, instala a CLI pinada e as três extensões
(`assess`, `bug`, `produto`), copia `ESTEIRA.md` como `CLAUDE.md` no projeto novo e valida a
contagem de 23 skills. Depois, cole o prompt de [`PROMPT-NOVO-PRD.md`](./PROMPT-NOVO-PRD.md).

## Regra de mudança

**Alteração no processo é alteração de padrão.** Mudança em `ESTEIRA.md`,
`CONSTITUICAO-ENGENHARIA.md` ou nos comandos da extensão entra por **PR dedicado**, com
justificativa e versionamento semântico, com os documentos dependentes subindo de versão junto.
Nunca por edição direta em `main`. A tag pinada do Spec Kit não muda sem PR e sem teste.

## Estado atual

| Documento | Versão |
|---|---|
| Esteira (`ESTEIRA.md`) | 0.6 |
| Comece aqui (`LEIA-PRIMEIRO.md`) | 0.5 |
| Constituição de Engenharia | 1.2.0 |
| Extensão de produto | 1.3.0 |
| Spec Kit (pinado) | v1.0.1 |

Cinco decisões de processo do último redesenho ficam **marcadas como pendentes** até serem
assinadas: dono da régua de prioridade, granularidade do item de entrega, dono do registro de
permissões na plataforma, validação equivalente ao mockup em jogo, e se a variante hexagonal exige
decisão registrada sempre. Detalhe em `ESTEIRA.md` e em `ESTEIRA-APRESENTACAO.md`.
