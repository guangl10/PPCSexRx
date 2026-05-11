#' Sub-symptom Threshold Exercise Prescription for PPCS
#'
#' Implements the 2026 NATA Foundation Best Summary Evidence Research award-winning
#' protocol for adolescents with persistent post-concussion symptoms.
#'
#' @param age Age in years (13-18)
#' @param hrst Heart rate at symptom threshold from Buffalo Concussion Treadmill Test. If NULL, uses age-predicted.
#' @param symptom_worse Logical. Did symptoms worsen in last session? Default FALSE.
#' @param sessions Sessions completed at current HR. Default 0.
#' @references Li G. (2026). Sub-symptom Threshold Aerobic Exercise for Adolescents
#' With PPCS: A Critically Appraised Topic. Winner, NATA Foundation Student Writing Contest.
#' @return List with target_hr, duration_min, frequency_per_week, method, clinical_note
#' @export
#' @examples
#' prescribe_ppcs(age = 16, hrst = 160)
prescribe_ppcs <- function(age, hrst = NULL, symptom_worse = FALSE, sessions = 0) {
  if (!is.null(hrst)) {
    target_hr <- round(0.8 * hrst)
    method <- "BCTT-guided"
  } else {
    hr_max <- 220 - age
    target_hr <- round(0.65 * hr_max)
    method <- "Age-predicted"
  }
  if (symptom_worse) {
    target_hr <- target_hr - 10
    note <- "Symptom worsening: decrease by 10 bpm"
  } else if (sessions >= 2) {
    target_hr <- target_hr + 7.5
    note <- "No worsening: progress by 5-10 bpm"
  } else {
    note <- "Maintain current HR"
  }
  list(
    target_hr = round(target_hr),
    duration_min = 20,
    frequency_per_week = 5,
    method = method,
    clinical_note = note,
    evidence = "NATA Foundation 2026 Best Summary Evidence Research"
  )
}