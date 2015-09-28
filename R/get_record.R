#' Get records
#'
#' @export
#'
#' @param ids The OAI-PMH identifier for the record. One or more. Required.
#' @param prefix specifies the metadata format that the records will be
#'     returned in. Default: oai_dc
#' @param url OAI-PMH base url
#' @param as (character) What to return. One of "df" (for data.frame; default),
#'     "list", or "raw" (raw text)
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' get_records("oai:oai.datacite.org:32255")
#' get_records(c("oai:oai.datacite.org:32255", "oai:oai.datacite.org:32325"))
#'
#' # Get a list
#' get_records("oai:oai.datacite.org:32255", as = "list")
#'
#' # Get raw text
#' get_records("oai:oai.datacite.org:32255", as = "raw")
#'
#' # from arxiv.org
#' get_records("oai:arXiv.org:0704.0001", url = "http://export.arxiv.org/oai2")
#' }
get_records <- function(ids, prefix = "oai_dc", url = "http://oai.datacite.org/oai", as = "df", ...) {
  check_url(url)
  out <- lapply(ids, each_record, url = url, prefix = prefix, as = as, ...)
  oai_give(do.call("c", out), as, "GetRecord")
}

each_record <- function(identifier, url, prefix, as, ...) {
  args <- sc(list(verb = "GetRecord", metadataPrefix = prefix, identifier = identifier))
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  tt <- content(res, "text")
  xml_orig <- xml2::read_xml(tt)
  handle_errors(xml_orig)
  if (as == "raw") {
    tt
  } else {
    xml <- xml2::xml_children(xml2::xml_children(xml_orig)[[3]])
    get_data(xml, as = as)
  }
}
