biorrxiv_usage <- function(interval = "m", format = "list", ...) {
  validate_args(interval = interval, format = format)
  url <- paste0("https://api.biorxiv.org/usage/", interval, "/json")
  content <- fetch_content(url = url)
  data <- content$`bioRxiv content statistics`
  return_data(data = data, format = format)
}
