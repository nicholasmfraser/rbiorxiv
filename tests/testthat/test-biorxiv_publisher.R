test_that("biorxiv_publisher returns", {

  # Basic query
  expect_is(biorxiv_publisher(prefix = "10.1371", from = "2014-01-01",
                              to = "2014-01-30"), "list")

  # Limit and skip
  expect_length(biorxiv_publisher(prefix = "10.1371", from = "2014-01-01",
                                  to = "2014-12-30", limit = 10), 10)
  expect_length(biorxiv_publisher(prefix = "10.1371", from = "2014-01-01",
                                  to = "2014-12-30", limit = 10, skip = 10), 10)

  # Larger query (requires iteration)
  expect_is(biorxiv_publisher(prefix = "10.1371", from = "2014-01-01",
                              to = "2015-12-30", limit = "*"), "list")

  # Formats
  expect_is(biorxiv_publisher(prefix = "10.1371", from = "2014-01-01",
                              to = "2014-01-30", format = "list"), "list")
  expect_is(biorxiv_publisher(prefix = "10.1371", from = "2014-01-01",
                              to = "2014-01-30", format = "json"), "json")
  expect_is(biorxiv_publisher(prefix = "10.1371", from = "2014-01-01",
                              to = "2014-01-30", format = "df"), "data.frame")

  # Column names and types for data frame
  col_names <- c("biorxiv_doi", "published_doi", "preprint_title",
                 "preprint_category", "preprint_date", "published_date",
                 "published_citation_count")
  d <- biorxiv_publisher(prefix = "10.1371", from = "2014-01-01",
                         to = "2014-01-30", format = "df")
  expect_named(d, col_names)
  expect_is(d$biorxiv_doi, "character")
  expect_is(d$published_doi, "character")
  expect_is(d$preprint_title, "character")
  expect_is(d$preprint_category, "character")
  expect_is(d$preprint_date, "character")
  expect_is(d$published_date, "character")
  expect_is(d$published_citation_count, "numeric")

})

test_that("biorxiv_published fails correctly", {

  # Missing prefix
  expect_error(biorxiv_publisher(from = "2014-01-01", to = "2014-01-30"))

  # Invalid prefix
  expect_error(biorxiv_publisher(prefix = "", from = "2014-01-01",
                                 to = "2014-01-30"))
  expect_error(biorxiv_publisher(prefix = 1, from = "2014-01-01",
                                 to = "2014-01-30"))
  expect_error(biorxiv_publisher(prefix = "a", from = "2014-01-01",
                                 to = "2014-01-30"))

  # Invalid dates
  expect_error(biorxiv_publisher(prefix = "10.1371", from = "01-01-2014",
                                 to = "01-10-2014"))
  expect_error(biorxiv_publisher(prefix = "10.1371", from = "2014-01",
                                 to = "2014-01"))
  expect_error(biorxiv_publisher(prefix = "10.1371", from = "2015-01-01",
                                 to = "2014-01-30"))
  expect_error(biorxiv_publisher(prefix = "10.1371", from = "2014-01-01"))
  expect_error(biorxiv_publisher(prefix = "10.1371", to = "2014-01-30"))

  # Invalid format
  expect_error(biorxiv_publisher(prefix = "10.1371", from = "2014-01-01",
                                 to = "2014-01-30", format = ""))
  expect_error(biorxiv_publisher(prefix = "10.1371", from = "2014-01-01",
                                 to = "2014-01-30", format = 1))
  expect_error(biorxiv_publisher(prefix = "10.1371", from = "2014-01-01",
                                 to = "2014-01-30", format = "a"))

})


