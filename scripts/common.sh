#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

WASMI_REPO="${WASMI_REPO:-https://github.com/wasmi-labs/wasmi.git}"
WASMI_REF="${WASMI_REF:-v2.0.0-beta.10}"
WASMI_REV_PREFIX="${WASMI_REV_PREFIX:-56634a0}"
WASMI_FEATURES="${WASMI_FEATURES:-stable,run,validate,portable-dispatch}"
REDOX_TARGET="${REDOX_TARGET:-x86_64-unknown-redox}"

UPSTREAM_ROOT="$ROOT_DIR/target/upstream"
WASMI_DIR="$UPSTREAM_ROOT/wasmi"
WASMI_BIN_PATH_FILE="$ROOT_DIR/target/wasmi-bin.path"
FIXTURE_DIR="$ROOT_DIR/tests/fixtures"

say() {
  printf '%s\n' "$*"
}

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}
