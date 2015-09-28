context("list_identifiers")

test_that("list_identifiers - from", {
  skip_on_cran()

  yesterday <- format(Sys.Date()-1, "%Y-%m-%d")
  aa <- list_identifiers(from = yesterday)

  expect_is(aa, "data.frame")
  expect_is(aa, "oai_df")
  expect_is(aa$identifier, "character")
  expect_is(aa$datestamp, "character")
  expect_equal(as.character(as.Date(aa$datestamp[1])), yesterday)
})

test_that("list_identifiers - from & until", {
  skip_on_cran()

  aa <- list_identifiers(from = '2011-06-01T', until = '2011-06-10T')
  bb <- list_identifiers(from = '2011-06-01T', until = '2011-07-01T')
  cc <- list_identifiers(from = '2011-06-01T', until = '2011-10-01T')

  expect_is(aa, "oai_df")
  expect_is(bb, "oai_df")
  expect_is(cc, "oai_df")

  expect_less_than(NROW(aa), NROW(bb))
  expect_less_than(NROW(bb), NROW(cc))
})

test_that("list_identifiers - set", {
  skip_on_cran()

  aa <- list_identifiers(from = '2011-06-01T', until = '2011-11-01T', set = "ANDS")
  bb <- list_identifiers(from = '2011-06-01T', until = '2012-11-01T', set = "CDL.OSU")
  cc <- list_identifiers(from = '2014-06-01T', until = '2014-10-01T', set = "DK.SA")

  expect_is(aa, "oai_df")
  expect_is(bb, "oai_df")
  expect_is(cc, "oai_df")

  expect_equal(aa$setSpec[1], "ANDS")
  expect_equal(bb$setSpec[1], "CDL")
  expect_equal(cc$setSpec[1], "DK")
})

test_that("list_identifiers fails well", {
  skip_on_cran()

  no_msg <- "The combination of the values of the from, until, set, and metadataPrefix arguments results in an empty list"

  expect_error(list_identifiers(from = '2011-06-01T', until = 'adffdsadsf'),
               "The request includes illegal arguments")
  expect_error(list_identifiers(from = '2011-06-01T', until = 5),
               "The request includes illegal arguments")
  expect_error(list_identifiers(url = 5), "Your URL appears to not be a proper URL")
  expect_error(list_identifiers(from = '2011-06-01T', until = '2011-11-01T', set = "STUFF"), no_msg)
})
