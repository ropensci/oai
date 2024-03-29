#' @description \if{html}{\figure{logo.png}{options: style='float: right' alt='logo' width='120'}}
#' 
#' @description \pkg{oai} is an R client to work with OAI-PMH (Open Archives
#' Initiative Protocol for Metadata Harvesting) services, a protocol
#' developed by the Open Archives Initiative 
#' (https://en.wikipedia.org/wiki/Open_Archives_Initiative).
#' OAI-PMH uses XML data format transported over HTTP.
#'
#' @section OAI-PMH Info:
#' See the OAI-PMH V2 specification at
#' <http://www.openarchives.org/OAI/openarchivesprotocol.html>
#'
#' @section Implementation details:
#' oai is built on \pkg{xml2} and \pkg{httr}. In addition, we give back
#' data.frame's whenever possible to make data comprehension, manipulation,
#' and visualization easier. We also have functions to fetch a large directory
#' of OAI-PMH services - it isn't exhaustive, but does contain a lot.
#'
#' @section Paging:
#' Instead of paging with e.g., `page` and `per_page` parameters,
#' OAI-PMH uses (optionally) `resumptionTokens`, with an optional
#' expiration date. These tokens can be used to continue on to the next chunk
#' of data, if the first request did not get to the end. Often, OAI-PMH
#' services limit each request to 50 records, but this may vary by provider,
#' I don't know for sure. The API of this package is such that we `while`
#' loop for you internally until we get all records. We may in the future
#' expose e.g., a `limit` parameter so you can say how many records
#' you want, but we haven't done this yet.
#'
#' @section Acknowledgements:
#' Michal Bojanowski contributions were supported by (Polish) National Science
#' Center (NCN) through grant 2012/07/D/HS6/01971.
#'
#' @name oai-package
#' @aliases oai
#' @docType package
#' @title OAI-PMH Client
#' @keywords package
#'
#' @importFrom httr RETRY GET content stop_for_status
#' @importFrom xml2 read_xml xml_children xml_text as_list xml_attrs
#' xml_name xml_attr xml_ns
#' @importFrom plyr rbind.fill
#' @importFrom stringr str_extract
#'
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author Michal Bojanowski \email{michal2992@@gmail.com}
"_PACKAGE"

#' Metadata providers data.frame.
#'
#' @name providers
#' @docType data
#' @keywords datasets
#' @return A data.frame of three columns:
#' 
#' - repo_name - Name of the OAI repository
#' - base_url - Base URL of the OAI repository
#' - oai_identifier - OAI identifier for the OAI repository
NULL
