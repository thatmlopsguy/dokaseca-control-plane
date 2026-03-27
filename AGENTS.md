# AGENTS.md

Agent-focused notes for this repo (infra/config + automation for Kubernetes platform stacks using Kind/k3d, Terraform/OpenTofu, GitOps).

## Source Of Truth

- Pre-commit hooks: `.pre-commit-config.yaml` (note: `third_party/` is excluded; ignore this folder during automated checks and manual edits unless explicitly required)
- Formatting: `.editorconfig` (LF, final newline, max line length 120)
- Markdown lint: `.markdownlint.yaml`
- Shell lint: `.shellcheckrc`
- Terraform lint/docs: `.tflint.hcl`, `.terraform-docs.yml`
- ADRs: `docs/adr/adr_template.md`, `adrgen.config.yml`

If guidance conflicts, prefer these config files.

## Build / Lint / Test

```bash
# discover targets
make help
just --list

# CI-equivalent lint gate
make pre-commit-run

# terraform
make terraform-fmt
make terraform-lint
make terraform-docs

# docs (mkdocs)
make docs-build
make docs-serve

# smoke checks
bash tests/cilium-test.sh
```

Notes:

- Local tooling is managed via `uv`/`uvx` in the Makefile;
- Use `docker compose` (not `docker-compose`).

## Running A Single Check / Single Test

Pre-commit (fast iteration):

```bash
pre-commit run --list
pre-commit run <hook-id> --files path/to/file1 path/to/file2
```

Shellcheck one script:

```bash
shellcheck --rcfile=.shellcheckrc scripts/some-script.sh
```

Terraform for one module/directory:

```bash
terraform fmt -recursive terraform/modules/<module>
tflint --init
tflint --recursive --config=".tflint.hcl" --minimum-failure-severity=warning
```

## Code Style Guidelines

General:

- Keep changes small and follow existing patterns; prefer stable ordering in config files.
- Do not commit secrets; pre-commit runs `detect-private-key` and `gitleaks`.
- Avoid editing `third_party/`.

Markdown:

- Prefer wrapping prose to 120 chars (even though markdownlint allows long lines here).
- Use fenced code blocks with language tags.
- ADRs must match `docs/adr/adr_template.md` and be generated/managed per `adrgen.config.yml`.

YAML:

- 2-space indent; keep keys ordered consistently with surrounding files.

Shell (bash):

- For non-trivial scripts use strict mode: `set -euo pipefail`.
- Quote variables; prefer `${var}` (ShellCheck enforces `require-variable-braces`).
- Error handling: validate prerequisites early (`command -v`, file existence); fail fast with clear messages.

Terraform/OpenTofu:

- Always run `terraform fmt` on touched modules.
- Follow `.tflint.hcl` rules: typed variables, described variables/outputs, `snake_case` naming, no deprecated patterns.
- Module docs are generated with `terraform-docs -c .terraform-docs.yml` (writes `README.md` per module).

Naming:

- Terraform: `snake_case` for variables/locals/outputs/resources.
- Bash: `lower_snake_case` for functions/vars; uppercase for exported env vars.

## Agent Behaviors

- Prefer `make pre-commit-run` as the default "quality gate" before declaring work done.
- Avoid changing generated files unless the task requires it (e.g., Terraform module `README.md` from `terraform-docs`).
- Keep edits ASCII-only unless a file already uses Unicode.
- Use `docker compose` instead of `docker-compose` (deprecated)

## Workflow Notes / Gotchas

- Semantic PR titles are enforced (see `.github/workflows/check-semantic-prs.yml`); use prefixes like `feat:`, `fix:`, `docs:`, `chore:`.
- `third_party/` is excluded from repo-level pre-commit; run checks manually inside that subtree if you change it.

## Before PR (Quick)

```bash
make pre-commit-run
make terraform-fmt
make terraform-lint
make docs-build
```
