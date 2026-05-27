#' Screen Adolescent for SSTAE Eligibility
#'
#' Implements the PICO-based eligibility criteria from Li (2026). Run this
#' before \code{\link{prescribe_ppcs}} to confirm the patient is appropriate
#' for sub-symptom threshold aerobic exercise.
#'
#' @param age Numeric. Patient age in years. Eligible range: 13-18.
#' @param days_post_injury Numeric. Days since concussion. PPCS defined as >=28.
#' @param vestibular_symptoms Logical. Active uncontrolled vestibular symptoms?
#'   Default FALSE. Contraindication per Li (2026), p.11.
#' @param cervical_symptoms Logical. Active uncontrolled cervical symptoms?
#'   Default FALSE. Contraindication per Li (2026), p.11.
#' @param vision_symptoms Logical. Exercise-induced vision dysfunction present?
#'   Default FALSE. Associated with prolonged PPCS (Vernau et al., 2023).
#' @param verbose Logical. If TRUE (default), prints full clinical output.
#'   Set FALSE for patient/caregiver-facing simplified output.
#'
#' @return A list of class \code{ppcs_screen} with fields:
#'   \describe{
#'     \item{status}{"eligible", "contraindicated", or "needs_referral"}
#'     \item{reason}{Character. Clinical rationale for status.}
#'     \item{referral}{Character or NA. Recommended referral if applicable.}
#'     \item{next_step}{Character. Recommended action.}
#'   }
#'
#' @references
#' Li G. (2026). Sub-symptom Threshold Aerobic Exercise for Adolescents
#' With PPCS: A Critically Appraised Topic. Winner, NATA Foundation Student
#' Writing Contest.
#'
#' Vernau BT, Haider MN, Fleming A, et al. Exercise-Induced Vision Dysfunction
#' Early After Sport-Related Concussion Is Associated With Persistent
#' Postconcussive Symptoms. Clin J Sport Med. 2023;33(4):388-394.
#'
#' @export
#' @examples
#' # Eligible athlete
#' screen_ppcs(age = 16, days_post_injury = 35)
#'
#' # Contraindicated: too early
#' screen_ppcs(age = 16, days_post_injury = 20)
#'
#' # Needs referral: vestibular symptoms present
#' screen_ppcs(age = 16, days_post_injury = 35, vestibular_symptoms = TRUE)
#'
#' # Patient/caregiver output
#' screen_ppcs(age = 16, days_post_injury = 35, verbose = FALSE)
screen_ppcs <- function(age,
                        days_post_injury,
                        vestibular_symptoms = FALSE,
                        cervical_symptoms    = FALSE,
                        vision_symptoms      = FALSE,
                        verbose              = TRUE) {

  # --- Input validation ---
  if (!is.numeric(age) || length(age) != 1)
    stop("'age' must be a single number.")
  if (!is.numeric(days_post_injury) || length(days_post_injury) != 1)
    stop("'days_post_injury' must be a single number.")

  # --- Initialise output fields ---
  status   <- NA_character_
  reason   <- NA_character_
  referral <- NA_character_
  next_step <- NA_character_

  # --- Decision logic (ordered: hard stops first) ---

  # 1. Too early: PPCS not yet met
  if (days_post_injury < 28) {
    status    <- "contraindicated"
    reason    <- paste0("Symptoms present for only ", days_post_injury,
                        " days. PPCS requires >= 28 days post-injury ",
                        "(Li, 2026, p.2). SSTAE is not indicated at this stage.")
    referral  <- NA_character_
    next_step <- "Re-screen when >= 28 days post-injury. Continue standard concussion management."

  # 2. Age out of evidence range (warn, do not hard stop)
  } else if (age < 13 || age > 18) {
    status    <- "needs_referral"
    reason    <- paste0("Patient age (", age, " years) is outside the 13-18 year ",
                        "range studied in the included evidence (Li, 2026, p.2). ",
                        "Efficacy and safety in this age group are unverified.")
    referral  <- "Physician or specialist familiar with concussion management outside adolescent range."
    next_step <- "Obtain physician clearance before initiating SSTAE."

  # 3. Vestibular contraindication
  } else if (vestibular_symptoms) {
    status    <- "needs_referral"
    reason    <- "Active vestibular symptoms are present. Uncontrolled vestibular dysfunction is a contraindication to SSTAE (Li, 2026, p.11)."
    referral  <- "Vestibular physiotherapist for assessment and clearance."
    next_step <- "Do not initiate SSTAE until vestibular symptoms are controlled and PT clearance obtained."

  # 4. Cervical contraindication
  } else if (cervical_symptoms) {
    status    <- "needs_referral"
    reason    <- "Active cervical symptoms are present. Uncontrolled cervical dysfunction is a contraindication to SSTAE (Li, 2026, p.11)."
    referral  <- "Physiotherapist for cervical assessment and clearance."
    next_step <- "Do not initiate SSTAE until cervical symptoms are controlled and PT clearance obtained."

  # 5. Vision symptoms: flag but allow with monitoring
  } else if (vision_symptoms) {
    status    <- "needs_referral"
    reason    <- "Exercise-induced vision dysfunction is associated with prolonged PPCS (Vernau et al., 2023). Vision assessment is recommended before starting SSTAE."
    referral  <- "Optometrist or neuro-ophthalmologist for vision assessment."
    next_step <- "Obtain vision clearance. SSTAE may proceed with close symptom monitoring once cleared."

  # 6. All clear
  } else {
    status    <- "eligible"
    reason    <- paste0("Patient meets PICO eligibility criteria: age ", age,
                        " years, ", days_post_injury,
                        " days post-injury (>= 28), no active contraindications. ",
                        "Proceed to BCTT-guided prescription (Li, 2026).")
    referral  <- NA_character_
    next_step <- "Proceed to prescribe_ppcs(). BCTT preferred for HR target; age-predicted fallback if unavailable."
  }

  # --- Build return object ---
  result <- list(
    status    = status,
    reason    = reason,
    referral  = referral,
    next_step = next_step,
    verbose   = verbose
  )
  class(result) <- "ppcs_screen"
  result
}

#' Print method for ppcs_screen objects
#'
#' @param x A ppcs_screen object.
#' @param ... Further arguments (unused).
#' @return Invisibly returns \code{x} (a \code{ppcs_screen} list),
#'   called primarily for its side effect of printing the eligibility
#'   screen result to the console.
#' @export
print.ppcs_screen <- function(x, ...) {

  # UTF-8 capable terminals get symbols; others get ASCII fallback
  if (isTRUE(capabilities("UTF-8"))) {
    icon <- switch(x$status,
      eligible        = "\u2705",
      contraindicated = "\U0001F6D1",
      needs_referral  = "\u26A0\uFE0F",
      "?")
  } else {
    icon <- switch(x$status,
      eligible        = "[OK]",
      contraindicated = "[STOP]",
      needs_referral  = "[WARN]",
      "[?]")
  }

  if (x$verbose) {
    # --- Clinician output ---
    cat("========================================\n")
    cat("  PPCSexRx Eligibility Screen\n")
    cat("  GRADE: LOW certainty | Li (2026)\n")
    cat("========================================\n")
    cat(icon, " STATUS:", toupper(x$status), "\n\n")
    cat("CLINICAL REASON:\n", x$reason, "\n\n")
    if (!is.na(x$referral)) {
      cat("REFERRAL RECOMMENDED:\n", x$referral, "\n\n")
    }
    cat("NEXT STEP:\n", x$next_step, "\n")
    cat("========================================\n")
    cat("For prescription: prescribe_ppcs()\n")
    cat("Evidence: Li G. (2026). NATA Foundation Award.\n")
    cat("========================================\n")
  } else {
    # --- Patient / caregiver output ---
    cat("--- Concussion Exercise Screen ---\n")
    cat(icon, " Result:", toupper(x$status), "\n\n")
    if (x$status == "eligible") {
      cat("Good news: based on the information provided, your athlete\n")
      cat("may be ready to start a supervised exercise programme.\n")
      cat("Please discuss next steps with your athletic trainer or clinician.\n")
    } else {
      cat("Not yet ready to start the exercise programme.\n")
      cat("Please speak with your clinician about next steps.\n")
      if (!is.na(x$referral)) {
        cat("A referral may be needed to:", x$referral, "\n")
      }
    }
    cat("----------------------------------\n")
    cat("This tool supports clinical decisions. Always follow\n")
    cat("your healthcare provider's advice.\n")
  }

  invisible(x)
}
