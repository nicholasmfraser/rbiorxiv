#' Retrieve details of bioRxiv preprints
#'
#' @export
#' @param from (date) The date from when details of bioRxiv preprints should
#' be collected. Date must be supplied in `YYYY-MM-DD` format. Default: `NULL`
#' @param to (date) The date until when details of bioRxiv preprints should
#' be collected. Date must be supplied in `YYYY-MM-DD` format. Default: `NULL`
#' @param doi (character) A single digital object identifier (DOI) of a
#' bioRxiv preprint. `doi` cannot be used with `from` and `to` arguments.
#' Default: `NULL`
#' @param limit (integer) The maximum number of results to return. Not
#' relevant when querying a doi. Default: `100`
#' @param skip (integer) The number of results to skip in a query.
#' Default: `0`
#' @param format (character) Return data in list `list`, json `json` or data
#' frame `df` format. Default: `list`
#'
#' @section Beware:
#' Querying for a DOI will only work for DOIs associated with bioRxiv
#'
#' @examples \dontrun{
#'
#' # Get details of preprints deposited between 2018-01-01 and 2018-01-10
#' # By default, only the first 100 records are returned
#' biorxiv_content(from = "2018-01-01", to = "2018-01-10")
#'
#' # Set a limit to return more than 100 records
#' biorxiv_content(from = "2018-01-01", to = "2018-01-10", limit = 200)
#'
#' # Set limit as "*" to return all records
#' biorxiv_content(from = "2018-01-01", to = "2018-01-10", limit = "*")
#'
#' # Skip the first 100 records
#' biorxiv_content(from = "2018-01-01", to = "2018-01-10",
#'                 limit = 200, skip = 100)
#'
#' # Specify the format to return data
#' biorxiv_content(from = "2018-01-01", to = "2018-01-10", format = "df")
#'
#' # Lookup a preprint by DOI
#' biorxiv_content(doi = "10.1101/833400")
#' }
biorxiv_content <- function(from = NULL, to = NULL, doi = NULL,
                            limit = 100, skip = 0, format = "list") {

  # Validate arguments
  validate_args(from = from, to = to, doi = doi,
                limit = limit, skip = skip, format = format)

  # Do queries
  if (!is.null(doi)) {
    content <- query_doi(doi = doi)
    data <- content$collection
  } else {
    content <- query_interval(from = from, to = to, skip = skip)
    count_results <- content$messages[[1]]$count
    total_results <- content$messages[[1]]$total
    if (limit == "*") {
      limit <- total_results - skip
    }
    max_results_per_page <- 100
    if (limit <= count_results) {
      data <- content$collection[1:limit]
    } else if (count_results < max_results_per_page) {
      limit <- count_results
      data <- content$collection[1:limit]
    } else {
      data <- content$collection
      iterations <- ceiling(limit / max_results_per_page) - 1
      for (i in 1:iterations) {
        cursor <- skip + (i * max_results_per_page)
        content <- query_interval(from = from, to = to, skip = cursor)
        data <- c(data, content$collection)
      }
      if(limit < length(data)) {
        data <- data[1:limit]
      }
    }
  }
  return_data(data = data, format = format)
}

# Send a query to the content endpoint with a DOI
query_doi <- function(doi) {
  url <- paste0(base_url(), "/detail/", doi)
  content <- fetch_content(url = url)
  return(content)
}

# Send a query to the content endpoint with 'from' and 'to' dates
query_interval <- function(from, to, skip) {
  url <- paste0(base_url(), "/detail/", from, "/", to, "/", skip)
  content <- fetch_content(url = url)
  return(content)
}
