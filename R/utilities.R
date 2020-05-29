# bioRxiv API base url
base_url <- function() {
  return("https://api.biorxiv.org")
}

# Make query to API and return full response content
fetch_content <- function(url) {
  request <- httr::GET(url = url)
  handle_response(request = request)
  content <- httr::content(request, as = "parsed")
  return(content)
}

# Handle HTTP responses
handle_response <- function(request) {
  if (request$status_code == 200) {
    status <- unlist(httr::content(request, as = "parsed")$messages)["status"]
    if (status != "ok") {
      stop(status, call. = F)
    }
  } else if (request$status_code == 404) {
    stop("404: Page not found", call. = F)
  } else if (request$status_code == 500) {
    stop("500: Internal server error", call. = F)
  } else if (request$status_code == 400) {
    stop("400: Bad request", call. = F)
  } else {
    stop("Something went wrong", call. = F)
  }
}

# Return the data in the requested format
return_data <- function(data, format) {
  if (format == "list") {
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
  df <- set_column_types(df)
  return(df)
}

# Convert a column to character format
to_character <- function(column) {
  return(as.character(column))
}

# Convert a column to numeric format
to_numeric <- function(column) {
  return(as.numeric(as.character(column)))
}

# Convert a column to date format
to_date <- function(column) {
  # For now keep dates as character vector - can adjust this later
  return(as.character(column))
}

# Manually set the types for each column in data frame
set_column_types <- function(df) {

  # character columns
  cols_c <- c(
    "abstract",
    "author_corresponding",
    "author_corresponding_institution",
    "authors",
    "biorxiv_doi",
    "category",
    "doi",
    "preprint_category",
    "preprint_title",
    "published",
    "published_doi",
    "title",
    "type")

  # numeric columns
  cols_n <- c(
    "abstract_cumulative",
    "abstract_views",
    "full_text_cumulative",
    "full_text_views",
    "new_papers",
    "new_papers_cumulative",
    "pdf_cumulative",
    "pdf_downloads",
    "published_citation_count",
    "revised_papers",
    "revised_papers_cumulative",
    "version"
  )

  #date columns
  cols_d <- c(
    "date",
    "month",
    "preprint_date",
    "published_date"
  )

  df[, colnames(df) %in% cols_c] <- sapply(df[ , colnames(df) %in% cols_c],
                                          to_character)
  df[, colnames(df) %in% cols_n] <- sapply(df[, colnames(df) %in% cols_n],
                                          to_numeric)
  df[, colnames(df) %in% cols_d] <- sapply(df[, colnames(df) %in% cols_d],
                                          to_date)
  return(df)
}
