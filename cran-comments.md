## Test environments

* local macOS 12.x, R 4.6.0 (x86_64), `devtools::check()` --- 0 errors, 0 warnings, 0 notes
* Win-builder R-devel ucrt --- 1 NOTE (`checking CRAN incoming feasibility`)

## R CMD check results

There were no ERRORs or WARNINGs.

There was 1 NOTE on Win-builder from `checking CRAN incoming feasibility`:

* **New submission:** This is the initial release of the package.
* **Possibly misspelled words:** The flagged terms 'SSTAE'
  (sub-symptom threshold aerobic exercise), 'PPCS' (persistent
  post-concussion symptoms), and 'BCTT' (Buffalo Concussion Treadmill
  Test) are standard clinical acronyms in concussion rehabilitation.
  BCTT and GRADE are now spelled out in full at first use in
  DESCRIPTION following reviewer feedback.

## Changes in this resubmission

* DESCRIPTION: spelled out BCTT (Buffalo Concussion Treadmill Test) and
  GRADE (Grading of Recommendations, Assessment, Development and
  Evaluation) at first occurrence.
* Added \value tags to all exported print/plot S3 method .Rd files
  (plot.ppcs_track, print.ppcs_prescription, print.ppcs_screen,
  print.ppcs_track).

## Background Information

This package implements clinical decision algorithms derived from a
systematic review honored by the 2026 NATA Foundation Best Summary
Evidence Research Award. The protocol is documented at
<doi:10.17605/osf.io/kvuf6>.
