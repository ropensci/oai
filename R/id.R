#' Identify the OAI-PMH service for each data provider.
#'
#' @export
#' @param url OAI-PMH base url. Required.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # datacite
#' id_entify("http://oai.datacite.org/oai")
#'
#' # arxiv
#' id_entify("http://export.arxiv.org/oai2")
#'
#' # GBIF - http://www.gbif.org/
#' id_entify("http://api.gbif.org/v1/oai-pmh/registry")
#'
#' # curl options
#' library("httr")
#' id_entify("http://export.arxiv.org/oai2", config = verbose())
#' }
id_entify <- function(url, ...) {
  check_url(url)
  rbind.fill(lapply(url, id_, ...))
}

id_ <- function(x, ...) {
  res <- GET(x, query = list(verb = "Identify"), ...)
  tt <- content(res, as = "text", encoding = "UTF-8")
  get_headers(xml_children(xml2::read_xml(tt))[[3]])
}
