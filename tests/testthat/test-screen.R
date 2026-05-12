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

test_that("print.ppcs_screen runs without error", {
  x <- screen_ppcs(16, 35, verbose = TRUE)
  expect_no_error(capture.output(print(x)))
})
