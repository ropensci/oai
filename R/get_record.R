#' Get records
#'
#' @export
#'
#' @param ids The OAI-PMH identifier for the record. One or more. Required.
#' @param prefix specifies the metadata format that the records will be
#'     returned in. Default: oai_dc
#' @param url OAI-PMH base url
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' get_records("oai:oai.datacite.org:32255")
#' get_records(c("oai:oai.datacite.org:32255", "oai:oai.datacite.org:32325"))
#' }
get_records <- function(ids, prefix = "oai_dc", url = "http://oai.datacite.org/oai", ...) {
  check_url(url)
  out <- lapply(ids, each_record, url = url, prefix = prefix, ...)
  structure(rbind_fill(do.call("c", out)), class = c("oai_df", "data.frame"))
}

each_record <- function(identifier, url, prefix, ...) {
  args <- sc(list(verb = "GetRecord", metadataPrefix = prefix, identifier = identifier))
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  tt <- content(res, "text")
  handle_errors(tt)
  xml_orig <- xml2::read_xml(tt)
  xml <- xml2::xml_children(xml2::xml_children(xml_orig)[[3]])
  get_data(xml)
}
