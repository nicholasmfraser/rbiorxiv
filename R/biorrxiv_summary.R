biorrxiv_summary <- function(interval = "m", format = "list", ...) {

  # Validate function arguments
  validate_summary_args(interval, format)

  # Build url
  url <- paste0("https://api.biorxiv.org/sum/", interval, "/json")

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
    json <- summary_to_json(d)
    return(json)
  } else if (format == "dataframe") {
    df <- summary_to_df(d)
    return(df)
  }
}

validate_summary_args <- function(interval, format) {
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

summary_to_json <- function(d) {
  json <- jsonlite::toJSON(d)
  return(json)
}

# Parse usage results to data frame
summary_to_df <- function(d) {

  # Convert list to data frame
  df <- do.call(rbind, lapply(d, as.data.frame))

  # Fix column types
  # Month is currently returned in YYYY-MM format - convert it here to a date
  df$month <- as.Date(paste0(as.character(df$month),"-01"))
  df$new_papers <- as.numeric(as.character(df$new_papers))
  df$new_papers_cumulative <- as.numeric(as.character(df$new_papers_cumulative))
  df$revised_papers <- as.numeric(as.character(df$revised_papers))
  df$revised_papers_cumulative <- as.numeric(as.character(df$revised_papers_cumulative))

  return(df)

}
