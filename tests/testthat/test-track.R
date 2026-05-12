rx <- prescribe_ppcs(age = 16, days_post_injury = 35, hrst = 160)

test_that("track_progress initialises log on first session", {
  t1 <- track_progress(
    log = NULL,
    current_pcss = 28,
    current_hr = 120,
    current_duration = 18,
    prescription = rx,
    verbose = FALSE
  )
  expect_s3_class(t1, "ppcs_track")
  expect_equal(t1$sessions_total, 1L)
  expect_equal(nrow(t1$updated_log), 1L)
  expect_false(t1$updated_log$symptoms_worsened[1])
})

test_that("track_progress detects PCSS worsening >= 2", {
  t1 <- track_progress(
    log = NULL,
    current_pcss = 28,
    current_hr = 120,
    current_duration = 18,
    prescription = rx,
    verbose = FALSE
  )
  t2 <- track_progress(
    log = t1$updated_log,
    current_pcss = 31,
    current_hr = 118,
    current_duration = 20,
    prescription = rx,
    verbose = FALSE
  )
  expect_true(t2$updated_log$symptoms_worsened[2])
  expect_true(t2$adjust_hr < rx$target_hr)
})

test_that("plot.ppcs_track is safe with one session", {
  t1 <- track_progress(
    log = NULL,
    current_pcss = 28,
    current_hr = 120,
    current_duration = 18,
    prescription = rx,
    verbose = FALSE
  )
  expect_message(plot(t1), regexp = "2 sessions")
})

test_that("print.ppcs_track runs without error", {
  t1 <- track_progress(
    log = NULL,
    current_pcss = 28,
    current_hr = 120,
    current_duration = 18,
    prescription = rx,
    verbose = TRUE
  )
  expect_no_error(capture.output(print(t1)))
})
