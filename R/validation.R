# Here we validate arguments for our query functions
validate_args <- function(from = NULL, to = NULL, interval = NULL, doi = NULL,
                          format = NULL, skip = NULL, limit = NULL, ...) {

  # Validate individual arguments
  if(!is.null(from)) validate_from(from)
  if(!is.null(to)) validate_to(to)
  if(!is.null(interval)) validate_interval(interval)
  if(!is.null(doi)) validate_doi(doi)
  if(!is.null(format)) validate_format(format)
  if(!is.null(skip)) validate_skip(skip)
  if(!is.null(limit)) validate_limit(limit)


  # combined validation rules
  # from date should be before to date
  # skip not more than limit?
}

validate_from <- function(from) {
  check_length(from, "from")
  check_date(from, "from")
}

validate_to <- function(to) {
  check_length(to, "to")
  check_date(to, "to")
}

validate_interval <- function(interval) {
  check_length(interval, "interval")
  if(!interval %in% c("m", "y")) {
    stop("'interval' argument must be one of 'm' or 'y'",
         call. = F)
  }
}

validate_doi <- function(doi) {
  check_length(doi, "doi")
  # See https://www.crossref.org/blog/dois-and-matching-regular-expressions/
  # Seems to work fine with bioRxiv DOIs
  if(!grepl("^10.1101\\/[-._;()\\/:A-Z0-9]+$", doi)) {
    stop("Invalid DOI. Check DOI is a valid bioRxiv DOI in format '10.1101/XXXXXX'",
         call. = F)
  }
}

# Validate format. Must always be one of "list", "json" or "df"
validate_format <- function(format) {
  check_length(format, "format")
  if(!format %in% c("list", "json", "df")) {
    stop('"format" argument must be one of "list", "json" or "df"',
         call. = F)
  }
}

validate_skip <- function(skip) {
  check_length(skip, "skip")
  check_number(skip, "skip")
}

validate_limit <- function(limit) {
  check_length(limit, "limit")
  if(limit != "*") {
    check_number(limit, "limit")
  }
}

check_length <- function(arg, name) {
  if(length(arg) > 1) {
    stop(paste0("Invalid '", name, "' value, must be of length 1."), call. = F)
  }
}

check_date <- function(arg, name) {
  # Validate date format
  try <- tryCatch(!is.na(as.Date(arg, format = "%Y-%m-%d")),
                  error = function(e) {
                    stop(paste0("Invalid '", name, "' date. Must be in YYYY-MM-DD format"),
                         call. = F)
                  })
  if(!try) {
    stop(paste0("Invalid '", name, "' date. Must be in YYYY-MM-DD format"),
         call. = F)
  }
}

check_number <- function(arg, name) {
  if(!is.numeric(arg)) {
    stop("Invalid '", name, "' value. Must be numeric.")
  }
}
