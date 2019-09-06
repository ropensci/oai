context("list_metadataformats")

test_that("list_metadataformats - basic functionality works", {
  skip_on_cran()

  aa <- list_metadataformats()

  expect_is(aa, "data.frame")
  expect_is(aa$metadataPrefix, "character")
  expect_is(aa$schema, "character")
  expect_is(aa$metadataNamespace, "character")

  expect_named(aa, c('metadataPrefix', 'schema', 'metadataNamespace'))
})

test_that("list_metadataformats - no formats avail. vs. avail", {
  skip_on_cran()

  aa <- list_metadataformats(id = "foo-bar")
  bb <- list_metadataformats(id = "ad7295e0-3261-4028-8308-b2047d51d408")

  expect_null(aa[[1]])
  expect_is(bb[[1]], "data.frame")
})

test_that("list_metadataformats - curl options", {
  skip_on_cran()

  library("httr")

  expect_error(list_metadataformats(config = timeout(0.001)),
    "Timeout was reached")
})

test_that("list_metadataformats fails well", {
  skip_on_cran()

  expect_error(list_metadataformats("stuff"),
               "One or more of your URLs")
  expect_null(list_metadataformats(id = "adfadfsdf")[[1]])
})
