#' Retrieve summary statistics for deposits of bioRxiv content
#'
#' @export
#' @param interval (character) Return either monthly `m` or yearly `y` data.
#' Default: `m`
#' @param format (character) Return data in list `list`, json `json` or data
#' frame `df` format. Default: `list`
#'
#' @examples \donttest{
#'
#' # Return a list of monthly deposit statistics
#' biorxiv_summary(interval = "m")
#'
#' # Return data in a data frame
#' biorxiv_summary(interval = "m", format = "df")
#'
#' # Return annual deposit statistics
#' biorxiv_summary(interval = "y")
#' }
biorxiv_summary <- function(interval = "m", format = "list") {

  # Check internet connection is available
  check_internet_connection()

  # Validate individual arguments
  validate_args(interval = interval, format = format)

  # Generate URL for query
  url <- paste0(base_url(), "/sum/", interval)

  # Make query
  content <- do_query(url = url)

  # Extract data
  data <- content$`bioRxiv content statistics`

  # Return data in requested format
  return_data(data = data, format = format)
}
