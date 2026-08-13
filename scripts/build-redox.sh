#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

need_cmd redoxer
"$ROOT_DIR/scripts/fetch-upstream.sh"
"$ROOT_DIR/scripts/check-no-wasi.sh"

say "Building Wasmi CLI for $REDOX_TARGET with features: $WASMI_FEATURES"
(
  cd "$WASMI_DIR"
  export TARGET="$REDOX_TARGET"
  redoxer build --release -p wasmi_cli --no-default-features --features "$WASMI_FEATURES"
)

mapfile -t candidates < <(
  find "$WASMI_DIR/target" -type f -name wasmi -path '*/release/wasmi' -print 2>/dev/null | sort
)

if [[ "${#candidates[@]}" -eq 0 ]]; then
  die "Redox build completed but no release 'wasmi' binary was found under $WASMI_DIR/target"
fi

wasmi_bin=""
for candidate in "${candidates[@]}"; do
  if [[ "$candidate" == *"$REDOX_TARGET"* ]]; then
    wasmi_bin="$candidate"
    break
  fi
done
[[ -n "$wasmi_bin" ]] || wasmi_bin="${candidates[-1]}"

mkdir -p "$(dirname "$WASMI_BIN_PATH_FILE")"
printf '%s\n' "$wasmi_bin" > "$WASMI_BIN_PATH_FILE"
say "Redox Wasmi binary: $wasmi_bin"
