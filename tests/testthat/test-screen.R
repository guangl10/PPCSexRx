test_that("screen_ppcs marks typical adolescent as eligible", {
  x <- screen_ppcs(age = 16, days_post_injury = 35, verbose = FALSE)
  expect_s3_class(x, "ppcs_screen")
  expect_equal(x$status, "eligible")
})

test_that("screen_ppcs flags too early as contraindicated", {
  x <- screen_ppcs(age = 16, days_post_injury = 20, verbose = FALSE)
  expect_equal(x$status, "contraindicated")
})

test_that("screen_ppcs routes vestibular symptoms to referral", {
  x <- screen_ppcs(
    age = 16,
    days_post_injury = 35,
    vestibular_symptoms = TRUE,
    verbose = FALSE
  )
  expect_equal(x$status, "needs_referral")
})

test_that("screen_ppcs routes cervical symptoms to referral", {
  x <- screen_ppcs(
    age = 16,
    days_post_injury = 35,
    cervical_symptoms = TRUE,
    verbose = FALSE
  )
  expect_equal(x$status, "needs_referral")
  expect_match(x$reason, "cervical", ignore.case = TRUE)
})

test_that("screen_ppcs routes vision symptoms to referral", {
  x <- screen_ppcs(
    age = 16,
    days_post_injury = 35,
    vision_symptoms = TRUE,
    verbose = FALSE
  )
  expect_equal(x$status, "needs_referral")
  expect_match(x$reason, "vision", ignore.case = TRUE)
})

test_that("screen_ppcs flags age outside 13-18 evidence range", {
  x <- screen_ppcs(age = 12, days_post_injury = 35, verbose = FALSE)
  expect_equal(x$status, "needs_referral")
  expect_match(x$reason, "13-18")
})

test_that("screen_ppcs prioritizes early-phase stop over vestibular flag", {
  x <- screen_ppcs(
    age = 16,
    days_post_injury = 10,
    vestibular_symptoms = TRUE,
    verbose = FALSE
  )
  expect_equal(x$status, "contraindicated")
})

test_that("print.ppcs_screen runs without error", {
  x <- screen_ppcs(16, 35, verbose = TRUE)
  expect_no_error(capture.output(print(x)))
})
