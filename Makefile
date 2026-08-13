.PHONY: prerequisites check codex upstream no-wasi redox-build redox-test test clean

prerequisites:
	./scripts/prerequisites.sh

check:
	@for script in scripts/*.sh; do bash -n "$$script"; done
	./scripts/check-config.sh
	./scripts/test-fixture.sh

codex:
	./scripts/codex-next.sh

upstream:
	./scripts/fetch-upstream.sh

no-wasi:
	./scripts/check-no-wasi.sh

redox-build:
	./scripts/build-redox.sh

redox-test:
	./scripts/test-redox.sh

test:
	./scripts/test-all.sh

clean:
	rm -rf target
