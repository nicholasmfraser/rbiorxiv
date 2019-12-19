#' Retrieve summary statistics for deposits of bioRxiv content
#'
#' @export
#' @param interval (character) Return either monthly `m` or yearly `y` data.
#' Default: `m`
#' @param format (character) Return data in list `list`, json `json` or data
#' frame `df` format. Default: `list`
#'
#' @examples \dontrun{
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

biorxiv_summary <- function(interval = "m", format = "list", ...) {
  validate_args(interval = interval, format = format)
  url <- paste0(base_url(), "/sum/", interval)
  content <- fetch_content(url = url)
  data <- content$`bioRxiv content statistics`
  return_data(data = data, format = format)
}
