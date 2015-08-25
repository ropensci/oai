% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/get_record.R
\name{get_records}
\alias{get_records}
\title{Get records}
\usage{
get_records(ids, prefix = "oai_dc", url = "http://oai.datacite.org/oai",
  ...)
}
\arguments{
\item{ids}{The OAI-PMH identifier for the record. One or more. Required.}

\item{prefix}{specifies the metadata format that the records will be
returned in. Default: oai_dc}

\item{url}{OAI-PMH base url}

\item{...}{Curl options passed on to \code{\link[httr]{GET}}}
}
\description{
Get records
}
\examples{
\dontrun{
get_records("oai:oai.datacite.org:32255")
get_records(c("oai:oai.datacite.org:32255", "oai:oai.datacite.org:32325"))

# from arxiv.org
get_records("oai:arXiv.org:0704.0001", url = "http://export.arxiv.org/oai2")
}
}
