#' List records
#'
#' @export
#'
#' @param url OAI-PMH base url
#' @param from specifies that records returned must have been created/update/deleted
#'     on or after this date.
#' @param until specifies that records returned must have been created/update/deleted
#'     on or before this date.
#' @param set specifies the set that returned records must belong to.
#' @param prefix specifies the metadata format that the records will be
#'     returned in. Default: oai_dc
#' @param token a token previously provided by the server to resume a request
#'     where it last left off.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' list_records(from = '2011-05-01T', until = '2011-08-15T')
#' list_records(from = '2011-06-01T', until = '2011-07-01T')
#' }
list_records <- function(url = "http://oai.datacite.org/oai", prefix = "oai_dc", from = NULL,
                         until = NULL, set = NULL, token = NULL, ...) {

  args <- sc(list(verb = "ListRecords", metadataPrefix = prefix, from = from,
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
    xml_orig <- xml2::read_xml(tt)
    xml <- xml2::xml_children(xml2::xml_children(xml_orig)[[3]])
    tok <- xml2::xml_text(xml2::as_list(xml[sapply(xml, xml_name) == "resumptionToken"])[[1]])
    tok_atts <- xml2::xml_attrs(xml2::as_list(xml[sapply(xml, xml_name) == "resumptionToken"])[[1]])
    tok <- c(token = tok, as.list(tok_atts))
    out[[iter]] <- get_data(xml)
    if (tok$token == "") {
      token <- 1
    } else {
      token <- tok$token
    }
  }
  out <- do.call("c", out)
  trunc_mat(rbind_fill(out))
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

# get_data <- function(x) {
#   list(headers = get_headers(x), metadata = get_metadata(x))
# }
#
# get_headers <- function(x) {
#   do.call("rbind_fill", sc(lapply(x, function(z) {
#     if (xml2::xml_name(z) != "resumptionToken") {
#       tmp <- xml2::xml_children(z)[[1]]
#       dat <- lapply(xml2::xml_children(tmp), function(w) {
#         as.list(setNames(xml2::xml_text(w), xml2::xml_name(w)))
#       })
#       data.frame(rbind(unlist(dat)), stringsAsFactors = FALSE)
#     }
#   })))
# }
#
# get_metadata <- function(x) {
#   sc(lapply(x, function(y) {
#     if (xml2::xml_name(y) != "resumptionToken") {
#       tmp <- xml2::xml_children(y)
#       status <- unlist(xml_attrs(tmp))
#       if (length(status) != 0) {
#         NULL
#       } else {
#         tmp <- xml2::xml_children(xml2::xml_children(tmp[[2]]))
#         lapply(tmp, function(w) {
#           as.list(setNames(xml2::xml_text(w), xml2::xml_name(w)))
#         })
#       }
#     }
#   }))
# }
