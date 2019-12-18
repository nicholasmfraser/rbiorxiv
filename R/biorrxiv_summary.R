biorrxiv_summary <- function(interval = "m", format = "list", ...) {

  # Validate arguments
  validate_args(interval, format)

  # Build url
  url <- paste0("https://api.biorxiv.org/sum/", interval, "/json")

  # Make request
  r <- httr::GET(url)

  # Handle response
  handle_response(r)

  # Retrieve data from request body
  d <- httr::content(r, as="parsed")$`bioRxiv content statistics`

  # Return data in requested format
  return_data(d, format)
}
