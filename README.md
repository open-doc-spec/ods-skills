# ods-skills

End-user **Agent Skill** for Open Document Spec (`ods`).

First-cut extract from monorepo `skills/ods/`. Skill files live at **repository root** (`SKILL.md`).

## Source of truth

| Concern | Repo |
|---------|------|
| End-user skill | **This repo** (SoT after merge) |
| Normative specs | [open-doc-spec/ods-spec](https://github.com/open-doc-spec/ods-spec) |
| Engine / CLI | [open-doc-spec/ods](https://github.com/open-doc-spec/ods) |
| Install scripts (canonical) | monorepo `src/scripts/` — keep `scripts/install-from-release.sh` in sync |

## Layout

- `SKILL.md` — skill entry
- `references/` — condensed operational docs
- `scripts/` — bootstrap / install helpers
- `evals/` — skill evals

## First-cut policy

Monorepo still mirrors `skills/ods/` until a later hard-delete PR.
