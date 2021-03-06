% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/biorxiv_content.R
\name{biorxiv_content}
\alias{biorxiv_content}
\title{Retrieve details of bioRxiv or medRxiv preprints}
\usage{
biorxiv_content(
  server = "biorxiv",
  from = NULL,
  to = NULL,
  doi = NULL,
  limit = 100,
  skip = 0,
  format = "list"
)
}
\arguments{
\item{server}{(character) The preprint server to be queried; value must be
one of "biorxiv" or "medrxiv". Default: \code{biorxiv}}

\item{from}{(date) The date from when details of preprints should
be collected. Date must be supplied in \code{YYYY-MM-DD} format. Default: \code{NULL}}

\item{to}{(date) The date until when details of preprints should
be collected. Date must be supplied in \code{YYYY-MM-DD} format. Default: \code{NULL}}

\item{doi}{(character) A single digital object identifier (DOI) of a
preprint. \code{doi} cannot be used with \code{from} and \code{to} arguments.
Default: \code{NULL}}

\item{limit}{(integer) The maximum number of results to return. Not
relevant when querying a doi. Default: \code{100}}

\item{skip}{(integer) The number of results to skip in a query.
Default: \code{0}}

\item{format}{(character) Return data in list \code{list}, json \code{json} or data
frame \code{df} format. Default: \code{list}}
}
\description{
Retrieve details of bioRxiv or medRxiv preprints
}
\section{Beware}{

Querying for a DOI will only work for DOIs associated with bioRxiv or medRxiv
}

\examples{
\donttest{

# Get details of preprints deposited between 2018-01-01 and 2018-01-10
# By default, only the first 100 records are returned
biorxiv_content(from = "2018-01-01", to = "2018-01-10")

# Set a limit to return more than 100 records
biorxiv_content(from = "2018-01-01", to = "2018-01-10", limit = 200)

# Set limit as "*" to return all records
biorxiv_content(from = "2018-01-01", to = "2018-01-10", limit = "*")

# Skip the first 100 records
biorxiv_content(from = "2018-01-01", to = "2018-01-10",
                limit = 200, skip = 100)

# Specify the format to return data
biorxiv_content(from = "2018-01-01", to = "2018-01-10", format = "df")

# Lookup a preprint by DOI
biorxiv_content(doi = "10.1101/833400")
}
}
