# Here we validate arguments for our query functions
validate_args <- function(from = NULL, to = NULL, interval = NULL,
                          doi = NULL, format = NULL, skip = NULL,
                          limit = NULL, prefix = NULL) {

  # Create a list of supplied arguments
  args <- list(
    "from" = from,
    "to" = to,
    "interval" = interval,
    "doi" = doi,
    "format" = format,
    "skip" = skip,
    "limit" = limit,
    "prefix" = prefix
  )

  # A list of rules to check for each argument
  rules <- list(
    "from" = c("empty", "length", "date"),
    "to" = c("empty", "length", "date"),
    "interval" = c("empty", "length", "interval"),
    "doi" = c("empty", "length", "doi"),
    "format" = c("empty", "length", "format"),
    "skip" = c("empty", "length", "integer"),
    "limit" = c("empty", "length", "integer"),
    "prefix" = c("empty", "length", "prefix")
  )

  sapply(names(args),
         function(name) validate(args[[name]], name, rules[[name]]))

}

# Validate arguments
validate <- function(arg, name, rules) {
  if (!is.null(arg)) {
    sapply(rules,
           function(rule, arg, name) do.call(paste0("check_", rule),
                                             list(arg, name)), arg, name)
  }
}

check_date <- function(arg, name) {
  # Validate date format
  try <- tryCatch(!is.na(as.Date(arg, format = "%Y-%m-%d")),
                  error = function(e) {
                    stop(paste0("Invalid '", name,
                                "' date. Must be in YYYY-MM-DD format"),
                         call. = F)
                  })
  if (!try) {
    stop(paste0("Invalid '", name, "', must be format YYYY-MM-DD"),
         call. = F)
  }
}

check_doi <- function(arg, name) {
  # See https://www.crossref.org/blog/dois-and-matching-regular-expressions/
  # Seems to work fine with bioRxiv DOIs
  if (!grepl("^10.1101\\/[-._;()\\/:A-Z0-9]+$", doi)) {
    stop("Invalid '", name, "', must be in format '10.1101/XXXXXX'",
         call. = F)
  }
}

check_empty <- function(arg, name) {
  if (arg == "") {
    stop(paste0("Invalid '", name, "', value cannot be empty."), call. = F)
  }
}

check_format <- function(arg, name) {
  if (!arg %in% c("list", "json", "df")) {
    stop("Invalid '", name, "', must be one of 'list', 'json' or 'df'",
         call. = F)
  }
}

check_integer <- function(arg, name) {
  # ignore validation when limit = "*"
  if (name != "limit" & arg != "*") {
    try <- tryCatch(!is.na(as.integer(arg)),
                    error = function(e) {
                      stop(paste0("Invalid '", name, "',
                                  must be an integer value"), call. = F)
                    })
    if (!try) {
      stop(paste0("Invalid '", name, "', must be an integer value"),
           call. = F)
    }
  }
}

check_interval <- function(arg, name) {
  if (!arg %in% c("m", "y")) {
    stop("Invalid '", name, "', must be one of 'm' or 'y'",
         call. = F)
  }
}

check_length <- function(arg, name) {
  if (length(arg) > 1) {
    stop(paste0("Invalid '", name, "' value, must be of length 1."), call. = F)
  }
}

check_prefix <- function(arg, name) {
  if (!grepl("^10.\\d{4,9}$", arg)) {
    stop("Invalid '", name, "' must be in format 10.XXXXX")
  }
}
