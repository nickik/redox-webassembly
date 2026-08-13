# Testing

## Host-only checks

`make check` is designed to work without downloading Wasmi or booting Redox. It
verifies shell syntax and the canonical WebAssembly fixture.

## Redox integration test

`make redox-test` is the key acceptance test. It performs these steps:

1. Validate the fixture.
2. Fetch the pinned upstream Wasmi source if needed.
3. Assert the chosen CLI feature graph excludes `wasmi_wasi`.
4. Cross-build the CLI with `redoxer build`.
5. Locate and record the Redox-target Wasmi executable.
6. Invoke `redoxer exec` with the fixture directory mapped to `/root/fixtures`.
7. `redoxer` boots a Redox image in QEMU and copies the requested files into
   the guest.
8. The guest executes:

   ```text
   wasmi /root/fixtures/answer.wasm --invoke answer
   ```

9. The host compares the complete captured command output to `42`.

The test deliberately does not accept "contains 42". Unexpected diagnostic
output should be investigated rather than hidden.

## Why `redoxer exec`

Raw QEMU scripting would force this repository to manage boot images, disk
mutation, guest file transfer and shutdown/result extraction. `redoxer exec`
already exists specifically to run a command in a Redox QEMU environment and is
therefore the narrower, maintainable integration boundary.

## CI

The lightweight CI workflow runs host-only checks. The full Redox workflow is
manual initially because it installs a Redox toolchain and boots QEMU. Once the
flow proves reliable and runtime is known, it can be enabled for pull requests
or scheduled runs.
