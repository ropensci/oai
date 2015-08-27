#' List sets
#'
#' @export
#' @param url (character) OAI-PMH base url
#' @param token (character) a token previously provided by the server to resume a request
#'     where it last left off.
#' @param as (character) What to return. One of "df" (for data.frame; default),
#'     "list", or "raw" (raw text)
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # Get back a data.frame
#' list_sets()
#'
#' # Get back a list
#' list_sets(as = "list")
#'
#' # Get back raw text
#' list_sets(as = "raw")
#'
#' # curl options
#' library("httr")
#' list_sets(config = verbose())
#' }
list_sets <- function(url = "http://oai.datacite.org/oai", token = NULL, as = "df", ...) {
  check_url(url)
  args <- sc(list(verb = "ListSets", resumptionToken = token))
  out <- while_oai(url, args, token, as, ...)
  oai_give(out, as, "ListSets")
}

get_sets <- function(x, as = "df") {
  switch(as,
         df = {
           rbind_fill(sc(lapply(x, function(z) {
             if (xml2::xml_name(z) != "resumptionToken") {
               tmp <- xml2::xml_children(z)
               rbind_df(as.list(setNames(xml2::xml_text(tmp), xml2::xml_name(tmp))))
             }
           })))
         },
         list = {
           sc(lapply(x, function(z) {
             if (xml2::xml_name(z) != "resumptionToken") {
               tmp <- xml2::xml_children(z)
               as.list(setNames(xml2::xml_text(tmp), xml2::xml_name(tmp)))
             }
           }))
         }
  )
}
