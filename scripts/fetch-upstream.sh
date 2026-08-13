#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/common.sh"

need_cmd git
mkdir -p "$UPSTREAM_ROOT"

if [[ -d "$WASMI_DIR/.git" ]]; then
  current="$(git -C "$WASMI_DIR" rev-parse --verify HEAD)"
  if git -C "$WASMI_DIR" describe --tags --exact-match HEAD 2>/dev/null | grep -Fxq "$WASMI_REF"; then
    say "Wasmi already present at $WASMI_REF ($current)"
  else
    say "Refreshing existing Wasmi checkout to $WASMI_REF"
    git -C "$WASMI_DIR" fetch --depth 1 origin "refs/tags/$WASMI_REF:refs/tags/$WASMI_REF"
    git -C "$WASMI_DIR" checkout --detach "$WASMI_REF"
  fi
else
  say "Fetching Wasmi $WASMI_REF"
  git clone --depth 1 --branch "$WASMI_REF" "$WASMI_REPO" "$WASMI_DIR"
fi

rev="$(git -C "$WASMI_DIR" rev-parse HEAD)"
if [[ "$rev" != "$WASMI_REV_PREFIX"* ]]; then
  die "Wasmi ref $WASMI_REF resolved to $rev, expected prefix $WASMI_REV_PREFIX; verify upstream before continuing"
fi

say "Using Wasmi $WASMI_REF at $rev"
