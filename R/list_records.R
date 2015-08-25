#' List records
#'
#' @export
#'
#' @param url (character) OAI-PMH base url
#' @param from specifies that records returned must have been created/update/deleted
#'     on or after this date.
#' @param until specifies that records returned must have been created/update/deleted
#'     on or before this date.
#' @param set specifies the set that returned records must belong to.
#' @param prefix specifies the metadata format that the records will be
#'     returned in. Default: oai_dc
#' @param token (character) a token previously provided by the server to resume a request
#'     where it last left off. 50 is max number of records returned. We will
#'     loop for you internally to get all the records you asked for.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' list_records(from = '2011-05-01T', until = '2011-08-15T')
#' list_records(from = '2011-05-01T', until = '2011-07-15T')
#' list_records(from = '2011-06-01T', until = '2011-07-01T')
#'
#' # use curl options
#' library("httr")
#' list_records(from = '2011-05-01T', until = '2011-07-15T', config=verbose())
#' }
list_records <- function(url = "http://oai.datacite.org/oai", prefix = "oai_dc", from = NULL,
                         until = NULL, set = NULL, token = NULL, ...) {

  check_url(url)
  args <- sc(list(verb = "ListRecords", metadataPrefix = prefix, from = from,
                  until = until, set = set, token = token))
  out <- while_oai(url, args, token, ...)
  structure(rbind_fill(out),
            class = c("oai_df", "data.frame"),
            type = "ListRecords")
}

check_url <- function(x) {
  if (!is.url(x)) {
    stop("Your URL appears to not be a proper URL", call. = FALSE)
  }
}

is.url <- function(x, ...){
  grepl("https?://", x)
}

handle_errors <- function(x) {
  nms <- xml2::xml_name(xml2::xml_children(xml2::read_xml(x)))
  if ("error" %in% nms) {
    stop(xml2::xml_text(xml2::xml_children(xml2::read_xml(x))[[3]]), call. = FALSE)
  }
}

#' @export
print.oai_df <- function(x, ..., n = 10) {
  cat(sprintf("<%s> %s X %s", attr(x, "type"), NROW(x), NCOL(x)), "\n\n")
  trunc_mat(x, n = n)
}

get_data <- function(x) {
  sc(lapply(x, function(z) {
    if (xml2::xml_name(z) != "resumptionToken") {
      tmp <- xml2::xml_children(z)
      hd <- get_headers(tmp[[1]])
      met <- get_metadata(tmp)
      if (!is.null(met)) {
        data.frame(hd, met, stringsAsFactors = FALSE)
      } else {
        hd
      }
    }
  }))
}

get_headers <- function(x) {
  rbind_df(lapply(xml2::xml_children(x), function(w) {
    as.list(setNames(xml2::xml_text(w), xml2::xml_name(w)))
  }))
}

get_metadata <- function(x) {
  status <- unlist(xml2::xml_attrs(x))
  if (length(status) != 0) {
    NULL
  } else {
    tmp <- xml2::xml_children(xml2::xml_children(x))
    rbind_df(lapply(tmp, function(w) {
      as.list(setNames(xml2::xml_text(w), xml2::xml_name(w)))
    }))
  }
}

rbind_df <- function(x) {
  data.frame(rbind(unlist(x)), stringsAsFactors = FALSE)
}
