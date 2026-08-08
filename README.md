# ods-skills

End-user **Agent Skills** for Open Document Spec (`ods`).

First-cut extract from monorepo `skills/ods/`.

## Layout

```
skills/
  ods/           # ODS product skill
    SKILL.md
    references/
    scripts/
    evals/
    CHANGELOG.md
```

Skill path: **`skills/ods/`** (not repository root).

## Source of truth

| Concern | Repo |
|---------|------|
| End-user skills | **This repo** (SoT after merge) |
| Normative specs | [open-doc-spec/ods-spec](https://github.com/open-doc-spec/ods-spec) |
| Engine / CLI | [open-doc-spec/ods](https://github.com/open-doc-spec/ods) |
| Install scripts (canonical) | monorepo `src/scripts/` — keep `skills/ods/scripts/install-from-release.sh` in sync |

## First-cut policy

Monorepo still mirrors `skills/ods/` until a later hard-delete PR.
