# PPCSexRx

**Prescribe Sub-Symptom Exercise for Adolescent Concussion**

Clinical decision support R package for sub-symptom threshold aerobic exercise
(SSTAE) in adolescents with persistent post-concussion symptoms (PPCS).
Implements an evidence-based protocol from Li (2026), winner of the **2026 NATA
Foundation Best Summary Evidence Research Award**.

> **GRADE:** LOW certainty | Conditional recommendation **FOR**  
> For licensed clinicians only. Not a substitute for clinical judgement.

**Evidence synthesis:** [OSF 10.17605/osf.io/kvuf6](https://doi.org/10.17605/osf.io/kvuf6)  
**Project site:** [guanglab.org](https://guanglab.org)

---

## Features

| Function | Purpose |
|----------|---------|
| `screen_ppcs()` | Eligibility and safety screening |
| `prescribe_ppcs()` | BCTT-guided (80% HRST) or age-predicted prescription |
| `track_progress()` | Session log, HR progression, stop-if-worsen rules |

---

## Installation

```r
install.packages("PPCSexRx")
```

**Requirements:** R ≥ 4.0

---

## Quick start

```r
library(PPCSexRx)

screen_ppcs(age = 16, days_post_injury = 35)
rx <- prescribe_ppcs(age = 16, days_post_injury = 35, hrst = 165)
print(rx)

log <- NULL
tr <- track_progress(log, pcss = 30, duration_min = 20, achieved_hr = 120, rx)
```

See `vignette("PPCSexRx")` after installation.

---

## Citation

Primary evidence synthesis:

> Li G (2026). Sub-symptom Threshold Aerobic Exercise for Adolescents With PPCS:
> A Critically Appraised Topic. Winner, 2026 NATA Foundation Best Summary Evidence
> Research Award. <https://doi.org/10.17605/osf.io/kvuf6>

---

## License

MIT — see [LICENSE](LICENSE).

## Author

**Guang Li** — [contact@guanglab.org](mailto:contact@guanglab.org)  
PhD Student, Idaho State University · [Guang Lab](https://guanglab.org)  
[ORCID 0009-0004-2807-9029](https://orcid.org/0009-0004-2807-9029)
