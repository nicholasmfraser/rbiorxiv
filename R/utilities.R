# bioRxiv API base url
base_url <- function() {
  return("https://api.biorxiv.org")
}

# Build the query url for the content endpoint with a DOI
build_content_doi_url <- function(server, doi) {
  url <- paste0(base_url(), "/details/", server, "/", doi)
  return(url)
}

# Build the query url for the content endpoint with 'from' and 'to' dates
build_content_interval_url <- function(server, from, to, skip) {
  # make sure 'skip' parameter is not given in scientific notation, ie. 10e5
  skip <- format(skip, scientific = FALSE)
  url <- paste0(base_url(), "/details/", server, "/", from, "/", to, "/", skip)
  return(url)
}

# Build the query url for the publisher endpoint
build_publisher_url <- function(prefix, from, to, skip) {
  # make sure 'skip' parameter is not given in scientific notation, ie. 10e5
  skip <- format(skip, scientific = FALSE)
  url <- paste0(base_url(), "/publisher/", prefix, "/", from, "/", to, "/", skip)
  return(url)
}

# Build the query url for the published endpoint
build_published_url <- function(from, to, skip) {
  # make sure 'skip' parameter is not given in scientific notation, ie. 10e5
  skip <- format(skip, scientific = FALSE)
  url <- paste0(base_url(), "/pub/", from, "/", to, "/", skip)
  return(url)
}

# Check internet connection
check_internet_connection <- function() {
  if (curl::has_internet() == FALSE) {
    stop("No internet connection detected. ",
         "Please connect to the internet and try again.",
         call. = F)
  }
}

# Make query to API and return full response content
do_query <- function(url) {
  request <- httr::RETRY(verb = "GET",
                         url = url,
                         pause_base = 1,
                         pause_cap = 60,
                         times = 5,
                         quiet = TRUE,
                         httr::timeout(60))
  content <- handle_response(request = request)
  return(content)
}

# Handle http responses
# In addition to typical http responses, the following two cases may occur:
# 1. A 200 status code may be received, but the response body contains a message
# that the connection is refused (probably due to high server loads). In this
# case an error is thrown and the action is stopped.
# 2. A 200 status code is received, bu the response body contains a status
# stating that no results were returned, either because no results are expected
# or due to discrepancies between the expected and actual number of results
# returned by the API, which interferes with paging functions. In this case a
# null response is returned to be handled by the individual API endpoint functions.
handle_response <- function(request) {
  if (request$status_code == 200) {
    if (check_refused_connection(request)) {
      stop("Connection refused. The server may be experiencing high loads. ",
           "Please try again later.", call. = F)
    } else if (check_empty_response(request)) {
      content <- NULL
    } else {
      content <- httr::content(request, as = "parsed")
    }
    return(content)
  }
  httr::stop_for_status(request)
}

# Check if a "Connection refused" message is returned
check_refused_connection <- function(request) {
  message <- httr::content(request, as = "text", encoding = "UTF-8")
  return(message == "Error : (2002) Connection refused")
}

# Check if a "no posts found" status is returned
check_empty_response <- function(request) {
  status <- unlist(httr::content(request, as = "parsed")$messages)["status"]
  return(status == "no posts found")
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
    "license",
    "preprint_category",
    "preprint_title",
    "published",
    "published_doi",
    "server",
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

  # date columns
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


