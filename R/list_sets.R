#' List sets
#'
#' @export
#' @param url OAI-PMH base url
#' @param token a token previously provided by the server to resume a request
#'     where it last left off.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' list_sets()
#' }
list_sets <- function(url = "http://oai.datacite.org/oai", token = NULL, ...) {
  check_url(url)
  args <- sc(list(verb = "ListSets", resumptionToken = token))
  iter <- 0
  token <- "characters"
  out <- list()
  while (is.character(token)) {
    iter <- iter + 1
    args2 <- args
    if (token != "characters") {
      args2$resumptionToken <- token
    }

    res <- GET(url, query = args2)
    stop_for_status(res)
    tt <- content(res, "text")
    handle_errors(tt)
    xml_orig <- xml2::read_xml(tt)
    xml <- xml2::xml_children(xml2::xml_children(xml_orig)[[3]])
    tok <- xml2::xml_text(xml2::as_list(xml[sapply(xml, xml_name) == "resumptionToken"])[[1]])
    tok_atts <- xml2::xml_attrs(xml2::as_list(xml[sapply(xml, xml_name) == "resumptionToken"])[[1]])
    tok <- c(token = tok, as.list(tok_atts))
    out[[iter]] <- get_sets(xml)
    if (tok$token == "") {
      token <- 1
    } else {
      token <- tok$token
    }
  }

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
