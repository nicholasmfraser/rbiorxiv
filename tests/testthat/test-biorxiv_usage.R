test_that("biorxiv_usage returns", {

  # Queries to run
  basic <- biorxiv_usage()
  interval_m <- biorxiv_usage(interval = "m")
  # Ignore for now - for some reason bioRxiv API is failing when requesting
  # annual data
  # interval_y <- biorxiv_usage(interval = "y")
  format_list <- biorxiv_usage(format = "list")
  format_json <- biorxiv_usage(format = "json")
  format_df <- biorxiv_usage(format = "df")

  # Correct class
  expect_is(basic, "list")
  expect_is(interval_m, "list")
  # expect_is(interval_y, "list")
  expect_is(format_list, "list")
  expect_is(format_json, "json")
  expect_is(format_df, "data.frame")

  # Correct column names and types for data frame
  col_names <- c("month", "abstract_views", "full_text_views",
                 "pdf_downloads", "abstract_cumulative",
                 "full_text_cumulative", "pdf_cumulative")
  expect_named(format_df, col_names)
  expect_is(format_df$month, "character")
  expect_is(format_df$abstract_views, "numeric")
  expect_is(format_df$full_text_views, "numeric")
  expect_is(format_df$pdf_downloads, "numeric")
  expect_is(format_df$abstract_cumulative, "numeric")
  expect_is(format_df$full_text_cumulative, "numeric")
  expect_is(format_df$pdf_cumulative, "numeric")

})

test_that("biorxiv_usage fails correctly", {

  # Wrong interval
  expect_error(biorxiv_usage(interval = ""))
  expect_error(biorxiv_usage(interval = 1))
  expect_error(biorxiv_usage(interval = "a"))

  # Wrong format
  expect_error(biorxiv_usage(format = ""))
  expect_error(biorxiv_usage(format = 1))
  expect_error(biorxiv_usage(format = "a"))

})
