#!/usr/bin/env bash
# ==============================================================================
# Bootstrap de um projeto novo pela Esteira de Criação Suprema.
#
#   ./bootstrap.sh <nome-do-projeto>
#
# Cria o projeto como IRMÃO deste repositório, instala a CLI do Spec Kit pinada,
# instala as três extensões da esteira e deixa o CLAUDE.md no lugar.
# Resolve os caminhos sozinho: não importa onde este repositório foi clonado.
# ==============================================================================
set -euo pipefail

SPECKIT_TAG="v1.0.1"

ESTEIRA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJETO="${1:-}"

if [[ -z "$PROJETO" ]]; then
  echo "uso: ./bootstrap.sh <nome-do-projeto>" >&2
  echo "exemplo: ./bootstrap.sh sayplus-growth" >&2
  exit 1
fi

DESTINO="$(dirname "$ESTEIRA_DIR")/$PROJETO"

if [[ -e "$DESTINO" ]]; then
  echo "erro: $DESTINO já existe. Escolha outro nome ou remova o diretório." >&2
  exit 1
fi

echo "▸ Conferindo pré-requisitos"
for cmd in uv git; do
  command -v "$cmd" >/dev/null || { echo "erro: '$cmd' não encontrado. Instale antes de seguir." >&2; exit 1; }
done
command -v docker >/dev/null || echo "  aviso: docker não encontrado. Não bloqueia o PRD, mas é exigido na Trilha 3."

echo "▸ Instalando a CLI do Spec Kit, pinada na tag $SPECKIT_TAG"
uv tool install specify-cli --from "git+https://github.com/github/spec-kit.git@$SPECKIT_TAG" --force
specify version

echo "▸ Criando o projeto em $DESTINO"
cd "$(dirname "$ESTEIRA_DIR")"
specify init "$PROJETO" --integration claude --script sh
cd "$DESTINO"

echo "▸ Instalando as extensões da esteira"
specify extension add assess
specify extension add bug
specify extension add "$ESTEIRA_DIR/extension-produto" --dev

echo "▸ Instalando as instruções da esteira como CLAUDE.md"
cp "$ESTEIRA_DIR/ESTEIRA.md" CLAUDE.md
printf '.claude/\n.DS_Store\n' > .gitignore

SKILLS="$(find .claude/skills -maxdepth 1 -mindepth 1 -type d | wc -l | tr -d ' ')"
echo
echo "▸ Pronto. Projeto em: $DESTINO"
echo "  skills instaladas: $SKILLS (esperado: 21)"
if [[ "$SKILLS" != "21" ]]; then
  echo "  AVISO: contagem diferente de 20. Confira se as três extensões instalaram." >&2
fi
echo
echo "Próximos passos:"
echo "  1. cd $DESTINO"
echo "  2. claude"
echo "  3. Cole o prompt de $ESTEIRA_DIR/PROMPT-NOVO-PRD.md"
echo
echo "A constituição em .specify/memory/constitution.md ainda está com placeholder."
echo "Preenchê-la é o passo 1 da Trilha 1, e acontece antes de especificar."
