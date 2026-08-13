#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

need_cmd redoxer
need_cmd qemu-system-x86_64
"$ROOT_DIR/scripts/test-fixture.sh"

if [[ ! -s "$WASMI_BIN_PATH_FILE" ]]; then
  "$ROOT_DIR/scripts/build-redox.sh"
fi

wasmi_bin="$(cat "$WASMI_BIN_PATH_FILE")"
[[ -f "$wasmi_bin" ]] || die "recorded Wasmi binary does not exist: $wasmi_bin"

say "Booting Redox in QEMU and invoking answer() through Wasmi ..."
set +e
output="$(
  redoxer exec -o - \
    -f "$FIXTURE_DIR:/root/fixtures" \
    "$wasmi_bin" \
    /root/fixtures/answer.wasm --invoke answer
)"
status=$?
set -e

if [[ "$status" -ne 0 ]]; then
  printf 'guest output:\n%s\n' "$output" >&2
  die "Redox guest Wasmi invocation failed with exit status $status"
fi

normalized="${output//$'\r'/}"
expected="$(cat "$FIXTURE_DIR/answer.expected")"

if [[ "$normalized" != "$expected" ]]; then
  printf 'expected: <%s>\n' "$expected" >&2
  printf 'actual:   <%s>\n' "$normalized" >&2
  die "unexpected Wasmi result from Redox guest"
fi

say "PASS: Redox/QEMU Wasmi executed answer.wasm and returned $expected"
