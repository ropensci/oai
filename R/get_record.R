#' Get records
#'
#' @export
#'
#' @template url_ddd
#' @param ids The OAI-PMH identifier for the record. One or more. Required.
#' @param prefix specifies the metadata format that the records will be
#'     returned in. Default: \code{oai_dc}
#' @param as (character) What to return. One of "parsed" (default),
#'     or "raw" (raw text)
#' @return a named list of data.frame's, or lists, or raw text
#' @details There are some finite set of results based on the OAI prefix.
#' We will provide parsers as we have time, and as users express interest.
#' For prefix types we have parsers for we return a list of data.frame's,
#' for each identifier, one data.frame for the \code{header} bits of data, and
#' one data.frame for the \code{metadata} bits of data.
#'
#' For prefixes we don't have parsers for, we fall back to returning raw
#' XML, so you can at least parse the XML yourself.
#'
#' Because some XML nodes are duplicated, we join values together of
#' duplicated node names, separated by a semicolon (\code{;}) with no
#' spaces. You can seprarate them yourself easily.
#' @examples \dontrun{
#' get_records("oai:oai.datacite.org:32255")
#'
#' ids <- c("oai:oai.datacite.org:32255", "oai:oai.datacite.org:32325")
#' (res <- get_records(ids))
#' lapply(res, "[[", "header")
#' lapply(res, "[[", "metadata")
#' do.call(rbind, lapply(res, "[[", "header"))
#' do.call(rbind, lapply(res, "[[", "metadata"))
#'
#' # Get raw text
#' get_records("oai:oai.datacite.org:32255", as = "raw")
#'
#' # from arxiv.org
#' get_records("oai:arXiv.org:0704.0001", url = "http://export.arxiv.org/oai2")
#'
#' # GBIF - http://www.gbif.org
#' get_records(
#'   c("816f4734-6b49-41ab-8a1d-1b21e6b5486d",
#'   "95e3042f-f48d-4a04-8251-f755bebeced6"),
#'   url = "http://api.gbif.org/v1/oai-pmh/registry")
#'
#' # oai_datacite
#' get_records(ids="oai:zenodo.org:159890", prefix="oai_datacite",
#'   url = "https://zenodo.org/oai2d")
#'
#' get_records(ids="oai:oai.datacite.org:32255", prefix="oai_datacite")
#' }
get_records <- function(ids, prefix = "oai_dc", url = "http://oai.datacite.org/oai",
                        as = "parsed", ...) {
  check_url(url)
  if (as %in% c('list', 'df')) as <- "parsed"
  #if (!as %in% c('parsed', 'raw')) stop("'as' must be one of 'parsed' or 'raw'", call. = FALSE)
  stats::setNames(
    lapply(ids, each_record, url = url, prefix = prefix, as = as, ...),
    ids
  )
}

each_record <- function(identifier, url, prefix, as, ...) {
  args <- sc(list(verb = "GetRecord", metadataPrefix = prefix, identifier = identifier))
  res <- GET(url, query = args, ...)
  stop_for_status(res)
  tt <- content(res, "text", encoding = "UTF-8")
  xml_orig <- xml2::read_xml(tt)
  handle_errors(xml_orig)
  if (as == "raw") {
    tt
  } else {
    if (prefix == "oai_dc") {
      parse_oai_dc(xml_orig)
    } else if (prefix == "oai_datacite") {
      parse_oai_datacite(xml_orig)
    } else {
      tt
    }
  }
}
