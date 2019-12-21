test_that("biorxiv_content returns", {

 # Queries to run
  doi_list <- biorxiv_content(doi = "10.1101/673665", format = "list")
  doi_json <- biorxiv_content(doi = "10.1101/673665", format = "json")
  doi_df <- biorxiv_content(doi = "10.1101/673665", format = "df")

  # To do: tests for dates, limit and skip

  # Correct class
  expect_is(doi_list, "list")
  expect_is(doi_json, "json")
  expect_is(doi_df, "df")


})
