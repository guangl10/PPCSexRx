#' Prescribe Sub-symptom Aerobic Exercise for Adolescent PPCS
#'
#' Implements the evidence-based protocol from Li (2026). GRADE: LOW certainty,
#' Conditional recommendation FOR. Run \code{\link{screen_ppcs}} first to
#' confirm eligibility.
#'
#' @param age Numeric. Age 13-18 years. CAT p.2, L10: inclusion 13-18.
#' @param days_post_injury Numeric. Days since injury. Must be >=28 for PPCS.
#'   CAT p.2, L10.
#' @param hrst Numeric or NULL. Symptom threshold HR from BCTT (bpm).
#'   If NULL, age-predicted fallback is used. CAT p.11, L19.
#' @param vestibular_symptoms Logical. TRUE = contraindication. CAT p.11, L25.
#' @param cervical_symptoms Logical. TRUE = contraindication. CAT p.11, L25.
#' @param sessions_completed Integer. Sessions at current HR without worsening.
#'   CAT p.11, L21.
#' @param last_session_worse Logical. Did PCSS increase >=2 points last session?
#'   CAT p.11, L21-22.
#'
#' @return An object of class \code{ppcs_prescription} with prescription details.
#'
#' @references
#' Li G. (2026). Sub-symptom Threshold Aerobic Exercise for Adolescents
#' With PPCS: A Critically Appraised Topic. Winner, NATA Foundation Student
#' Writing Contest.
#'
#' @export
#' @examples
#' # Case 1: Rural clinic, no BCTT available
#' prescribe_ppcs(age = 16, days_post_injury = 35)
#'
#' # Case 2: University clinic with BCTT data
#' prescribe_ppcs(age = 17, days_post_injury = 40, hrst = 160)
#'
#' # Case 3: Safety stop - vestibular symptoms present
#' try(prescribe_ppcs(age = 15, days_post_injury = 30,
#'                    vestibular_symptoms = TRUE))
prescribe_ppcs <- function(age,
                           days_post_injury,
                           hrst                 = NULL,
                           vestibular_symptoms  = FALSE,
                           cervical_symptoms    = FALSE,
                           sessions_completed   = 0,
                           last_session_worse   = FALSE) {

  # --- Input validation ---
  if (!is.numeric(age) || length(age) != 1)
    stop("'age' must be a single number.")
  if (!is.numeric(days_post_injury) || length(days_post_injury) != 1)
    stop("'days_post_injury' must be a single number.")

  # 1. Age guardrail: CAT p.2, L10. Warning not error for off-label use.
  if (age < 13 || age > 18) {
    warning("Caution: CAT inclusion criteria specifies ages 13-18. ",
            "Efficacy outside this range is unverified (Li, 2026).")
  }

  # 2. Safety screening: CAT p.11, L25-26. Hard stops.
  if (days_post_injury < 28) {
    stop("Contraindicated: PPCS defined as >=28 days post-injury. ",
         "See Li (2026), p.2.")
  }
  if (vestibular_symptoms || cervical_symptoms) {
    stop("Contraindicated: Uncontrolled vestibular/cervical symptoms. ",
         "Requires PT clearance first. See Li (2026), p.11.")
  }

  # 3. Age-predicted HRmax for guardrails
  hr_max <- 220 - age

  # 4. Initial HR target: CAT p.11, L19-21.
  #    BCTT preferred; age-predicted as fallback.
  if (!is.null(hrst)) {
    if (!is.numeric(hrst) || hrst <= 0)
      stop("'hrst' must be a positive number.")
    target_hr <- round(0.8 * hrst)
    method    <- "BCTT-guided: 80% of symptom threshold HR"
  } else {
    target_hr <- round(0.65 * hr_max)   # mid-point of 60-70% range
    method    <- "Age-predicted: 60-70% HRmax (BCTT unavailable)"
  }

  # 5. Progression rule: CAT p.11, L21-22.
  #    Initialise note before branching to avoid undefined variable.
  note <- "Maintain current intensity. Monitor weekly for tolerance."

  if (last_session_worse) {
    target_hr <- target_hr - 10
    note      <- paste0("Symptom worsening detected: target HR decreased by 10 bpm. ",
                        "Resume prior intensity once baseline symptoms return. ",
                        "Stop-if-worsen rule applied (Li, 2026, p.14).")
  } else if (sessions_completed >= 2) {
    target_hr <- target_hr + 5
    note      <- paste0("No worsening for ", sessions_completed,
                        " sessions: target HR increased by 5 bpm. ",
                        "Re-assess after next session (Li, 2026, p.14).")
  }

  # 6. HR guardrails: floor 80 bpm, ceiling hr_max - 10
  target_hr <- max(80, min(target_hr, hr_max - 10))

  # 7. Build S3 prescription object with GRADE disclosure.
  res <- list(
    target_hr        = target_hr,
    duration_min     = 20,
    frequency_per_week = 5,
    method           = method,
    clinical_note    = note,
    safety_warning   = paste0("Clinician supervision required. ",
                              "Stop if symptoms worsen >= 2 PCSS points. ",
                              "See Li (2026), p.14."),
    evidence_grade   = paste0("GRADE: LOW certainty. Conditional recommendation FOR. ",
                              "See Li (2026), p.11."),
    citation         = "Li G. (2026). Winner, NATA Foundation Student Writing Contest."
  )
  class(res) <- "ppcs_prescription"
  res
}

#' Print method for ppcs_prescription objects
#'
#' Displays a formatted clinical prescription sheet.
#'
#' @param x A ppcs_prescription object.
#' @param ... Further arguments passed to or from other methods.
#' @return Invisibly returns \code{x} (a \code{ppcs_prescription} list),
#'   called primarily for its side effect of printing the formatted
#'   prescription to the console.
#' @export
print.ppcs_prescription <- function(x, ...) {
  cat("========================================\n")
  cat("  PPCSexRx Clinical Prescription\n")
  cat("  Evidence-Based Protocol | Li (2026)\n")
  cat("========================================\n")
  cat("Target HR  :", x$target_hr, "bpm\n")
  cat("Duration   :", x$duration_min, "min/session\n")
  cat("Frequency  :", x$frequency_per_week, "sessions/week\n")
  cat("Method     :", x$method, "\n")
  cat("----------------------------------------\n")
  cat("CLINICAL NOTE :", x$clinical_note, "\n")
  cat("SAFETY        :", x$safety_warning, "\n")
  cat("EVIDENCE      :", x$evidence_grade, "\n")
  cat("========================================\n")
  invisible(x)
}
