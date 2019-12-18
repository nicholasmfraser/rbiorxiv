biorrxiv_usage <- function(interval = "m", format = "list", ...) {

  # Validate function arguments
  validate_usage_args(interval, format)

  # Build url
  url <- paste0("https://api.biorxiv.org/usage/", interval, "/json")

  # Make request
  r <- httr::GET(url)

  # Handle response
  handle_response(r)

  # Retrieve data from request body
  d <- httr::content(r, as="parsed")$`bioRxiv content statistics`

  # Return data in requested format
  if(format == "list") {
    return(d)
  } else if (format == "json") {
    json <- usage_to_json(d)
    return(json)
  } else if (format == "dataframe") {
    df <- usage_to_df(d)
    return(df)
  }
}

validate_usage_args <- function(interval, format) {
  if(!interval %in% c("m", "y")) {
    stop('"interval" argument must be one of "m" or "y"',
         call. = F)
  } else if(!format %in% c("list", "json", "dataframe")) {
    stop('"format" argument must be one of "list", "json" or "dataframe"',
         call. = F)
  } else {
    return()
  }
}

usage_to_json <- function(d) {
  json <- jsonlite::toJSON(d)
  return(json)
}

# Parse usage results to data frame
usage_to_df <- function(d) {

  # Convert list to data frame
  df <- do.call(rbind, lapply(d, as.data.frame))

  # Fix column types
  df$month <- as.Date(as.character(df$month))
  df$abstract_views <- as.numeric(as.character(df$abstract_views))
  df$full_text_views <- as.numeric(as.character(df$full_text_views))
  df$pdf_downloads <- as.numeric(as.character(df$pdf_downloads))
  df$abstract_cumulative <- as.numeric(as.character(df$abstract_cumulative))
  df$full_text_cumulative <- as.numeric(as.character(df$full_text_cumulative))
  df$pdf_cumulative <- as.numeric(as.character(df$pdf_cumulative))

  return(df)

}
