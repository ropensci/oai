context("Handling OAI-PMH errors")


test_that("badVerb triggers an error", {
  skip_on_cran()

  res <- httr::GET("http://arXiv.org/oai2/?verb=nastyVerb")
  txt <- content(res, "text")
  expect_error( handle_errors( content(res, "text")) )
  xml <- xml2::read_xml(txt)
  expect_error( handle_errors2(xml))

  res <- httr::GET("https://pbn.nauka.gov.pl/OAI-PMH?verb=nastyVerb")
  txt <- content(res, "text")
  expect_error( handle_errors( content(res, "text")) )
  xml <- xml2::read_xml(txt)
  expect_error( handle_errors2(xml) )
} )