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
#' @param as (character) What to return. One of "df" (for data.frame; default),
#'     "list", or "raw" (raw text)
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # By default you get back a single data.frame
#' list_records(from = '2011-05-01T', until = '2011-08-15T')
#' list_records(from = '2011-05-01T', until = '2011-07-15T')
#' list_records(from = '2011-06-01T', until = '2011-07-01T')
#'
#' # Get a list
#' list_records(from = '2011-06-01T', until = '2011-07-01T', as = "list")
#'
#' # Get raw text
#' list_records(from = '2011-06-01T', until = '2011-07-01T', as = "raw")
#' list_records(from = '2011-06-01T', until = '2011-07-30T', as = "raw")
#'
#' # use curl options
#' library("httr")
#' list_records(from = '2011-05-01T', until = '2011-07-15T', config=verbose())
#' }
list_records <- function(url = "http://oai.datacite.org/oai", prefix = "oai_dc", from = NULL,
  until = NULL, set = NULL, token = NULL, as = "df", ...) {

  check_url(url)
  args <- sc(list(verb = "ListRecords", metadataPrefix = prefix, from = from,
                  until = until, set = set, token = token))
  out <- while_oai(url, args, token, as, ...)
  oai_give(out, as, "ListRecords")
}

oai_give <- function(x, as, type) {
  switch(as,
         df = {
           structure(rbind_fill(x),
                     class = c("oai_df", "data.frame"),
                     type = type)
         },
         list = x,
         raw = x
  )
}

check_url <- function(x) {
  if (!is.url(x)) {
    stop("Your URL appears to not be a proper URL", call. = FALSE)
  }
}

is.url <- function(x, ...){
  grepl("https?://", x)
}


# Look for OAI-PMH exceptions
# https://www.openarchives.org/OAI/openarchivesprotocol.html#ErrorConditions
# xml = parsed xml
handle_errors <- function(xml) {
  nodeset <- xml2::xml_find_all(xml, ".//*[local-name()='error']")
  if( length(nodeset) > 0 ) {
    msgs <- sapply(nodeset, function(n)
      paste0( xml2::xml_attr(n, "code"), ": ", xml2::xml_text(n) ) )
    stop( paste0("OAI-PMH exceptions: ", paste(msgs, collapse="\n")) )
  }

}

#' @export
print.oai_df <- function(x, ..., n = 10) {
  cat(sprintf("<%s> %s X %s", attr(x, "type"), NROW(x), NCOL(x)), "\n\n")
  trunc_mat(x, n = n)
}

get_data <- function(x, as = "df") {
  sc(lapply(x, function(z) {
    if (xml2::xml_name(z) != "resumptionToken") {
      tmp <- xml2::xml_children(z)
      hd <- get_headers(tmp[[1]], as = as)
      met <- get_metadata(tmp, as = as)
      switch(as,
             df = {
               if (!is.null(met)) {
                 data.frame(hd, met, stringsAsFactors = FALSE)
               } else {
                 hd
               }
             },
             list = list(headers = hd, metadata = met),
             raw = z
      )
    }
  }))
}

get_headers <- function(m, as = "df") {
  tmpm <- lapply(xml2::xml_children(m), function(w) {
    as.list(setNames(xml2::xml_text(w), xml2::xml_name(w)))
  })
  switch(as, df = rbind_df(tmpm), list = unlist(tmpm, recursive = FALSE))
}

get_metadata <- function(x, as = "df") {
  status <- unlist(xml2::xml_attrs(x))
  if (length(status) != 0) {
    NULL
  } else {
    tmp <- xml2::xml_children(xml2::xml_children(x))
    tmpm <- lapply(tmp, function(w) {
      as.list(setNames(xml2::xml_text(w), xml2::xml_name(w)))
    })
    switch(as, df = rbind_df(tmpm), list = unlist(tmpm, recursive = FALSE))
  }
}

rbind_df <- function(x) {
  data.frame(rbind(unlist(x)), stringsAsFactors = FALSE)
}
