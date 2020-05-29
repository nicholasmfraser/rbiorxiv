test_that("biorxiv_summary returns", {

  # Basic query
  expect_is(biorxiv_summary(), "list")

  # Intervals
  expect_is(biorxiv_summary(interval = "m"), "list")
  expect_is(biorxiv_summary(interval = "y"), "list")

  # Formats
  expect_is(biorxiv_summary(format = "list"), "list")
  expect_is(biorxiv_summary(format = "json"), "json")
  expect_is(biorxiv_summary(format = "df"), "data.frame")

  # Correct column names and types for data frame
  col_names <- c("month", "new_papers", "new_papers_cumulative",
                 "revised_papers", "revised_papers_cumulative")
  d <- biorxiv_summary(format = "df")
  expect_named(d, col_names)
  expect_is(d$month, "character")
  expect_is(d$new_papers, "numeric")
  expect_is(d$new_papers_cumulative, "numeric")
  expect_is(d$revised_papers, "numeric")
  expect_is(d$revised_papers_cumulative, "numeric")

})

test_that("biorxiv_summary fails correctly", {

  # Invalid interval
  expect_error(biorxiv_summary(interval = ""))
  expect_error(biorxiv_summary(interval = 1))
  expect_error(biorxiv_summary(interval = "a"))

  # Invalid format
  expect_error(biorxiv_summary(format = ""))
  expect_error(biorxiv_summary(format = 1))
  expect_error(biorxiv_summary(format = "a"))

})
