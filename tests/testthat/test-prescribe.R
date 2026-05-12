test_that("prescribe_ppcs returns prescription object", {
  rx <- prescribe_ppcs(age = 16, days_post_injury = 35)
  expect_s3_class(rx, "ppcs_prescription")
  expect_true(is.numeric(rx$target_hr))
  expect_equal(rx$duration_min, 20)
})

test_that("prescribe_ppcs uses BCTT when hrst provided", {
  rx <- prescribe_ppcs(age = 16, days_post_injury = 35, hrst = 160)
  expect_equal(rx$target_hr, round(0.8 * 160))
})

test_that("prescribe_ppcs stops before PPCS window", {
  expect_error(
    prescribe_ppcs(age = 16, days_post_injury = 10),
    regexp = "28"
  )
})

test_that("prescribe_ppcs stops on vestibular contraindication", {
  expect_error(
    prescribe_ppcs(
      age = 16,
      days_post_injury = 35,
      vestibular_symptoms = TRUE
    ),
    regexp = "Contraindicated"
  )
})

test_that("print.ppcs_prescription runs without error", {
  rx <- prescribe_ppcs(16, 35)
  expect_no_error(capture.output(print(rx)))
})
