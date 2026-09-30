---
title: 'PPCSexRx: Prescribe Sub-Symptom Exercise for Adolescent Concussion'
tags:
  - R
  - clinical decision support
  - concussion
  - athletic training
  - education
  - open science
authors:
  - name: Guang Li
    orcid: 0009-0004-2807-9029
    affiliation: "1"
affiliations:
  - name: Idaho State University
    index: 1
date: 30 September 2026
bibliography: paper.bib
---

# Summary

`PPCSexRx` is research software that turns an award-winning evidence synthesis
on adolescent persistent post-concussion symptoms (PPCS) into an **auditable,
versioned rule engine** for sub-symptom threshold aerobic exercise (SSTAE)
prescription [@Li2026CAT; @PPCSexRxCRAN]. Rather than leaving GRADE-rated
guidance only in narrative form, the package encodes the bedside sequence
clinicians and educators actually rehearse:

```text
screen_ppcs()  →  prescribe_ppcs()  →  track_progress()
```

Each step returns structured objects with method labels, GRADE disclosure, and
safety language so users can see *why* a target heart rate was produced—not
only the number. When a Buffalo Concussion Treadmill Test (BCTT) symptom
threshold is available, prescription anchors to 80% of that threshold; when it
is not, the package uses a transparent age-predicted fallback and names that
path explicitly. Runtime depends only on base R, which keeps classroom and
clinic installation friction low.

The intended users are licensed athletic trainers and clinicians, and athletic
training education programs that need inspectable algorithms for laboratory
teaching and protocol appendices. Underlying recommendation certainty remains
**LOW** (conditional recommendation); outputs are decision support, never a
substitute for clinical judgement.

# Statement of need

SSTAE is widely discussed in concussion care, yet two practical gaps block
reproducible use in research training and CAATE-aligned education:

1. **Opaque tooling.** Many available calculators and commercial modules hide
   dosing rules, evidence provenance, and stop conditions—unsuitable when
   students must defend a prescription or when a manuscript needs an
   appendable, citable algorithm.
2. **Resource-aware fidelity.** Real settings often lack BCTT equipment.
   Educators still need a path that is *honest about fallbacks* rather than
   silently inventing precision.

Open, language-native research software for this narrow pathway is scarce.
Guideline PDFs and proprietary apps do not give instructors a CRAN-installable
object they can cite, test, and embed in labs.

`PPCSexRx` addresses the gap by shipping the Li (2026) critically appraised
topic as executable R functions with vignettes that demonstrate (a) BCTT-guided
prescription, (b) hard eligibility stops before the PPCS window, and
(c) age-predicted fallback when `hrst` is unavailable—including explicit
language about what that fallback is *not* (not an individualized threshold,
not RTP clearance).

# Software design

| Function | Role |
|----------|------|
| `screen_ppcs()` | PICO-aligned eligibility and referral routing (timing, age band, vestibular/cervical/vision flags) |
| `prescribe_ppcs()` | BCTT-guided or age-predicted target heart rate with method + GRADE fields |
| `track_progress()` | Session log with stop-if-worsen / progression rules tied to the CAT |

Design constraints deliberately favor teaching and protocol use: no proprietary
runtime, no hidden model weights, and no Bayesian extension in the CRAN 0.1.1
line. A separate teaching shell can call the same engine for
predict–observe–explain cases; the package remains the citable algorithmic
source of truth.

# Research and educational impact

The package is the software layer of a larger evidence-to-education arc:

- **Evidence provenance.** Algorithms implement a CAT recognized with the 2026
  NATA Foundation Best Summary Evidence Research Award [@Li2026CAT].
- **Citability.** Version 0.1.1 is on CRAN and archived on Zenodo
  [@PPCSexRxCRAN], so protocols and education grants can point to a stable DOI.
- **Teaching translation.** A public concept trailer for CAATE-oriented SSTAE
  competency training (`https://guanglab.org/cstt-demo/`) consumes these rules
  so students practice workflow execution and boundary judgment with visible
  “Why this Rx” rationale. The package—not the browser shell—is what this JOSS
  paper submits.
- **Grant-facing preliminary use.** The same 0.1.1 engine was cited as the
  algorithmic preliminary in a 2026 NATA Foundation Athletic Training Education
  and Practice pre-proposal (CSTT), keeping software claims scoped to education
  feasibility rather than patient-outcome efficacy.

`PPCSexRx` does not claim broad clinical adoption; it claims a **reproducible
encoding** of LOW-certainty SSTAE rules that educators and researchers can
install, inspect, and cite.

# Acknowledgements

Evidence synthesis underlying the algorithms received the 2026 NATA Foundation
Best Summary Evidence Research Award [@Li2026CAT]. Idaho State University
athletic training colleagues provided formative feedback on teaching-facing
boundaries for the companion education project; they are not co-authors of this
software paper unless separately agreed.

# AI usage disclosure

Generative AI tools assisted with documentation and this short paper (drafting
and editing) and with occasional code scaffolding or refactoring suggestions.
Tools included Cursor agent assistants and OpenRouter-hosted chat models
(notably `openai/gpt-5-mini` for routine drafting). The author reviewed,
edited, and validated all AI-assisted outputs. Clinical rule design, GRADE
disclosure wording, API choices, and test expectations were human decisions.
AI tools were not used for unsupervised conversational replies to editors or
reviewers.

# References
