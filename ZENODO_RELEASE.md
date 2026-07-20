# Zenodo DOI for PPCSexRx 0.1.1 — release checklist

Branch: `zenodo-0.1.1-archive` (from `main` @ 0.1.1)

Prepared in-repo:
- `CITATION.cff` — GitHub “Cite this repository”
- `.zenodo.json` — Zenodo metadata on release
- `inst/CITATION` — includes CRAN DOI `10.32614/CRAN.package.PPCSexRx`
- `paper/paper.md` + `paper/paper.bib` — JOSS draft (optional next)

## Why you must click once (cannot be automated here)

Zenodo mints a DOI only after:
1. You enable the GitHub↔Zenodo webhook on **your** Zenodo account, and
2. A **new** GitHub Release is created **after** that switch is On.

There is no MCP/API path from this Cursor agent to flip your Zenodo toggle.

## Steps (≈15–30 min once PR/merge is done)

### A. Land this branch on public `main`

```bash
# After review — Jack must explicitly OK push
git push -u origin zenodo-0.1.1-archive
# Then merge to main on GitHub (PR) or:
# git checkout main && git merge zenodo-0.1.1-archive && git push origin main
```

### B. Enable Zenodo (one-time)

1. Open https://zenodo.org and **Log in with GitHub** (`guangl10`).
2. Go to https://zenodo.org/account/settings/github/
3. Find **`guangl10/PPCSexRx`** → toggle **ON**.
4. If the repo is missing, click **Sync now**.

### C. Create GitHub Release `v0.1.1`

Must be **after** step B.

- Tag: `v0.1.1` (exact; matches DESCRIPTION Version 0.1.1)
- Target: `main` (commit that contains `.zenodo.json`)
- Title: `PPCSexRx 0.1.1`
- Body (suggested):

```text
CRAN release 0.1.1 (2026-06-15).

- Maintainer: contact@guanglab.org
- CRAN DOI: https://doi.org/10.32614/CRAN.package.PPCSexRx
- Evidence CAT: https://doi.org/10.17605/osf.io/kvuf6

This GitHub release triggers Zenodo archival for a version DOI.
```

UI: GitHub → Releases → Draft a new release → choose tag `v0.1.1` → Publish.

CLI (if `gh` installed):

```bash
gh release create v0.1.1 --target main --title "PPCSexRx 0.1.1" --notes-file - <<'EOF'
CRAN release 0.1.1 (2026-06-15).
CRAN DOI: https://doi.org/10.32614/CRAN.package.PPCSexRx
EOF
```

### D. Capture the DOI

1. Wait 1–5 minutes; check Zenodo account → Uploads.
2. Copy the **version DOI** (and concept DOI).
3. Paste into README badge slot and tell Cursor to update `CITATION.cff` / `inst/CITATION` with the Zenodo DOI (follow-up commit).

### E. Optional JOSS (does not block Zenodo)

```bash
# After Zenodo DOI exists, add it to paper.md if desired, then:
# Submit at https://joss.theoj.org/papers/new
# repo: guangl10/PPCSexRx , paper path: paper/paper.md
```

## Do not

- Release from `v0.2.0-dev` (wrong version for this archival).
- Put Bayesian / v0.2 code into this 0.1.1 release tag.
- Claim “Zenodo DOI exists” in NATA pre-proposal until step D is done.
