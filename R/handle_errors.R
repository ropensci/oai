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
