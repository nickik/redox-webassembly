#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 - "$ROOT_DIR" <<'PY'
from pathlib import Path
import sys
import tomllib

root = Path(sys.argv[1])
files = [
    root / ".codex/config.toml",
    root / ".codex/agents/redox-porter.toml",
    root / ".codex/agents/redox-test-investigator.toml",
    root / "cookbook/recipes/wip/wasmi/recipe.toml",
]
for path in files:
    with path.open("rb") as f:
        tomllib.load(f)
    print(f"PASS: valid TOML: {path.relative_to(root)}")

for path in root.glob(".codex/agents/*.toml"):
    with path.open("rb") as f:
        data = tomllib.load(f)
    missing = {"name", "description", "developer_instructions"} - data.keys()
    if missing:
        raise SystemExit(f"{path}: missing required Codex agent keys: {sorted(missing)}")
PY
