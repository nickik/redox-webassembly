# redox-wasmi

Packaging and portability work needed to run the Wasmi WebAssembly interpreter
as a Redox OS package.

## Scope

The first milestone is intentionally small:

1. Build the upstream Wasmi CLI for `x86_64-unknown-redox`.
2. Keep WASI completely disabled.
3. Boot a Redox image through `redoxer exec` (QEMU underneath).
4. Run `wasmi answer.wasm --invoke answer` inside Redox.
5. Assert that the result is exactly `42`.
6. Produce an upstream-quality Redox Cookbook recipe.

This repository is not a Wasmi fork. Upstream source is fetched into `target/`
and any required portability patches should remain minimal and suitable for
submission upstream.

## Why Wasmi 2.0 beta?

The repository currently pins `v2.0.0-beta.10`. Wasmi 1.1.0's CLI depends on
`wasmi_wasi` unconditionally; the 2.0 CLI makes WASI optional. That lets this
project exercise the normal Wasmi CLI without bringing WASI into scope.

The pin is isolated in `scripts/common.sh` and the Cookbook recipe so it is easy
to move to the first suitable stable 2.x release.

## Prerequisites

On a Linux development host, install Rust, Git, QEMU and Redox's `redoxer`.
Then initialize the Redox toolchain:

```sh
cargo install redoxer --locked
redoxer toolchain
```

Check local prerequisites with:

```sh
make prerequisites
```

## Useful commands

```sh
make check        # static/local checks; no Redox VM
make codex        # open Codex on the active project plan
make upstream     # fetch the pinned Wasmi source
make redox-build  # cross-compile Wasmi for Redox
make redox-test   # build, boot Redox in QEMU, execute the smoke test
make test         # local checks + full Redox integration test
```

## Integration test

`tests/fixtures/answer.wasm` contains a tiny module equivalent to:

```wat
(module
  (func (export "answer") (result i32)
    i32.const 42))
```

The integration test runs approximately:

```text
host
  -> redoxer build Wasmi for x86_64-unknown-redox
  -> redoxer exec
       -> QEMU boots Redox
       -> Wasmi binary is copied into the guest
       -> tests/fixtures is copied into /root/fixtures
       -> wasmi /root/fixtures/answer.wasm --invoke answer
       -> stdout: 42
  -> host asserts stdout == 42
```

See `docs/TESTING.md` for details.

## Codex

This repository is prepared for Codex:

- `AGENTS.md` defines project-wide operating rules and completion criteria.
- `PLANS.md` defines the execution-plan format and current milestones.
- `.codex/config.toml` configures project agents.
- `.codex/agents/` contains focused Redox porting/testing agents.
- `STATUS.md` is the concise handoff/progress log.

Start a prepared Codex session with:

```sh
make codex
```

The intended Codex instruction is simply:

```text
Read AGENTS.md and continue the current plan in PLANS.md. Get make redox-test
passing without adding WASI.
```

## Upstream targets

The likely final changes belong in two upstream projects:

- Wasmi, if Redox-specific portability changes are actually necessary.
- Redox Cookbook, for the final package recipe.

Do not carry a permanent downstream patch when a small upstream-safe fix is
possible.
