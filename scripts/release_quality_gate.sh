#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
KUJO_BIN="${KUJO_BIN:-$(command -v kujo)}"
cd "$ROOT"
"$KUJO_BIN" test-run tests/native_client_tests.kujo
"$KUJO_BIN" test-run tests/driver_tests.kujo
echo "Ollama offline release gate: PASS (2 deterministic test files)"
