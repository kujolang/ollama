#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KUJO_BIN="${KUJO_BIN:-$(command -v kujo)}"
KENNEL_SCRIPT="${KENNEL_SCRIPT:-$ROOT/../kennel/kennel.kujo}"
OLLAMA_REF="${OLLAMA_REF:-v0.1.5}"
CLEAN="$(mktemp -d "${TMPDIR:-/tmp}/kujo-ollama-installed.XXXXXX")"
trap 'rm -rf "$CLEAN"' EXIT
cd "$CLEAN"
"$KUJO_BIN" run "$KENNEL_SCRIPT" --interpreter -- init --name ollama-installed --project-dir "$CLEAN"
"$KUJO_BIN" run "$KENNEL_SCRIPT" --interpreter -- add github:kujolang/ollama@"$OLLAMA_REF" --alias ollama --project-dir "$CLEAN"
"$KUJO_BIN" run "$KENNEL_SCRIPT" --interpreter -- install --project-dir "$CLEAN"
"$KUJO_BIN" run "$KENNEL_SCRIPT" --interpreter -- install --project-dir "$CLEAN"
"$KUJO_BIN" run "$KENNEL_SCRIPT" --interpreter -- validate --project-dir "$CLEAN"
KUJO_MODULE_PATH="$CLEAN/kennel_packages/ollama:$CLEAN/kennel_packages/ai-sdk" \
  "$KUJO_BIN" test-run "$CLEAN/kennel_packages/ollama/tests/installed_consumer_smoke.kujo"
echo "Installed-package Kennel smoke: PASS"
