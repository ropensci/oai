#' List available metadata formats from various providers.
#'
#' @export
#' @template url_ddd
#' @param id The OAI-PMH identifier for the record. Optional.
#' @examples \dontrun{
#' list_metadataformats()
#'
#' # no metadatformats for an identifier
#' list_metadataformats(id = "9da8a65a-1b9b-487c-a564-d184a91a2705")
#'
#' # metadatformats available for an identifier
#' list_metadataformats(id = "ad7295e0-3261-4028-8308-b2047d51d408")
#' }
list_metadataformats <- function(url="http://api.gbif.org/v1/oai-pmh/registry",
  id = NULL, ...) {

  check_url(url)
  if (!is.null(id)) {
    stats::setNames(lapply(id, one_mf, url = url, ...), id)
  } else {
    one_mf(id, url, ...)
  }
}

one_mf <- function(identifier, url, ...) {
  args <- sc(list(verb = 'ListMetadataFormats', identifier = identifier))
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  out <- content(res, "text", encoding = "UTF-8")
  xml <- xml2::read_xml(out)
  rbind.fill(lapply(xml_children(xml_children(xml)[[3]]), get_headers))
}
