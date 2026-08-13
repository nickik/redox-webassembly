#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

missing=0
for cmd in git cargo rustc qemu-system-x86_64 redoxer; do
  if command -v "$cmd" >/dev/null 2>&1; then
    printf 'ok      %s: %s\n' "$cmd" "$(command -v "$cmd")"
  else
    printf 'missing %s\n' "$cmd"
    missing=1
  fi
done

if [[ "$missing" -ne 0 ]]; then
  cat <<'MSG'

Install missing host prerequisites. For redoxer:
  cargo install redoxer --locked
  redoxer toolchain

On Debian/Ubuntu, QEMU is normally provided by qemu-system-x86.
MSG
  exit 1
fi

say "All command prerequisites are present."
say "If this is a fresh redoxer installation, ensure 'redoxer toolchain' has completed."
