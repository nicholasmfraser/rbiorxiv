# TO DO: add support for xml

biorrxiv_content <- function(from = NULL, to = NULL, doi = NULL,
                             limit = 100, skip = 0, format = "list", ...) {

  # Validate arguments
  validate_args(from = from, to = to, doi = doi,
                limit = limit, skip = skip, format = format)

  if(!is.null(doi) & is.null(from) & is.null(to)) {
    content <- query_doi(doi = doi)
    data <- content$collection
  } else if (is.null(doi) & !is.null(from) & !is.null(to)) {
    content <- query_interval(from = from, to = to, cursor = skip)
    count_results <- content$messages[[1]]$count
    total_results <- content$messages[[1]]$total
    if(limit == "*") {
      limit <- total_results - skip
    }
    if(limit < count_results) {
      data <- content$collection[1:limit]
    } else if (limit == count_results) {
      data <- content$collection
    } else {
      data <- content$collection
      max_results_per_page <- 100
      iterations <- ceiling(limit/max_results_per_page) - 1
      for(i in 1:iterations) {
        cursor <- skip + (i * max_results_per_page)
        content <- query_interval(from = from, to = to, cursor = cursor)
        data <- c(data, content$collection)
      }
    }
  } else {
    stop("'doi' cannot be specified with 'from' or 'to' arguments")
  }
  return_data(data = data, format = format)
}

query_doi <- function(doi) {
  url <- paste0("https://api.biorxiv.org/detail/", doi, "/na/json")
  content <- fetch_content(url = url)
  return(content)
}

query_interval <- function(from, to, cursor) {
  url <- paste0("https://api.biorxiv.org/detail/", from, "/", to,
                "/", cursor, "/json")
  content <- fetch_content(url = url)
  return(content)
}
