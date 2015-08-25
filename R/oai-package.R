#' oai
#'
#' @name oai-package
#' @aliases oai
#' @importFrom methods is
#' @importFrom stats setNames
#' @importFrom utils head
#' @importFrom httr GET content stop_for_status
#' @importFrom xml2 read_xml xml_children xml_text as_list xml_attrs xml_name xml_attr
#' @docType package
#' @title OAI-PMH Client
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @keywords package
NULL

#' Metadata providers data.frame.
#'
#' @name providers
#' @docType data
#' @keywords datasets
#' @return A data.frame of three columns:
#' \itemize{
#'  \item repo_name - Name of the OAI repository
#'  \item base_url - Base URL of the OAI repository
#'  \item oai_identifier - OAI identifier for the OAI repository
#' }
NULL
