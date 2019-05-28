#' Identify the OAI-PMH service for each data provider.
#'
#' @export
#' @template url_ddd
#' @param as (character) What to return. One of "parsed" (default),
#' or "raw" (raw text)
#' @examples \dontrun{
#' # arxiv
#' id("http://export.arxiv.org/oai2")
#'
#' # GBIF - http://www.gbif.org/
#' id("http://api.gbif.org/v1/oai-pmh/registry")
#' 
#' # get back text instead of parsed
#' id("http://export.arxiv.org/oai2", as = "raw")
#' id("http://api.gbif.org/v1/oai-pmh/registry", as = "raw")
#'
#' # curl options
#' library("httr")
#' id("http://export.arxiv.org/oai2", config = verbose())
#' }
id <- function(url, as = "parsed", ...) {
  check_url(url)
  check_as(as)
  rbind.fill(lapply(url, id_, as = as, ...))
}

id_ <- function(x, as = "parsed", ...) {
  res <- GET(x, query = list(verb = "Identify"), ...)
  tt <- content(res, as = "text", encoding = "UTF-8")
  if (as == "raw") return(tt)
  get_headers(xml_children(xml2::read_xml(tt))[[3]])
}
