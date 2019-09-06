#' List records
#'
#' @export
#'
#' @template url_ddd
#' @template as
#' @param from specifies that records returned must have been
#' created/update/deleted on or after this date.
#' @param until specifies that records returned must have been
#' created/update/deleted on or before this date.
#' @param set specifies the set that returned records must belong to.
#' @param prefix specifies the metadata format that the records will be
#'     returned in. Default: oai_dc
#' @param token (character) a token previously provided by the server to
#' resume a request where it last left off. 50 is max number of records
#' returned. We will loop for you internally to get all the records you
#' asked for.
#' @examples \dontrun{
#' # By default you get back a single data.frame
#' list_records(from = '2018-05-01T00:00:00Z', until = '2018-05-03T00:00:00Z')
#' list_records(from = '2018-05-01T', until = '2018-05-04T')
#'
#' # Get a list
#' list_records(from = '2018-05-01T', until = '2018-05-04T', as = "list")
#'
#' # Get raw text
#' list_records(from = '2018-05-01T', until = '2018-05-04T', as = "raw")
#' list_records(from = '2018-05-01T', until = '2018-05-04T', as = "raw")
#'
#' # Use a resumption token
#' # list_records(token =
#' #  "1443799900201,2015-09-01T00:00:00Z,2015-10-01T23:59:59Z,50,null,oai_dc")
#' }
list_records <- function(url = "http://api.gbif.org/v1/oai-pmh/registry",
  prefix = "oai_dc", from = NULL, until = NULL, set = NULL, token = NULL,
  as = "df", ...) {

  check_url(url)
  if (!is.null(token)) from <- until <- set <- prefix <- NULL
  args <- sc(list(verb = "ListRecords", metadataPrefix = prefix, from = from,
                  until = until, set = set, resumptionToken = token))
  out <- while_oai(url, args, token, as, ...)
  oai_give(out, as)
}
