test_that("biorxiv_usage returns", {

  # Basic Query
  expect_is(biorxiv_usage(), "list")

  # Intervals
  expect_is(biorxiv_usage(interval = "m"), "list")
  # expect_is(biorxiv_usage(interval = "y"), "list")

  # Formats
  expect_is(biorxiv_usage(format = "list"), "list")
  expect_is(biorxiv_usage(format = "json"), "json")
  expect_is(biorxiv_usage(format = "df"), "data.frame")

  # Correct column names and types for data frame
  col_names <- c("month", "abstract_views", "full_text_views",
                 "pdf_downloads", "abstract_cumulative",
                 "full_text_cumulative", "pdf_cumulative")
  d <- biorxiv_usage(format = "df")
  expect_named(d, col_names)
  expect_is(d$month, "character")
  expect_is(d$abstract_views, "numeric")
  expect_is(d$full_text_views, "numeric")
  expect_is(d$pdf_downloads, "numeric")
  expect_is(d$abstract_cumulative, "numeric")
  expect_is(d$full_text_cumulative, "numeric")
  expect_is(d$pdf_cumulative, "numeric")

})

test_that("biorxiv_usage fails correctly", {

  # Invalid interval
  expect_error(biorxiv_usage(interval = ""))
  expect_error(biorxiv_usage(interval = 1))
  expect_error(biorxiv_usage(interval = "a"))

  # Invalid format
  expect_error(biorxiv_usage(format = ""))
  expect_error(biorxiv_usage(format = 1))
  expect_error(biorxiv_usage(format = "a"))

})
