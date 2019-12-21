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
#' @examples \dontrun{
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
  validate_args(from = from, to = to, limit = limit,
                skip = skip, format = format)
  url <- paste0(base_url(), "/pub/", from, "/", to, "/", skip)
  content <- fetch_content(url = url)
  count_results <- content$messages[[1]]$count
  total_results <- content$messages[[1]]$total
  if (limit == "*") {
    limit <- total_results - skip
  }
  max_results_per_page <- 100
  if (limit <= count_results) {
    data <- content$collection[1:limit]
  } else if (count_results < max_results_per_page) {
    data <- content$collection
  } else {
    data <- content$collection
    iterations <- ceiling(limit / max_results_per_page) - 1
    for (i in 1:iterations) {
      cursor <- skip + (i * max_results_per_page)
      url <- paste0(base_url(), "/pub/", from, "/", to, "/", cursor)
      content <- fetch_content(url = url)
      data <- c(data, content$collection)
    }
  }
  return_data(data = data, format = format)
}
