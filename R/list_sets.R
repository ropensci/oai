#' List sets
#'
#' @export
#' @param url (character) OAI-PMH base url
#' @param token (character) a token previously provided by the server to resume a request
#'     where it last left off.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' list_sets()
#'
#' # curl options
#' library("httr")
#' list_sets(config = verbose())
#' }
list_sets <- function(url = "http://oai.datacite.org/oai", token = NULL, ...) {
  check_url(url)
  args <- sc(list(verb = "ListSets", resumptionToken = token))
  out <- while_oai(url, args, token, ...)
  structure(rbind_fill(out), class = c("oai_df", "data.frame"), type = "ListSets")
}

get_sets <- function(x) {
  rbind_fill(sc(lapply(x, function(z) {
    if (xml2::xml_name(z) != "resumptionToken") {
      tmp <- xml2::xml_children(z)
      rbind_df(as.list(setNames(xml2::xml_text(tmp), xml2::xml_name(tmp))))
    }
  })))
}
