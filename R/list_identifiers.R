#' List OAI-PMH identifiers
#'
#' @export
#' @param url OAI-PMH base url
#' @param prefix Specifies the metadata format that the records will be
#'     returned in.
#' @param from specifies that records returned must have been created/update/deleted
#'     on or after this date.
#' @param until specifies that records returned must have been created/update/deleted
#'     on or before this date.
#' @param set specifies the set that returned records must belong to.
#' @param token a token previously provided by the server to resume a request
#'     where it last left off.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # from
#' today <- format(Sys.Date(), "%Y-%m-%d")
#' list_identifiers(from = today)
#'
#' # from and until
#' list_identifiers(from = '2011-06-01T', until = '2011-07-01T')
#'
#' # longer time span
#' list_identifiers(from = '2011-06-01T', until = '2011-09-01T')
#'
#' # set parameter - here, using ANDS - Australian National Data Service
#' list_identifiers(from = '2011-09-01T', until = '2012-09-01T', set = "ANDS")
#' }
list_identifiers <- function(url = "http://oai.datacite.org/oai", prefix = "oai_dc", from = NULL,
                             until = NULL, set = NULL, token = NULL, ...) {
  check_url(url)
  args <- sc(list(verb = "ListIdentifiers", metadataPrefix = prefix, from = from,
                  until = until, set = set, token = token))
  iter <- 0
  token <- "characters"
  out <- list()
  while (is.character(token)) {
    iter <- iter + 1
    args2 <- args
    if (token != "characters") {
      args2$resumptionToken <- token
      args2$from <- NULL
      args2$until <- NULL
      args2$set <- NULL
      args2$metadataPrefix <- NULL
    }

    res <- GET(url, query = args2, ...)
    stop_for_status(res)
    tt <- content(res, "text")
    handle_errors(tt)
    xml_orig <- xml2::read_xml(tt)
    xml <- xml2::xml_children(xml2::xml_children(xml_orig)[[3]])
    tok <- xml2::xml_text(xml2::as_list(xml[sapply(xml, xml_name) == "resumptionToken"])[[1]])
    tok_atts <- xml2::xml_attrs(xml2::as_list(xml[sapply(xml, xml_name) == "resumptionToken"])[[1]])
    tok <- c(token = tok, as.list(tok_atts))
    out[[iter]] <- parse_listid(xml)
    if (tok$token == "") {
      token <- 1
    } else {
      token <- tok$token
    }
  }
  out <- do.call("c", out)
  structure(rbind_fill(out), class = c("oai_df", "data.frame"), type = "ListIdentifiers")
}

parse_listid <- function(x) {
  sc(lapply(x, function(z) {
    if (xml2::xml_name(z) != "resumptionToken") {
      get_headers(z)
    }
  }))
}
