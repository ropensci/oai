#' Identify the OAI-PMH service for each data provider.
#'
#' @export
#' @param url OAI-PMH base url
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' id()
#'
#' # curl options
#' library("httr")
#' id(config = verbose())
#' }
id <- function(url = "http://oai.datacite.org/oai", ...) {
  check_url(url)
  rbind_fill(lapply(url, id_, ...))
}

id_ <- function(x, ...) {
  res <- GET(x, query = list(verb = "Identify"), ...)
  tt <- content(res, as = "text")
  get_headers(xml_children(xml2::read_xml(tt))[[3]])
}
