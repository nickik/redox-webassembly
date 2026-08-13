# Status

Last updated: 2026-08-13

## Current state

- [x] Repository scaffold created.
- [x] Scope explicitly excludes WASI.
- [x] Wasmi source/version and no-WASI feature set centralized.
- [x] Deterministic core-Wasm fixture added.
- [x] Host-side result assertion scripted.
- [x] Codex AGENTS.md and focused subagents added.
- [x] Candidate Redox Cookbook recipe added.
- [ ] Wasmi successfully cross-compiled for Redox on a real Redox toolchain.
- [ ] `wasmi_wasi` absence verified from the actual Redox dependency graph.
- [ ] QEMU/Redox smoke test passed.
- [ ] Cookbook recipe tested with the upstream Cookbook.

## Next command

On a Linux host with QEMU and Rust:

```sh
make prerequisites
cargo install redoxer --locked   # only if missing
redoxer toolchain
make redox-test
```

If the build fails, preserve the first error and investigate that layer before
adding compatibility patches.

## Known deliberate temporary choices

- Upstream Wasmi pin: `v2.0.0-beta.10`.
- x86_64 only.
- Cookbook recipe remains under `wip/` until proven.
- `redoxer exec` is the VM harness.
