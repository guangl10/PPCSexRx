# Contributing to PPCSexRx

Thanks for interest in improving PPCSexRx. This package encodes an
evidence-informed SSTAE prescription workflow for adolescent PPCS
(**GRADE LOW** certainty). Changes that affect clinical rule logic need
extra care.

## Ways to contribute

1. **Bug reports** — open a GitHub Issue with a minimal reproducible example
   (`reprex` welcome).
2. **Documentation** — vignette clarity, man-page fixes, typos.
3. **Tests** — edge cases for `screen_ppcs()`, `prescribe_ppcs()`,
   `track_progress()`.
4. **Pull requests** — small, focused PRs preferred.

## Development setup

```r
# clone, then from package root:
install.packages(c("devtools", "testthat", "knitr", "rmarkdown"))
devtools::load_all()
devtools::test()
devtools::check()
```

## Documentation history (JOSS / paper)

Substantial rewrites of `paper/paper.md` must leave a snapshot under
`paper/archive/` *before* replacing the live file. See
[`paper/archive/README.md`](paper/archive/README.md). Prefer append-only edits
to `paper/joss-impact-log.md`.

## Pull request expectations

- Do not change clinical thresholds, GRADE language, or safety/hold rules
  without citing the evidence source and explaining why.
- Add or update `testthat` coverage for behavior changes.
- Keep the public API stable unless the change is clearly justified in the PR.
- Run `devtools::check()` locally before requesting review.
- One concern per PR when practical.

## Code of conduct (light)

Be respectful in issues and reviews. This is a clinical-education tool used
around vulnerable populations; speculative or unsafe “quick hacks” to dosing
rules will be closed.

## Maintainer support

- **Maintainer:** Guang Li (`contact@guanglab.org`)
- **Issues:** https://github.com/guangl10/PPCSexRx/issues
- **Response expectation:** best-effort within ~2 weeks for actionable bugs;
  feature requests may be deferred until after JOSS / teaching-module milestones.
- **Scope:** v0.1.x remains the CRAN rule engine. Bayesian / v0.2 work is out of
  scope for routine contributions unless coordinated with the maintainer.
