---
description: "Comprehensive CLI operational recipes, query patterns, and command flags for AI agents."
tags:
  - cli
  - recipes
  - commands
  - ods
owner: team:ods
ods:
  profile: guide
  status: stable
---

# ODS CLI Command Recipes & Advanced Usage

This reference provides executable CLI patterns for AI agents navigating and manipulating ODS workspaces.

---

## 1. Workspace Orientation (`ods overview`)

Cold-start orientation snapshot (~100 tokens):

```bash
# Compact workspace summary (doc counts, profiles, status, top tags, daemon state)
ods overview

# Alias
ods summary
```

---

## 2. Advanced Discovery & Search (`ods find`)

The `ods find` command searches across document frontmatter metadata, tags, and statuses without full-text grep scans.

### Query Recipes

| Need | Command | Explanation |
|---|---|---|
| **Find by single key** | `ods find --key "status=stable"` | Matches documents where `ods.status` equals `stable`. |
| **Find with Boolean AND** | `ods find --key "status=draft" --key "owner=alice" --key-match and` | Matches documents satisfying **all** key predicates. |
| **Find with Boolean OR** | `ods find --key "status=draft,deprecated" --key-match or` | Matches documents where status is draft **or** deprecated. |
| **Filter by profile & tag** | `ods find --profile guide --tag auth` | Combines profile type with specific tag taxonomy. |
| **Search custom keys** | `ods find --key "service=billing"` | Works on arbitrary custom keys declared in frontmatter. |
| **JSON output for parsing** | `ods find --key "status=stable" --format json` | Returns structured JSON array of matching document IDs. |

---

## 3. Tag Taxonomy & Schema Inspection

```bash
# List all workspace tags with document counts
ods tag list

# Show all documents carrying a specific tag
ods tag show billing

# Perform workspace-wide tag renaming
ods tag rename legacy-auth auth-v2 --write

# Inspect frontmatter schema keys and placement (TopLevel vs NestedEngineMap)
ods schema keys
```

---

## 4. Bounded Context Loading (`ods context`)

The `ods context` command traverses the deterministic DAG (`depends` + `context.load`) to construct exact AI prompt packs.

### Execution Options

```bash
# 1. Inspect dependency DAG order (list of workspace-relative paths)
ods context billing/webhook-idempotency

# 2. Print full prompt pack (document prose + dependencies) under a strict token ceiling
ods context billing/webhook-idempotency --print --max-tokens 4000

# 3. Include implementation code bindings declared in ods.code
ods context billing/webhook-idempotency --print --include-code

# 4. Explain inclusion reasoning (shows why each hop was added)
ods context billing/webhook-idempotency --explain

# 5. Include soft related links (disabled by default to prevent prompt bloat)
ods context billing/webhook-idempotency --include-related
```

---

## 5. Fine-Grained Document Reading (`ods read`)

Extract only the precise section needed rather than reading entire documents.

### Heading Slicing Recipes

```bash
# 1. Slice a specific H2/H3 section (case-insensitive heading match)
ods read billing/webhook-idempotency --section "Steps"

# 2. Extract outline summary (headings + line numbers, no body text)
ods read billing/webhook-idempotency --summary

# 3. Apply soft token cap with fallback
ods read billing/webhook-idempotency --max-tokens 300

# 4. Format as structured JSON
ods read billing/webhook-idempotency --section "Prerequisites" --format json
```

---

## 6. Self-Healing Document Moves & Git Sync (`ods mv`, `ods sync`)

When renaming or reorganizing documents, **never** use standard `mv`. Use `ods mv` or `ods sync` to update references across the workspace.

```bash
# Atomically rename doc and update all depends/related/markdown links across workspace
ods mv auth/tokens.md auth/session-tokens.md

# Reconcile git-tracked renames (git status --porcelain) and update graph links
ods sync
```

---

## 7. Frontmatter Migration & Formatting (`ods fmt`)

Normalize frontmatter indentation, key ordering, and hoist misplaced keys.

```bash
# Lint formatting across workspace
ods fmt --check

# Auto-fix formatting and hoist misplaced tags/descriptions to top level
ods fmt --fix --migrate
```

---

## 8. Lifecycle Status Operations (`ods status`, `ods archive`)

```bash
# Update document status in place
ods status billing/refunds.md stable

# Archive a document in place
ods archive billing/refunds.md
```

---

## 9. ROI & Snapshot Benchmarking (`ods bench`)

```bash
# Audit workspace token economy & ROI stats
ods bench stats

# Losslessly restore frontmatter after snapshot benchmark runs
ods bench restore
```

---

## 10. Profile Inspection (`ods profile`)

Inspect profile schema contracts before authoring new documents.

```bash
# Show required headings and key policies for a profile
ods profile show feature

# Initialize a custom profile definition and register it in ods.toml
ods profile init incident
```
