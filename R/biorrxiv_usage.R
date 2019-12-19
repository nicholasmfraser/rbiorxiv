#' Retrieve summary statistics for usage of bioRxiv content
#'
#' @export
#'
#' @param interval (character) Return either monthly `m` or yearly `y` data.
#' Default: `m`
#' @param format (character) Return data in list `list`, json `json` or data
#' frame `df` format. Default: `list`
#'
#' @examples
#' # Return a list of monthly usage statistics
#' biorrxiv_usage(interval = "m")
#'
#' # Return data in a data frame
#' biorrxiv_usage(interval = "m", format = "df")
#'
#' # Return annual usage statistics
#' biorrxiv_usage(interval = "y")
#'

biorrxiv_usage <- function(interval = "m", format = "list", ...) {
  validate_args(interval = interval, format = format)
  url <- paste0("https://api.biorxiv.org/usage/", interval)
  content <- fetch_content(url = url)
  data <- content$`bioRxiv content statistics`
  return_data(data = data, format = format)
}
