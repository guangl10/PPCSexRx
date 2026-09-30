# `paper/archive/` — JOSS / paper document history

**Purpose:** Keep human-readable snapshots when `paper.md` (or related JOSS docs)
are substantially rewritten, so we can diff or roll back without digging only
through `git log`.

## Rules (do not skip)

1. **Before** a large rewrite of `paper/paper.md`, copy the current file to:
   `paper/archive/paper-YYYY-MM-DD-<label>.md`
2. Prefer labels like `pre-narrative-v2`, `pre-submit-trim`, `post-reviewer-pass1`.
3. **Do not delete** archive files; supersede by adding a newer snapshot.
4. Git commits remain the source of truth; this folder is for quick recovery and
   side-by-side reading.
5. Same habit for other JOSS-facing docs if rewritten in place:
   `joss-impact-log.md` → `archive/joss-impact-log-YYYY-MM-DD.md` when rows are
   bulk-edited or wiped (prefer append-only in the live log).

## Index

| File | Corresponds to | Notes |
|------|----------------|-------|
| `paper-2026-07-19-initial-scaffold.md` | commit `6b2b80d` era | First JOSS scaffold |
| `paper-2026-09-30-pre-narrative-v1.md` | commit `025e265` tip | Immediately before narrative rewrite `0c1f53f` |
| *(live)* `../paper.md` | `main` HEAD | Current submission draft |

## Restore

```bash
# preview
diff -u paper/archive/paper-YYYY-MM-DD-label.md paper/paper.md

# restore a snapshot to live (then commit)
cp paper/archive/paper-YYYY-MM-DD-label.md paper/paper.md
```
