# AGENTS.md

## Mission

Make the upstream Wasmi command-line interpreter build and run as a normal
Redox OS package, with a reproducible end-to-end test that boots Redox in QEMU
and evaluates a tiny WebAssembly module.

The current success command is:

```sh
make redox-test
```

It must ultimately print a PASS message only after the Wasmi binary actually
ran inside Redox and returned the expected WebAssembly result.

## Current scope

In scope:

- `x86_64-unknown-redox` first.
- Upstream Wasmi CLI.
- Core WebAssembly execution.
- Redox Cookbook packaging.
- `redoxer`-based cross compilation and VM testing.
- Small, upstreamable Redox portability fixes when needed.

Explicitly out of scope for this milestone:

- WASI and `wasmi_wasi`.
- Component Model support.
- JIT/AOT work; Wasmi is an interpreter.
- A Redox-specific guest ABI or custom WebAssembly imports.
- Broad refactoring of Wasmi.
- Performance optimization before correctness.
- Other Redox architectures until x86_64 works.

Do not expand scope merely to make a dependency easier to build.

## Upstream version

The initial source pin is `v2.0.0-beta.10` because the stable Wasmi 1.1.0 CLI
pulls in `wasmi_wasi` unconditionally while the 2.0 CLI feature-gates WASI.

Build the CLI with WASI disabled. The intended feature set is defined once in
`scripts/common.sh` and should remain the source of truth for local builds.

Prefer upgrading to a stable Wasmi 2.x release once one exists and preserves an
optional WASI dependency. An upgrade is a deliberate change: update the pin,
recipe, documentation and tests together.

Before an upstream Cookbook submission, replace release-tag source pins with an
immutable full commit SHA if required by Cookbook policy.

## Definition of done

Do not claim this project is working until all of the following are true:

1. `make check` passes from a clean checkout.
2. Wasmi builds for `x86_64-unknown-redox` with WASI disabled.
3. The dependency graph used for the Redox build does not include
   `wasmi_wasi`.
4. `redoxer exec` boots a Redox guest and executes the Redox Wasmi binary.
5. Inside that guest, Wasmi executes `tests/fixtures/answer.wasm` and invokes
   the exported `answer` function.
6. The host test observes exactly `42` as the program result and fails on any
   other result or non-zero exit status.
7. `cookbook/recipes/wip/wasmi/recipe.toml` is proven to build with the Redox
   Cookbook, or its remaining unverified step is clearly recorded in STATUS.md.
8. Reproduction instructions in README.md work from a fresh checkout.

A mocked command, host-native Wasmi execution, or a skipped QEMU launch does not
satisfy the integration test.

## Working method

Work incrementally. Keep the repository buildable and the current failure mode
visible.

For each failure:

1. Reproduce it with the smallest relevant command.
2. Record the exact failing layer: Cargo resolution, dependency portability,
   Rust target compilation, linking, Cookbook, Redox startup, guest execution,
   or result assertion.
3. Inspect upstream source before patching.
4. Prefer feature selection or an existing portable code path over new cfgs.
5. If a source change is necessary, make the smallest change that is sensible
   upstream.
6. Add or strengthen a regression test where practical.
7. Update STATUS.md after a meaningful milestone or newly discovered blocker.

Never hide a failure by weakening the smoke test.

## Portability rules

- Do not assume `target_os = "redox"` is equivalent to Linux.
- Be suspicious of `cfg(unix)` when the code actually relies on Linux-only
  APIs, signal behavior, `/proc`, epoll, or platform-specific libc details.
- Prefer Rust `std` abstractions where they already support Redox.
- Keep platform-specific code narrow and documented.
- Do not introduce unsafe code solely to bypass a dependency portability issue
  without first investigating a safe existing path.
- Do not disable WebAssembly validation to make the test pass.
- Do not enable WASI, even temporarily, unless the project scope is explicitly
  changed by the maintainer.

## Required validation commands

Run the narrowest relevant checks during development. Before calling a
milestone complete, run:

```sh
make check
make redox-build
make redox-test
```

For dependency-scope changes also inspect the Redox-target dependency tree and
confirm `wasmi_wasi` is absent.

## Test contract

The canonical fixture is `tests/fixtures/answer.wasm` with source documentation
in `tests/fixtures/answer.wat`.

Expected behavior:

```text
wasmi /root/fixtures/answer.wasm --invoke answer
```

must yield:

```text
42
```

The host-side test must compare the captured result, not merely the process exit
status.

## Cookbook work

Keep the candidate recipe under:

```text
cookbook/recipes/wip/wasmi/recipe.toml
```

It is intentionally marked WIP until tested with the real Cookbook. Once proven,
mirror the exact successful feature set used by the integration build.

Do not copy large amounts of Cookbook infrastructure into this repository. This
repository owns the candidate recipe and reproducible proof; Redox Cookbook
remains the source of truth for package mechanics.

## Codex agents

Focused agents are defined under `.codex/agents/`.

Use `redox_porter` for dependency/compile/link portability investigation and
minimal source fixes. Use `redox_test_investigator` for read-only analysis of
QEMU/redoxer/test failures.

Delegate independent investigation when useful, but the main agent owns final
integration and must verify agent findings before changing source.

## Plans and handoffs

For multi-step work, follow `PLANS.md`. Keep its current execution plan and
`STATUS.md` current enough that a new Codex session can continue without
reconstructing the project history from terminal logs.

Do not put speculative future features in the active execution plan.

## Git discipline

- Make small, intentional commits.
- Do not commit `target/`, downloaded Redox images, upstream Wasmi clones, or
  generated toolchains.
- Do not rewrite unrelated files while fixing a porting issue.
- Before committing a patch to upstream Wasmi source, document why it is needed
  and what upstream issue/PR it should become.
- Never commit credentials or local machine paths.
