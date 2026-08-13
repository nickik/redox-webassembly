#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

need_cmd cargo
[[ -d "$WASMI_DIR" ]] || "$ROOT_DIR/scripts/fetch-upstream.sh"

say "Checking selected Wasmi CLI dependency graph for wasmi_wasi ..."
set +e
tree="$(
  cd "$WASMI_DIR" &&
  cargo tree -p wasmi_cli --no-default-features --features "$WASMI_FEATURES" 2>&1
)"
status=$?
set -e

if [[ "$status" -ne 0 ]]; then
  printf '%s\n' "$tree" >&2
  die "cargo tree failed"
fi

if grep -Eq '(^|[[:space:]])wasmi_wasi([[:space:]]|v|$)' <<<"$tree"; then
  printf '%s\n' "$tree" >&2
  die "wasmi_wasi is present in the selected dependency graph"
fi

say "PASS: selected Wasmi CLI features do not include wasmi_wasi"
