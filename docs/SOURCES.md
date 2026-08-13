# Verified project references

These are the external references used when the repository scaffold was created
on 2026-08-13. Codex should re-check version-sensitive details before changing
pins or command syntax.

## Redox

- Redoxer: https://github.com/redox-os/redoxer
- Redox documentation: https://doc.redox-os.org/book/
- Redox source/package infrastructure: https://gitlab.redox-os.org/redox-os/
- Historical GitHub Cookbook mirror (archived; useful for recipe examples):
  https://github.com/redox-os/cookbook

Important: the GitHub Cookbook mirror was archived in April 2026. Current Redox
documentation still describes Cookbook as the recipe/package system. Treat the
Redox GitLab project/documentation as the active upstream source of truth.

## Wasmi

- Wasmi: https://github.com/wasmi-labs/wasmi
- Initial pin: v2.0.0-beta.10
- Release commit prefix verified at scaffold creation: 56634a0
- CLI manifest:
  https://github.com/wasmi-labs/wasmi/blob/v2.0.0-beta.10/crates/cli/Cargo.toml

At this pin, `wasmi_wasi` is optional and gated by the CLI `wasi` feature.

## Codex

- AGENTS.md project instructions:
  https://developers.openai.com/codex/agent-configuration/agents-md
- Codex subagents/custom agents:
  https://developers.openai.com/codex/agent-configuration/subagents
- Advanced/project configuration:
  https://developers.openai.com/codex/config-advanced
