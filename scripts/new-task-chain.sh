#!/usr/bin/env bash
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <chain-name> [destination-root]" >&2
  exit 1
fi

CHAIN_NAME="$1"
DEST_ROOT="${2:-tasks/projects}"
WORKSPACE_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEMPLATE_DIR="$WORKSPACE_ROOT/templates/task-chain-template"
DEST_DIR="$WORKSPACE_ROOT/$DEST_ROOT/$CHAIN_NAME"

if [[ -e "$DEST_DIR" ]]; then
  echo "Destination already exists: $DEST_DIR" >&2
  exit 1
fi

mkdir -p "$WORKSPACE_ROOT/$DEST_ROOT"
cp -R "$TEMPLATE_DIR" "$DEST_DIR"

sed -i '' "s/Task Chain Template/${CHAIN_NAME}/g" "$DEST_DIR/README.md" || true
sed -i '' "s/# Task Chain Log/# ${CHAIN_NAME} Log/g" "$DEST_DIR/CHAIN_LOG.md" || true
sed -i '' "s/# Task Chain Report/# ${CHAIN_NAME} Report/g" "$DEST_DIR/REPORT.md" || true

cat <<MSG
Created task chain scaffold:
  $DEST_DIR

Next steps:
  1. Edit README.md
  2. Define expected outputs under expected/
  3. Start logging in CHAIN_LOG.md
  4. Save execution evidence under artifacts/
MSG
