# Architecture

This repository is an integration and packaging harness, not a Wasmi fork.

```text
Wasmi upstream source
        |
        | redoxer build
        v
x86_64-unknown-redox executable
        |
        | redoxer exec
        v
QEMU -> Redox OS -> wasmi -> answer.wasm -> 42
```

## Layers

### Upstream Wasmi

Fetched at a pinned release into `target/upstream/wasmi`. The CLI is built with
WASI disabled. Source modifications should be treated as candidate upstream
patches, not permanent vendored code.

### Redox tooling

`redoxer` owns target-toolchain setup and VM execution. This project does not
maintain its own Redox boot image or QEMU command line unless redoxer proves
insufficient.

### Smoke fixture

The initial fixture has no imports and exercises only core WebAssembly function
execution. That is deliberate: filesystem, environment, clocks, sockets and
other WASI concerns cannot contaminate the first portability milestone.

### Cookbook recipe

The candidate recipe mirrors the feature set used by the integration harness.
Once proven, it should be submitted to Redox Cookbook.
