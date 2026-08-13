# Porting notes

## First principle

Try to build upstream Wasmi unchanged. A Redox target with Rust `std` support
should not require an operating-system shim merely to interpret core
WebAssembly.

## Failure classification

When `make redox-build` fails, classify the first failure before editing code:

1. Cargo feature/dependency selection.
2. A dependency does not support Redox.
3. Wasmi contains an OS/architecture-specific assumption.
4. Rust target/toolchain issue.
5. Linker/relibc issue.
6. redoxer/Cookbook integration issue.

A later error is not useful until the earliest failure is resolved.

## Patching upstream

If Wasmi itself needs a patch:

- prefer a portable implementation over `#[cfg(target_os = "redox")]` when
  possible;
- make the smallest coherent change;
- add a test that also runs on an upstream-supported host when possible;
- record the intended upstream issue/PR in STATUS.md;
- do not vendor the entire Wasmi repository into this project.

## Dependency guard

`scripts/check-no-wasi.sh` evaluates the selected CLI dependency graph and
fails if `wasmi_wasi` appears. Keep this guard while WASI remains out of scope.
