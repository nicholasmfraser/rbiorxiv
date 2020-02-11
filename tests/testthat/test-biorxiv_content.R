test_that("biorxiv_content returns", {

  # Basic query with doi
  expect_is(biorxiv_content(doi = "10.1101/673665"), "list")
  # Basic query with dates
  expect_is(biorxiv_content(from = "2014-01-01", to = "2014-01-30"), "list")

  # Limit and skip
  expect_length(biorxiv_content(from = "2014-01-01", to = "2014-01-30",
                                limit = 10), 10)
  expect_length(biorxiv_content(from = "2014-01-01", to = "2014-01-30",
                                limit = 10, skip = 10), 10)
  # Larger query (requires iteration)
  expect_is(biorxiv_content(from = "2014-01-01", to = "2014-03-30",
                            limit = "*"), "list")

    # Format
  expect_is(biorxiv_content(doi = "10.1101/673665", format = "list"), "list")
  expect_is(biorxiv_content(doi = "10.1101/673665", format = "json"), "json")
  expect_is(biorxiv_content(doi = "10.1101/673665", format = "df"), "data.frame")

  # Column names and types for data frame
  col_names <- c("doi", "title", "authors", "author_corresponding",
                 "author_corresponding_institution", "date", "version", "type",
                 "category", "abstract", "published")
  d <- biorxiv_content(doi = "10.1101/673665", format = "df")
  expect_named(d, col_names)
  expect_is(d$doi, "character")
  expect_is(d$title, "character")
  expect_is(d$authors, "character")
  expect_is(d$author_corresponding, "character")
  expect_is(d$author_corresponding_institution, "character")
  expect_is(d$date, "character")
  expect_is(d$version, "numeric")
  expect_is(d$type, "character")
  expect_is(d$category, "character")
  expect_is(d$abstract, "character")
  expect_is(d$published, "character")

})


test_that("biorxiv_content fails correctly", {

  # Invalid DOI
  expect_error(biorxiv_content(doi = ""))
  expect_error(biorxiv_content(doi = "123456"))
  expect_error(biorxiv_content(doi = "10.1101/123456"))
  expect_error(biorxiv_content(doi = 10.1101/673665))

  # Warning when DOI and dates used together
  expect_warning(biorxiv_content(doi = "10.1101/673665",
                                 from = "2014-01-01", to = "2014-01-30"))

  # Invalid dates
  expect_error(biorxiv_content(from = "01-01-2014", to = "01-10-2014"))
  expect_error(biorxiv_content(from = "2014-01", to = "2014-01"))
  expect_error(biorxiv_content(from = "2015-01-01", to = "2014-01-30"))
  expect_error(biorxiv_content(from = "2014-01-01"))
  expect_error(biorxiv_content(to = "2014-01-30"))

  # Invalid format
  expect_error(biorxiv_content(format = ""))
  expect_error(biorxiv_content(format = 1))
  expect_error(biorxiv_content(format = "a"))

})
