#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

need_cmd python3

python3 - "$FIXTURE_DIR/answer.wasm" <<'PY'
import pathlib
import sys

path = pathlib.Path(sys.argv[1])
data = path.read_bytes()
if data[:8] != b"\x00asm\x01\x00\x00\x00":
    raise SystemExit(f"{path}: not a WebAssembly 1 binary")
expected_hex = (
    "0061736d01000000"
    "0105016000017f"
    "03020100"
    "070a0106616e737765720000"
    "0a06010400412a0b"
)
if data.hex() != expected_hex:
    raise SystemExit(f"{path}: fixture bytes differ from the canonical answer() -> 42 module")
print("PASS: canonical WebAssembly fixture is intact")
PY

expected="$(cat "$FIXTURE_DIR/answer.expected")"
[[ "$expected" == "42" ]] || die "answer.expected must contain exactly 42"
