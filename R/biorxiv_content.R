#' Retrieve details of bioRxiv or medRxiv preprints
#'
#' @export
#' @param server (character) The preprint server to be queried; value must be
#' one of "biorxiv" or "medrxiv". Default: `biorxiv`
#' @param from (date) The date from when details of preprints should
#' be collected. Date must be supplied in `YYYY-MM-DD` format. Default: `NULL`
#' @param to (date) The date until when details of preprints should
#' be collected. Date must be supplied in `YYYY-MM-DD` format. Default: `NULL`
#' @param doi (character) A single digital object identifier (DOI) of a
#' preprint. `doi` cannot be used with `from` and `to` arguments.
#' Default: `NULL`
#' @param limit (integer) The maximum number of results to return. Not
#' relevant when querying a doi. Default: `100`
#' @param skip (integer) The number of results to skip in a query.
#' Default: `0`
#' @param format (character) Return data in list `list`, json `json` or data
#' frame `df` format. Default: `list`
#'
#' @section Beware:
#' Querying for a DOI will only work for DOIs associated with bioRxiv or medRxiv
#'
#' @examples \donttest{
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
biorxiv_content <- function(server = "biorxiv", from = NULL, to = NULL,
                            doi = NULL, limit = 100, skip = 0, format = "list") {

  # Server cannot be NULL
  if(is.null(server)) {
    stop("'server' parameter is required; must be one of 'biorxiv' or 'medrxiv'", call. = F)
  }

  # Either a DOI or a date range must be specified
  if(is.null(doi) & is.null(from) & is.null(to)) {
    stop("'doi' or 'from' and 'to' parameters are required", call. = F)
  }

  # A DOI should not be specified with a date
  if(!is.null(doi) & (!is.null(from) | !is.null(to))) {
    warning(paste0("'doi' should not be specific with 'from' or 'to' parameters;",
                   " defaulting to DOI query"), call. = F)
  }

  # Validate individual arguments
  validate_args(server, from, to, doi, limit, skip, format)

  # Do queries
  if (!is.null(doi)) {
    content <- query_doi(server = server, doi = doi)
    data <- content$collection
  } else {
    content <- query_interval(server = server, from = from, to = to, skip = skip)
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
        content <- query_interval(server = server, from = from, to = to, skip = cursor)
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
query_doi <- function(server, doi) {
  url <- paste0(base_url(), "/details/", server, "/", doi, "/na/json")
  content <- fetch_content(url = url)
  return(content)
}

# Send a query to the content endpoint with 'from' and 'to' dates
query_interval <- function(server, from, to, skip) {
  # make sure 'skip' parameter is not given in scientific notation, ie. 10e5
  skip <- format(skip, scientific = FALSE)
  url <- paste0(base_url(), "/details/", server, "/", from, "/", to, "/", skip, "/json")
  content <- fetch_content(url = url)
  return(content)
}
