context("list_identifiers")

test_that("list_identifiers - from", {
  skip_on_cran()

  recently <- format(Sys.Date() - 1, "%Y-%m-%d")
  aa <- list_identifiers(from = recently)

  expect_is(aa, "data.frame")
  expect_is(aa, "tbl_df")
  expect_is(aa$identifier, "character")
  expect_is(aa$datestamp, "character")
  # expect_equal(as.character(as.Date(aa$datestamp[1])), recently)
})

test_that("list_identifiers - from & until", {
  skip_on_cran()

  # from and until seems to mostly not work with GBIF's OAI-PMH
  aa <- list_identifiers(from = '2018-06-01T',
    until = '2018-06-03T')
  bb <- list_identifiers(from = '2018-06-01T',
    until = '2018-06-06T')

  expect_is(aa, "tbl_df")
  expect_is(bb, "tbl_df")

  expect_lt(NROW(aa), NROW(bb))
})

test_that("list_identifiers - set", {
  skip_on_cran()

  aa <- list_identifiers(from = '2018-06-01T', until = '2018-06-06T',
    set = "dataset_type:CHECKLIST")
  bb <- list_identifiers(from = '2018-06-01T', until = '2018-06-16T',
    set = "country:US")

  expect_is(aa, "tbl_df")
  expect_is(bb, "tbl_df")

  expect_equal(aa$setSpec.1[1], "dataset_type:CHECKLIST")
  # expect_equal(aa$setSpec.2[1], "country:CO")
  # expect_equal(bb$setSpec.1[1], "dataset_type:OCCURRENCE")
  expect_equal(bb$setSpec.2[1], "country:US")
})

test_that("list_identifiers fails well", {
  skip_on_cran()

  no_msg <- "The combination of the values of the from, until, set, and metadataPrefix arguments results in an empty list"

  expect_error(list_identifiers(from = '2018-06-01T', until = 'adffdsadsf'),
               "OAI-PMH errors: badArgument", class = "error")
  expect_error(list_identifiers(from = '2018-06-01T', until = 5),
               "OAI-PMH errors: badArgument", class = "error")
  expect_error(list_identifiers(url = 5), "One or more of your URLs")
  expect_error(
    list_identifiers(from = '2018-06-01T', until = '2018-06-06T', set = "STUFF"),
    "No matches", class = "error")
})
