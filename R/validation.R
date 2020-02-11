validate_args <- function(from = NULL, to = NULL, doi = NULL, limit = NULL,
                          skip = NULL, format = NULL, interval = NULL,
                          prefix = NULL) {

  # Validate individual arguments
  if(!is.null(from)) check_date(from)
  if(!is.null(to)) check_date(to)
  if(!is.null(doi)) check_doi(doi)
  if(!is.null(limit)) check_integer(limit)
  if(!is.null(skip)) check_integer(skip)
  if(!is.null(format)) check_format(format)
  if(!is.null(interval)) check_interval(interval)
  if(!is.null(prefix)) check_prefix(prefix)

}

# Validate date format
check_date <- function(arg) {
  call <- deparse(substitute(arg))
  try <- tryCatch(!is.na(as.Date(arg, format = "%Y-%m-%d")),
                  error = function(e) {
                    stop(call, " date must be in yyyy-mm-dd format", call. = F)
                  })
  if (!try) {
    stop("'", call, "' parameter must be in yyyy-mm-dd format", call. = F)
  }
}

# Validate doi
check_doi <- function(arg) {
  # See https://www.crossref.org/blog/dois-and-matching-regular-expressions/
  # Seems to work fine with bioRxiv DOIs
  if (!grepl("^10.1101\\/[-._;()\\/:A-Z0-9]+$", arg)) {
    stop("'doi' parameter must be in format '10.1101/XXXXXX'", call. = F)
  }
}

# Validate data format
check_format <- function(arg) {
  if (!arg %in% c("list", "json", "df")) {
    stop("'format' parameter must be one of 'list', 'json' or 'df'", call. = F)
  }
}

# Validate integer
check_integer <- function(arg) {
  call <- deparse(substitute(arg))
  if(call == "limit" & arg == "*") {
    return()
  } else if(is.numeric(arg)) {
    if(arg - floor(arg) == 0) {
      return()
    }
  }
  stop("'", call, "' parameter  must be an integer value", call. = F)
}

# Validate interval ("m" or "y")
check_interval <- function(arg) {
  if (!arg %in% c("m", "y")) {
    stop("'interval' parameter must be one of 'm' or 'y'", call. = F)
  }
}

# Validate doi prefix
check_prefix <- function(arg) {
  if (!grepl("^10.\\d{4,9}$", arg)) {
    stop("'prefix' parameter must be in format '10.XXXXX'", call. = F)
  }
}
