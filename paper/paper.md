---
title: 'PPCSexRx: Prescribe Sub-Symptom Exercise for Adolescent Concussion'
tags:
  - R
  - clinical decision support
  - concussion
  - athletic training
  - education
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

`PPCSexRx` is an R package that encodes an evidence-informed clinical decision
support workflow for sub-symptom threshold aerobic exercise (SSTAE) in
adolescents with persistent post-concussion symptoms (PPCS). It provides
functions for eligibility screening, heart-rate target prescription
(Buffalo Concussion Treadmill Test–guided or age-predicted fallback), and
session-level progress tracking with explicit GRADE evidence disclosure
(@Li2026CAT; @PPCSexRxCRAN).

The package is intended for licensed athletic trainers and clinicians, and for
athletic training education programs that need an auditable, open rule engine
rather than a black-box calculator. Certainty of evidence for the underlying
recommendation is **LOW**; outputs are decision support, not a substitute for
clinical judgement.

# Statement of need

Adolescent PPCS care frequently requires structured aerobic prescription, yet
many training and practice settings lack standardized teaching tools that (1)
expose the evidence source for each rule, (2) handle missing BCTT equipment via
transparent fallbacks, and (3) can be embedded in CAATE laboratory instruction.
Existing concussion resources are often narrative guidelines or proprietary
apps that are difficult to audit in coursework.

`PPCSexRx` fills this gap by shipping a CRAN-installable rule engine derived
from a critically appraised topic (@Li2026CAT), with vignette documentation
suitable for classroom demonstration and research-protocol illustration.

# State of the field

Open-source athletic training software for SSTAE prescription is scarce.
Commercial concussion platforms may include exercise modules but are not
designed as citable, versioned research software with inspectable algorithms.
`PPCSexRx` does not replace comprehensive electronic health records; it
implements a narrow, documented prescription pathway for education and
protocol support.

# Software design

Core exported functions:

- `screen_ppcs()` — PICO-aligned eligibility / contraindication screening
- `prescribe_ppcs()` — BCTT-guided (80% of heart-rate threshold) or
  age-predicted fallback target heart rate
- `track_progress()` — session logging with stop-if-worsen rules

The package depends only on base R (`graphics`, `utils`) for runtime use,
keeping classroom installation friction low.

# Research and educational impact

`PPCSexRx` supports (a) reproducible encoding of SSTAE rules for manuscript and
protocol appendices, and (b) CAATE-oriented teaching modules that surface
evidence provenance ("why this prescription") alongside numeric targets. A
browser-based teaching shell built on the package is under development for
laboratory use; the CRAN package remains the stable algorithmic source.

# Acknowledgements

Evidence synthesis underlying the algorithms received the 2026 NATA Foundation
Best Summary Evidence Research Award (@Li2026CAT).

# AI usage disclosure

Generative AI tools were used as assistants during software and manuscript
preparation (including drafting and editing of documentation and this short
paper, and occasional code scaffolding or refactoring suggestions). Models
used included Cursor agent assistants and OpenRouter-hosted chat models
(notably `openai/gpt-5-mini` for routine drafting). The author reviewed,
edited, and validated all AI-assisted outputs; clinical rule design, GRADE
disclosure language, API choices, and test expectations were human decisions.
AI tools were not used to generate unsupervised conversational replies to
editors or reviewers.

# References
