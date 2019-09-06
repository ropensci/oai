#' Test of OAI-PMH service is available
#'
#' Silently test if OAI-PMH service is available under the URL provided.
#'
#' @export
#' @param u base URL to OAI-PMH service
#' @param ... other arguments passed to [id()]
#' @return `TRUE` or `FALSE` if the service is available.
#' @examples \dontrun{
#' url_list <- list(
#'   archivesic="http://archivesic.ccsd.cnrs.fr/oai/oai.php",
#'   datacite = "http://oai.datacite.org/oai",
#'
#'   # No OAI-PMH here
#'   google = "http://google.com"
#' )
#'
#' sapply(url_list, oai_available)
#' }
oai_available <- function(u, ...) {
  r <- try( id(u, ...), silent=TRUE )
  inherits(r, "try-error")
}

# Skip a testthat test if the service is not available
check_oai <- function(u, ...) {
  if ( oai_available(u, ...) ) {
    testthat::skip( paste("OAI-PMH service at", u, "is not avaiable") )
  }
}
