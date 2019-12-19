#' Retrieve summary statistics for deposits of bioRxiv content
#'
#' @export
#'
#' @param interval (character) Return either monthly `m` or yearly `y` data.
#' Default: `m`
#' @param format (character) Return data in list `list`, json `json` or data
#' frame `df` format. Default: `list`
#'
#' @examples
#' # Return a list of monthly deposit statistics
#' biorrxiv_summary(interval = "m")
#'
#' # Return data in a data frame
#' biorrxiv_summary(interval = "m", format = "df")
#'
#' # Return annual deposit statistics
#' biorrxiv_summary(interval = "y")
#'

biorrxiv_summary <- function(interval = "m", format = "list", ...) {
  validate_args(interval = interval, format = format)
  url <- paste0(base_url(), "/sum/", interval)
  content <- fetch_content(url = url)
  data <- content$`bioRxiv content statistics`
  return_data(data = data, format = format)
}
