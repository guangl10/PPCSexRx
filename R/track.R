#' Track SSTAE Rehabilitation Progress Over Time
#'
#' Records and evaluates session-level data over the course of a sub-symptom
#' threshold aerobic exercise programme. Compares observed progress against
#' the progression and stop rules described in Li (2026), p.14, and generates
#' a recommendation for the next session.
#'
#' @param log A data frame of previous sessions with columns:
#'   \describe{
#'     \item{date}{Character or Date. Session date (e.g. "2026-03-01").}
#'     \item{pcss}{Numeric. Post-Concussion Symptom Scale total (0-132).}
#'     \item{target_hr}{Numeric. Prescribed HR target for that session (bpm).}
#'     \item{achieved_hr}{Numeric. Mean HR achieved during session (bpm).}
#'     \item{duration_min}{Numeric. Minutes of exercise completed.}
#'     \item{symptoms_worsened}{Logical. Did PCSS increase >= 2 points vs prior session?}
#'   }
#'   Pass \code{NULL} to initialise an empty log (first session).
#' @param current_pcss Numeric. Today's PCSS score (0-132).
#' @param current_hr Numeric. HR achieved in today's session (bpm).
#' @param current_duration Numeric. Minutes completed today.
#' @param prescription A \code{ppcs_prescription} object from
#'   \code{\link{prescribe_ppcs}}. Used to retrieve the current target HR.
#' @param verbose Logical. If TRUE (default), prints full clinician output.
#'   Set FALSE for patient/caregiver-facing simplified output.
#'
#' @return A list of class \code{ppcs_track} with fields:
#'   \describe{
#'     \item{updated_log}{Data frame. The log with today's session appended.}
#'     \item{phase}{Character. Current rehabilitation phase.}
#'     \item{recommendation}{Character. Action for the next session.}
#'     \item{adjust_hr}{Numeric. Suggested HR target for next session (bpm).}
#'     \item{sessions_total}{Integer. Total sessions recorded.}
#'     \item{pcss_change}{Numeric. PCSS change from first to today.}
#'     \item{verbose}{Logical. Passed through for print method.}
#'   }
#'
#' @references
#' Li G. (2026). Sub-symptom Threshold Aerobic Exercise for Adolescents
#' With PPCS: A Critically Appraised Topic. Winner, NATA Foundation Student
#' Writing Contest. p.14.
#'
#' Kurowski BG, et al. Aerobic Exercise for Adolescents With Prolonged
#' Symptoms After Mild Traumatic Brain Injury. J Head Trauma Rehabil.
#' 2017;32(2):79-89.
#'
#' @export
#' @examples
#' # Step 1: get a prescription
#' rx <- prescribe_ppcs(age = 16, days_post_injury = 35, hrst = 160)
#'
#' # Step 2: first session - no prior log
#' t1 <- track_progress(
#'   log               = NULL,
#'   current_pcss      = 28,
#'   current_hr        = 120,
#'   current_duration  = 18,
#'   prescription      = rx
#' )
#' t1
#'
#' # Step 3: second session - pass updated log forward
#' t2 <- track_progress(
#'   log               = t1$updated_log,
#'   current_pcss      = 24,
#'   current_hr        = 122,
#'   current_duration  = 20,
#'   prescription      = rx
#' )
#' t2
track_progress <- function(log,
                           current_pcss,
                           current_hr,
                           current_duration,
                           prescription,
                           verbose = TRUE) {

  # --- Input validation ---
  if (!inherits(prescription, "ppcs_prescription"))
    stop("'prescription' must be a ppcs_prescription object from prescribe_ppcs().")
  if (!is.numeric(current_pcss) || current_pcss < 0 || current_pcss > 132)
    stop("'current_pcss' must be numeric between 0 and 132.")
  if (!is.numeric(current_hr) || current_hr <= 0)
    stop("'current_hr' must be a positive number.")
  if (!is.numeric(current_duration) || current_duration < 0)
    stop("'current_duration' must be a non-negative number.")

  today <- Sys.Date()

  # --- Determine worsening vs prior session ---
  if (is.null(log) || nrow(log) == 0) {
    # First session: no prior PCSS to compare
    symptoms_worsened <- FALSE
    first_pcss        <- current_pcss
    sessions_done     <- 0L
  } else {
    required_cols <- c("date", "pcss", "target_hr",
                       "achieved_hr", "duration_min", "symptoms_worsened")
    missing_cols <- setdiff(required_cols, names(log))
    if (length(missing_cols) > 0)
      stop("'log' is missing columns: ", paste(missing_cols, collapse = ", "))

    prior_pcss        <- log$pcss[nrow(log)]
    symptoms_worsened <- (current_pcss - prior_pcss) >= 2   # Li 2026 p.14: +2 threshold
    first_pcss        <- log$pcss[1]
    sessions_done     <- nrow(log)
  }

  # --- Append today to log ---
  new_row <- data.frame(
    date              = as.character(today),
    pcss              = current_pcss,
    target_hr         = prescription$target_hr,
    achieved_hr       = current_hr,
    duration_min      = current_duration,
    symptoms_worsened = symptoms_worsened,
    stringsAsFactors  = FALSE
  )
  updated_log <- if (is.null(log) || nrow(log) == 0) new_row else rbind(log, new_row)
  sessions_total <- nrow(updated_log)

  # --- HR adjustment for next session: Li 2026 p.14 progression rule ---
  base_hr    <- prescription$target_hr
  adjust_hr  <- base_hr   # default: hold

  if (symptoms_worsened) {
    adjust_hr <- max(80, base_hr - 10)   # decrease 10 bpm; floor at 80
  } else if (sessions_done >= 2 && !any(tail(updated_log$symptoms_worsened, 2))) {
    adjust_hr <- base_hr + 5             # 2+ sessions without worsening: +5 bpm
  }
  # Hard ceiling: never exceed age-predicted HRmax proxy (200 bpm conservative)
  adjust_hr <- min(adjust_hr, 200)

  # --- Determine rehabilitation phase ---
  pcss_change <- first_pcss - current_pcss   # positive = improvement

  phase <- if (symptoms_worsened) {
    "Symptom Exacerbation - reduce intensity"
  } else if (sessions_total <= 3) {
    "Early Adaptation (sessions 1-3) - establish tolerance"
  } else if (current_duration >= 20 && !symptoms_worsened) {
    "Progressive Loading - advancing towards full dose"
  } else {
    "Consolidation - maintaining sub-threshold intensity"
  }

  # --- Recommendation text ---
  recommendation <- if (symptoms_worsened) {
    paste0("Symptoms worsened (PCSS +", current_pcss - (first_pcss - pcss_change),
           " points). Reduce target HR to ", adjust_hr,
           " bpm next session. Resume prior intensity once baseline returns. ",
           "Stop rule applies: Li (2026), p.14.")
  } else if (sessions_done >= 2 && adjust_hr > base_hr) {
    paste0("No worsening for 2+ sessions. Progress target HR to ",
           adjust_hr, " bpm next session. ",
           "Re-assess exertion tolerance every 2-3 weeks: Li (2026), p.14.")
  } else {
    paste0("Maintain current target HR (", base_hr,
           " bpm). Continue monitoring PCSS each session.")
  }

  # --- Build return object ---
  result <- list(
    updated_log    = updated_log,
    phase          = phase,
    recommendation = recommendation,
    adjust_hr      = adjust_hr,
    sessions_total = sessions_total,
    pcss_change    = pcss_change,
    verbose        = verbose
  )
  class(result) <- "ppcs_track"
  result
}

#' Print method for ppcs_track objects
#'
#' @param x A ppcs_track object.
#' @param ... Further arguments (unused).
#' @return Invisibly returns \code{x} (a \code{ppcs_track} list),
#'   called primarily for its side effect of printing the session
#'   progress summary to the console.
#' @export
print.ppcs_track <- function(x, ...) {

  trend_icon <- if (x$pcss_change > 0) {
    if (isTRUE(capabilities("UTF-8"))) "\u2193" else "[improving]"   # down arrow
  } else if (x$pcss_change < 0) {
    if (isTRUE(capabilities("UTF-8"))) "\u2191" else "[worsening]"   # up arrow
  } else {
    if (isTRUE(capabilities("UTF-8"))) "\u2192" else "[stable]"      # right arrow
  }

  if (x$verbose) {
    cat("========================================\n")
    cat("  PPCSexRx Progress Tracker\n")
    cat("  GRADE: LOW certainty | Li (2026)\n")
    cat("========================================\n")
    cat("Sessions completed :", x$sessions_total, "\n")
    cat("PCSS change        :", trend_icon, abs(x$pcss_change), "points",
        if (x$pcss_change >= 0) "(improvement)" else "(worsening)", "\n")
    cat("Current phase      :", x$phase, "\n")
    cat("----------------------------------------\n")
    cat("NEXT SESSION HR    :", x$adjust_hr, "bpm\n")
    cat("RECOMMENDATION     :\n", x$recommendation, "\n")
    cat("----------------------------------------\n")
    cat("SAFETY             : Stop if symptoms meaningfully worsen.\n")
    cat("                     Repeat exertion test every 2-3 weeks.\n")
    cat("EVIDENCE           : GRADE LOW. Conditional recommendation.\n")
    cat("                     Li G. (2026). NATA Foundation Award.\n")
    cat("========================================\n")
  } else {
    # Patient / caregiver output
    cat("--- Your Exercise Progress ---\n")
    cat("Sessions done:", x$sessions_total, "\n")
    cat("Symptom trend:", trend_icon, "\n\n")
    cat("Next session target heart rate:", x$adjust_hr, "bpm\n\n")
    if (grepl("worsen", x$recommendation, ignore.case = TRUE)) {
      cat("Note: Your symptoms increased this session.\n")
      cat("Your clinician has adjusted the plan to keep you safe.\n")
    } else {
      cat("Keep going - you are making progress!\n")
    }
    cat("\nAlways follow your clinician's guidance.\n")
    cat("Stop exercising if symptoms get worse.\n")
    cat("------------------------------\n")
  }

  invisible(x)
}

#' Plot rehabilitation progress for a ppcs_track object
#'
#' Generates a dual-panel plot showing PCSS symptom trajectory and
#' achieved HR over time. Requires base R graphics only (no dependencies).
#'
#' @param x A ppcs_track object.
#' @param ... Further arguments passed to \code{plot()}.
#' @return Invisibly returns \code{x}, called for its side effect of
#'   drawing a two-panel base-graphics figure: the upper panel shows
#'   Post-Concussion Symptom Scale (PCSS) scores across sessions;
#'   the lower panel shows achieved and target heart rate (bpm) across
#'   sessions. Returns a message (via \code{\link{message}}) and
#'   \code{invisible(x)} without plotting if fewer than two sessions
#'   are recorded.
#' @export
plot.ppcs_track <- function(x, ...) {
  log <- x$updated_log
  if (nrow(log) < 2) {
    message("At least 2 sessions needed to plot progress.")
    return(invisible(x))
  }

  dates <- seq_len(nrow(log))   # session number on x-axis

  op <- par(mfrow = c(2, 1), mar = c(4, 4, 2, 1))
  on.exit(par(op))

  # Panel 1: PCSS trajectory
  plot(dates, log$pcss,
       type = "b", pch = 19, col = "#E05A5A",
       xlab = "Session", ylab = "PCSS Score",
       main = "Symptom Burden Over Time",
       ylim = c(0, max(log$pcss, na.rm = TRUE) * 1.15),
       xaxt = "n", ...)
  axis(1, at = dates)
  abline(h = 0, lty = 2, col = "grey70")

  # Panel 2: Achieved HR trajectory
  plot(dates, log$achieved_hr,
       type = "b", pch = 19, col = "#5A8AE0",
       xlab = "Session", ylab = "Heart Rate (bpm)",
       main = "Exercise Intensity Over Time",
       ylim = c(min(log$achieved_hr, na.rm = TRUE) * 0.9,
                max(log$achieved_hr, na.rm = TRUE) * 1.1),
       xaxt = "n", ...)
  axis(1, at = dates)
  lines(dates, log$target_hr,
        lty = 2, col = "#5A8AE055")
  legend("bottomright",
         legend = c("Achieved HR", "Target HR"),
         col    = c("#5A8AE0", "#5A8AE055"),
         lty    = c(1, 2), pch = c(19, NA),
         bty    = "n", cex = 0.8)
}

#' @importFrom graphics abline axis legend lines par plot
#' @importFrom utils tail
NULL
