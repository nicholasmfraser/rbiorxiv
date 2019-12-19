biorrxiv_published <- function(from = NULL, to = NULL, limit = 100,
                                 skip = 0, format = "list", ...) {
  # Validate arguments
  validate_args(from = from, to = to, limit = limit,
                skip = skip, format = format)
  url <- paste0(base_url(), "/pub/", from, "/", to, "/", skip)
  content <- fetch_content(url = url)
  count_results <- content$messages[[1]]$count
  total_results <- content$messages[[1]]$total
  if (limit == "*") {
    limit <- total_results - skip
  }
  if (limit <= count_results) {
    data <- content$collection[1:limit]
  } else if (count_results == total_results) {
    data <- content$collection
  } else {
    data <- content$collection
    max_results_per_page <- 100
    iterations <- ceiling(limit / max_results_per_page) - 1
    for (i in 1:iterations) {
      cursor <- skip + (i * max_results_per_page)
      url <- paste0(base_url(), "/pub/", from, "/", to, "/", cursor)
      content <- fetch_content(url = url)
      data <- c(data, content$collection)
    }
  }
  return_data(data = data, format = format)
}
