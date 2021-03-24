#' Retrieve details of published articles with bioRxiv preprints
#'
#' @export
#' @param from (date) The date from when details of published articles should
#' be collected. Date must be supplied in `YYYY-MM-DD` format. Default: `NULL`
#' @param to (date) The date until when details of published articles should
#' be collected. Date must be supplied in `YYYY-MM-DD` format. Default: `NULL`
#' @param limit (integer) The maximum number of results to return. Not
#' relevant when querying a doi. Default: `100`
#' @param skip (integer) The number of results to skip in a query.
#' Default: `0`
#' @param format (character) Return data in list `list`, json `json` or data
#' frame `df` format. Default: `list`
#'
#' @examples \donttest{
#'
#' # Get details of articles published between 2018-01-01 and 2018-01-10
#' # By default, only the first 100 records are returned
#' biorxiv_published(from = "2018-01-01", to = "2018-01-10")
#'
#' # Set a limit to return more than 100 records
#' biorxiv_published(from = "2018-01-01", to = "2018-01-10", limit = 200)
#'
#' # Set limit as "*" to return all records
#' biorxiv_published(from = "2018-01-01", to = "2018-01-10", limit = "*")
#'
#' # Skip the first 100 records
#' biorxiv_published(from = "2018-01-01", to = "2018-01-10",
#'                   limit = 200, skip = 100)
#'
#' # Specify the format to return data
#' biorxiv_published(from = "2018-01-01", to = "2018-01-10", format = "df")
#' }
biorxiv_published <- function(from = NULL, to = NULL, limit = 100,
                              skip = 0, format = "list") {

  # Check internet connection is available
  check_internet_connection()

  # Validate individual arguments
  validate_args(from = from, to = to, limit = limit,
                skip = skip, format = format)

  # Generate URL for query
  url <- build_published_url(from = from, to = to, skip = skip)

  # Make initial query
  content <- do_query(url = url)

  # Throw error if no results returned
  if(is.null(content)) {
    stop("No posts found. Please check query parameters and try again.",
         call. = F)
  }

  # Count returned resulted
  count_results <- content$messages[[1]]$count

  # Count expected results. The expected number of results returned may
  # differ from the actual number returned
  expected_results <- content$messages[[1]]$total

  # Maximum number of results returned per query is 100
  max_results_per_page <- 100

  # If user requests all results, set limit to maximum number of expected
  # results minus the number of skipped records
  if (limit == "*") {
    limit <- expected_results - skip
  }

  # If the limit is less than the number of returned results, return only
  # those up to the limit
  if (limit <= count_results) {
    data <- content$collection[1:limit]

  # If the number of returned results is less than the maximum returned in
  # one page, return all results
  } else if (count_results < max_results_per_page) {
    data <- content$collection

  # If the number of returned results is less than the number of requested or
  # expected results, we iterate over each page. The number of iterations is
  # based on the number of expected results, but iteration is stopped when
  # less results are returned than expected
  } else {
    data <- content$collection

    # Calculate number of iterations
    iterations <- ceiling(limit / max_results_per_page) - 1

    # Do iterations
    for (i in 1:iterations) {

      # Don't hit the API too hard - limit requests to one per second
      Sys.sleep(1)

      # Generate query cursor
      cursor <- skip + (i * max_results_per_page)

      # Generate URL for query
      url <- build_published_url(from = from, to = to, skip = cursor)
      # Make query
      content <- do_query(url)

      # If no more results returned, end iteration
      if(is.null(content)) {
        break
      }
      data <- c(data, content$collection)

      # Count the number of results returned in iteration
      count_results <- content$messages[[1]]$count

      # If number of results returned is less than expected in a whole page,
      # end iteration
      if(count_results < max_results_per_page) {
        break
      }
    }

    # If the limit is less than the number of returned results, return only
    # those up to the limit
    if(limit < length(data)) {
      data <- data[1:limit]
    }
  }

  # Return data in requested format
  return_data(data = data, format = format)
}
