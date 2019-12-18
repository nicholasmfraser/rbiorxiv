# Handle HTTP responses
handle_response <- function(r) {
  if(r$status_code == 200) {
    status <- unlist(httr::content(r, as="parsed")$messages)["status"]
    if(status != "ok") {
      stop(status, call. = F)
    } else {
      return()
    }
  } else if(r$status_code == 404) {
    stop("404: Page not found", call. = F)
  } else if(r$status_code == 500) {
    stop("500: Internal server error", call. = F)
  } else if (r$status_code == 400) {
    stop("400: Bad request", call. = F)
  } else {
    stop("Something went wrong", call. = F)
  }
}


# Return the data in the requested format
return_data <- function(d, format) {
  if(format == "list") {
    return(d)
  } else if (format == "json") {
    json <- data_to_json(d)
    return(json)
  } else if (format == "dataframe") {
    df <- data_to_df(d)
    return(df)
  }
}

data_to_json <- function(d) {
  json <- jsonlite::toJSON(d)
  return(json)
}

# Parse usage results to data frame
data_to_df <- function(d) {

  # Convert list to data frame
  df <- do.call(rbind, lapply(d, as.data.frame))

  # Fix column types
  return(df)

}
