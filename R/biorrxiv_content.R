# should also add support for xml

biorrxiv_content <- function(from = NULL, to = NULL, doi = NULL,
                             limit = 100, skip = 0, format = "list", ...) {

  # Determine query type, i.e. for a single doi or for a date interval
  if(!is.null(doi) & is.null(from) & is.null(to)) {
    query_type <- "doi"
  } else if (is.null(doi) & !is.null(from) & !is.null(to)) {
    query_type <- "interval"
  } else {
    stop("'doi' cannot be specified with 'from' or 'to' arguments")
  }

  # Validate arguments
  validate_args(from = from, to = to, doi = doi,
                limit = limit, skip = skip, format = format)

  if(query_type == "doi") {
    d <- query_doi(doi)
  } else {

    # This section doesn't work (e.g if limit < 100).....
    d <- list()
    results_per_page <- 100
    cursor <- skip

    # Make initial query
    results <- query_interval(from, to, cursor)
    count_results <- results$messages[[1]]$count
    total_results <- results$messages[[1]]$total
    d <- c(d, results$collection)

    if(limit == "*") {
      limit <- total_results
    }

    if(limit > count_results) {
      iterations <- ceiling(limit/results_per_page) - 1
      for(i in 1:iterations) {
        cursor <- skip + (i * results_per_page)
        results <- query_interval(from, to, cursor)
        d <- c(d, results$collection)
      }
    }
  }
  return_data(d, format)
}

query_doi <- function(doi) {
  # Build url
  url <- paste0("https://api.biorxiv.org/detail/", doi, "/na/json")
  # Make request
  r <- httr::GET(url)
  # Handle response
  handle_response(r)
  # Retrieve data from request body
  d <- httr::content(r, as="parsed")$collection
  return(d)
}

query_interval <- function(from, to, cursor) {
  # Build url
  url <- paste0("https://api.biorxiv.org/detail/", from, "/", to,
                "/", cursor, "/json")
  # Make request
  r <- httr::GET(url)
  # Handle response
  handle_response(r)
  # Retrieve data from request body
  d <- httr::content(r, as="parsed")
  return(d)
}
