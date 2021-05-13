context("Handling OAI-PMH errors")

# URLs triggering OAI-PMH errors
tomorrow <- as.character(Sys.Date() + 1)
error_url <- list(
  badArgument="http://arXiv.org/oai2?verb=ListRecords&metadataPrefix=oai_dc&foo=bar",
  badResumptionToken="http://oai.datacite.org/oai?verb=ListRecords&resumptionToken=foobar",
  badVerb="http://arXiv.org/oai2?verb=someverb",
  cannotDisseminateFormat="http://oai.datacite.org/oai?verb=GetRecord&metadataPrefix=foobar&identifier=oai:oai.datacite.org:32255",
  idDoesNotExist="http://arXiv.org/oai2?verb=GetRecord&identifier=foobar&metadataPrefix=oai_dc",
  noRecordsMatch=paste0("http://oai.datacite.org/oai?verb=ListIdentifiers&from=",
                        tomorrow, "&until=", tomorrow, "&metadataPrefix=oai_dc"),
  noMetadataFormats=NULL,
  noSetHierarchy=NULL    # "https://pbn.nauka.gov.pl/OAI-PMH?verb=ListSets"
)

# GET and parse
gnp <- function(u) {
  r <- httr::GET(u)
  xml2::read_xml( httr::content(r, "text", encoding = "UTF-8"))
}


test_that("badArgument is triggered", {
  skip_on_cran()

  xml <- gnp(error_url$badArgument)
  expect_error( handle_errors(xml) )
  expect_true( tryCatch( handle_errors(xml), error=function(er) inherits(er, "oai-pmh_error") ) )
  expect_true( tryCatch( handle_errors(xml), error=function(er) "badArgument" %in% attr(er, "error_codes")))
} )


test_that("badResumptionToken is triggered", {
  skip_on_cran()

  xml <- gnp(error_url$badResumptionToken)
  expect_error( handle_errors(xml) )
  expect_true( tryCatch( handle_errors(xml), error=function(er) inherits(er, "oai-pmh_error") ) )
  expect_true( tryCatch( handle_errors(xml), error=function(er) "badResumptionToken" %in% attr(er, "error_codes")))
} )

test_that("badVerb is triggered", {
  skip_on_cran()

  xml <- gnp(error_url$badVerb)
  expect_error( handle_errors(xml) )
  expect_true( tryCatch( handle_errors(xml), error=function(er) inherits(er, "oai-pmh_error") ) )
  expect_true( tryCatch( handle_errors(xml), error=function(er) "badVerb" %in% attr(er, "error_codes")))
} )

# FIXME: not working right now
# test_that("cannotDisseminateFormat is triggered", {
#   skip_on_cran()

#   xml <- gnp(error_url$cannotDisseminateFormat)
#   expect_error( handle_errors(xml) )
#   expect_true( tryCatch( handle_errors(xml), error=function(er) inherits(er, "oai-pmh_error") ) )
#   expect_true( tryCatch( handle_errors(xml), error=function(er) "cannotDisseminateFormat" %in% attr(er, "error_codes")))
# } )

test_that("idDoesNotExist is triggered", {
  skip_on_cran()

  xml <- gnp(error_url$idDoesNotExist)
  expect_error( handle_errors(xml) )
  expect_true( tryCatch( handle_errors(xml), error=function(er) inherits(er, "oai-pmh_error") ) )
  expect_true( tryCatch( handle_errors(xml), error=function(er) "idDoesNotExist" %in% attr(er, "error_codes")))
} )

test_that("noRecordsMatch is triggered", {
  skip_on_cran()

  xml <- gnp(error_url$noRecordsMatch)
  expect_error( handle_errors(xml) )
  expect_true( tryCatch( handle_errors(xml), error=function(er) inherits(er, "oai-pmh_error") ) )
  expect_true( tryCatch( handle_errors(xml), error=function(er) "noRecordsMatch" %in% attr(er, "error_codes")))
} )


test_that("noSetHierarchy is triggered", {
  skip_on_cran()

  if (!is.null(error_url$noSetHierarchy)) {
    xml <- gnp(error_url$noSetHierarchy)
    expect_error( handle_errors(xml) )
    expect_true( tryCatch( handle_errors(xml), error=function(er) inherits(er, "oai-pmh_error") ) )
    expect_true( tryCatch( handle_errors(xml), error=function(er) "noSetHierarchy" %in% attr(er, "error_codes")))
  }

})

rm(tomorrow, error_url, gnp)
