# Changelog — ods skill

## Unreleased

### Changed & Fixed
- **Strict `ods.toml` Workspace Boundary Alignment (`WS-001`)**: Updated `SKILL.md`, `evals/evals.json`, `scripts/bootstrap.sh`, and `scripts/bootstrap.ps1` to resolve workspace roots exclusively via root `ods.toml` (`spec = "0.1"`). Eradicated all stale references to root `index.md` or `ods:` frontmatter as workspace boundaries.
- **Language Server Protocol Integration (`ods lsp`)**: Added complete `ods lsp` JSON-RPC 2.0 reference guide (`references/lsp.md`) and editor configuration snippets for Zed, VS Code, Neovim, and Helix in `SKILL.md` §9.
- **Installer Script & GitHub Repository Audit**: Synchronized GitHub release repository parameters to `open-doc-spec/ods` across `install.sh`, `install-from-release.sh`, `install.ps1`, `bootstrap.sh`, and `bootstrap.ps1`. Fixed PowerShell bootstrap function calls to eliminate redundant CLI namespaces.
- **5W1H Directives & Tiered CLI Matrix**: Aligned `SKILL.md` with updated CLI help, including 5W1H operational directives, 5-phase token discipline playbook, multi-spec flag policies (`--okf`, `--skills`), and 4-tier CLI mastery matrix (Novice, Practitioner, Power User, Architect).
- **Reference Catalog & Token Economy Expansion**: Updated `cli-recipes.md`, `token-economy.md`, and `references/index.md` with commands: `ods overview` / `summary`, `ods find --key`, `ods tag list` / `show` / `rename`, `ods schema keys`, `ods sync`, `ods share --out`, `ods status`, `ods bench stats` / `restore`, and satellite spec pointers (`open-doc-spec/ods-spec`).

### Added
- Initial `ods` Agent Skill with 13 standard profile contracts, 3-tier key placement rules, and custom profile schema policies.
- Single-entrypoint bootstrap scripts (`bootstrap.sh` and `bootstrap.ps1`).
- Evals suite in `evals/evals.json` covering cold-starts, PRD/ADR authoring, non-goal guardrails, share filtering, and git-rename reconciliation.
