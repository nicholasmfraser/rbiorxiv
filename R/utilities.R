# Make query to API and return full response content
fetch_content <- function(url) {
  request <- httr::GET(url = url)
  handle_response(request = request)
  content <- httr::content(request, as="parsed")
  return(content)
}

# Handle HTTP responses
handle_response <- function(request) {
  if(request$status_code == 200) {
    status <- unlist(httr::content(request, as="parsed")$messages)["status"]
    if(status != "ok") {
      stop(status, call. = F)
    } else {
      return()
    }
  } else if(request$status_code == 404) {
    stop("404: Page not found", call. = F)
  } else if(request$status_code == 500) {
    stop("500: Internal server error", call. = F)
  } else if (request$status_code == 400) {
    stop("400: Bad request", call. = F)
  } else {
    stop("Something went wrong", call. = F)
  }
}


# Return the data in the requested format
return_data <- function(data, format) {
  if(format == "list") {
    return(data)
  } else if (format == "json") {
    json <- data_to_json(data = data)
    return(json)
  } else if (format == "df") {
    df <- data_to_df(data = data)
    return(df)
  }
}

# Parse data to json
data_to_json <- function(data) {
  json <- jsonlite::toJSON(data)
  return(json)
}

# Parse data to data frame
data_to_df <- function(data) {
  df <- do.call(rbind, lapply(data, as.data.frame))
  # TO DO: Check column types
  return(df)
}
