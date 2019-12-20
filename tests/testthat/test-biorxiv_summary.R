test_that("biorxiv_summary returns", {

  # Queries to run
  basic <- biorxiv_summary()
  interval_m <- biorxiv_summary(interval = "m")
  interval_y <- biorxiv_summary(interval = "y")
  format_list <- biorxiv_summary(format = "list")
  format_json <- biorxiv_summary(format = "json")
  format_df <- biorxiv_summary(format = "df")

  # Correct class
  expect_is(basic, "list")
  expect_is(interval_m, "list")
  expect_is(interval_y, "list")
  expect_is(format_list, "list")
  expect_is(format_json, "json")
  expect_is(format_df, "data.frame")

  # Correct column names and types for data frame
  col_names <- c("month", "new_papers", "new_papers_cumulative",
                 "revised_papers", "revised_papers_cumulative")
  expect_named(format_df, col_names)
  expect_is(format_df$month, "character")
  expect_is(format_df$new_papers, "numeric")
  expect_is(format_df$new_papers_cumulative, "numeric")
  expect_is(format_df$revised_papers, "numeric")
  expect_is(format_df$revised_papers_cumulative, "numeric")

})

test_that("biorxiv_summary fails correctly", {

  # Wrong interval
  expect_error(biorxiv_summary(interval = ""))
  expect_error(biorxiv_summary(interval = 1))
  expect_error(biorxiv_summary(interval = "a"))

  # Wrong format
  expect_error(biorxiv_summary(format = ""))
  expect_error(biorxiv_summary(format = 1))
  expect_error(biorxiv_summary(format = "a"))

})
