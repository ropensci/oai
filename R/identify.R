#' Identify the OAI-PMH service for each data provider.
#'
#' @export
#' @param url OAI-PMH base url
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' identify()
#'
#' # curl options
#' library("httr")
#' identify(config = verbose())
#' }
identify <- function(url = "http://oai.datacite.org/oai", ...) {
  rbind_fill(lapply(url, id, ...))
}

id <- function(x, ...) {
  res <- GET(url, query = list(verb = "Identify"), ...)
  tt <- content(res, as = "text")
  get_headers(xml_children(xml2::read_xml(tt))[[3]])
}
