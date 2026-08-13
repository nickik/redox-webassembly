# Execution Plans

This file defines how Codex should plan non-trivial work in this repository and
contains the active initial plan.

## Plan format

An execution plan should be self-contained enough that a new agent can continue
from the repository alone. Keep it concise and update it as facts change.

Each plan should contain:

- **Goal**: externally observable result.
- **Constraints**: hard scope boundaries.
- **Current evidence**: commands/results already established.
- **Milestones**: ordered, independently verifiable steps.
- **Decision log**: important choices and why they were made.
- **Blockers**: exact unresolved failures, not vague descriptions.
- **Verification**: commands that prove completion.

When a milestone completes, mark it complete and record the command that proved
it. Do not mark future work complete based on static inspection alone.

---

# Active plan: first Redox Wasmi package

## Goal

From a clean Linux host with Rust, QEMU and redoxer available, `make redox-test`
must cross-compile the Wasmi CLI for Redox, boot Redox in QEMU, run a core-Wasm
fixture inside the guest, invoke `answer`, observe `42`, and exit successfully.

## Constraints

- No WASI.
- x86_64 Redox only for the first milestone.
- Use upstream Wasmi rather than maintaining a fork.
- Use `redoxer exec` as the VM test boundary unless concrete evidence shows it
  cannot support the test.
- Keep any Wasmi patches minimal and upstreamable.

## Current evidence

- Redox `redoxer` supports cross-building and `exec` inside a QEMU Redox image.
- Wasmi v2.0.0-beta.10 makes the CLI's `wasmi_wasi` dependency optional.
- The chosen no-WASI feature set is centralized in `scripts/common.sh`.
- The repository contains a deterministic WebAssembly fixture returning 42.
- Repository scaffolding and host-only checks are present.

## Milestone 0 — repository scaffold

Status: complete.

Success criteria:

- Git repository initialized.
- Codex instructions, helper agents, scripts, fixture, candidate recipe and CI
  skeleton present.
- `make check` succeeds without requiring network access or Redox.

## Milestone 1 — first Redox cross-build

Status: pending real Redox toolchain execution.

Steps:

1. Run `make prerequisites`.
2. Run `redoxer toolchain` if necessary.
3. Run `make redox-build`.
4. If Cargo resolution or compilation fails, identify the first dependency or
   Wasmi source location that is not Redox-compatible.
5. Verify the build did not enable `wasmi_wasi`.
6. Record any source patch and its upstream rationale in STATUS.md.

Success criterion:

- A Redox `wasmi` executable is produced and its path is recorded under
  `target/wasmi-bin.path` by the build script.

## Milestone 2 — QEMU smoke test

Status: pending Milestone 1.

Steps:

1. Run `make redox-test`.
2. Confirm `redoxer exec` copies the Wasmi executable and fixture directory into
   the guest.
3. Confirm the process that returns `42` is the Redox Wasmi executable, not a
   host binary.
4. Make result capture robust to redoxer/QEMU diagnostic output without
   accepting arbitrary output.

Success criterion:

- `make redox-test` exits 0 and prints its PASS line only after exact result
  comparison succeeds.

## Milestone 3 — prove Cookbook recipe

Status: pending.

Steps:

1. Place/copy `cookbook/recipes/wip/wasmi/recipe.toml` into an up-to-date Redox
   Cookbook checkout.
2. Build the recipe using Cookbook tooling.
3. Install the produced package into a Redox image or otherwise verify the
   packaged binary in Redox.
4. Align recipe flags with `scripts/common.sh`.
5. Replace temporary source pinning with the form expected by Cookbook policy.

Success criterion:

- Cookbook itself produces the working Wasmi package with no WASI dependency.

## Milestone 4 — upstream-quality cleanup

Status: pending.

Steps:

1. Move to a stable Wasmi 2.x release when suitable.
2. Submit any necessary Wasmi portability change upstream.
3. Prepare the Redox Cookbook recipe for upstream submission.
4. Keep this repository as the reproducible integration-test harness if it
   remains useful.

## Decision log

### 2026-08-13 — use `redoxer exec`, not a custom raw-QEMU harness

`redoxer exec` already handles Redox image initialization, copying files into
the guest, booting QEMU, running a guest command and exposing command output.
Using it keeps this project focused on Wasmi packaging rather than maintaining a
second Redox VM launcher.

### 2026-08-13 — start with Wasmi v2.0.0-beta.10

Wasmi 1.1.0's CLI has an unconditional `wasmi_wasi` dependency. The 2.0 beta
makes WASI optional and therefore fits the explicit no-WASI milestone. Upgrade
when a suitable stable 2.x release exists.

### 2026-08-13 — prefer portable dispatch initially

The initial CLI feature set enables Wasmi's portable dispatch path. This lowers
the amount of architecture/toolchain-specific behavior involved in the first
Redox bring-up. Revisit only after the baseline works.

## Blockers

No end-to-end Redox build or QEMU run has yet been executed in the repository's
creation environment. First real execution on a host with network access,
Redox toolchain and QEMU is the next required evidence.

## Verification

Final first-milestone verification:

```sh
make check
make redox-build
make redox-test
```
