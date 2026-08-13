#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! command -v codex >/dev/null 2>&1; then
  printf 'error: Codex CLI is not installed or not on PATH\n' >&2
  exit 1
fi

exec codex --cd "$ROOT_DIR" \
  "Read AGENTS.md, PLANS.md, and STATUS.md. Continue the active Redox Wasmi plan. Work toward make redox-test passing. Keep WASI out of scope, use the configured subagents when useful, update STATUS.md with evidence, and do not claim success without the real Redox/QEMU test."
