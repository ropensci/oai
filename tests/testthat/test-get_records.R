context("get_records")

test_that("get_records - basic functionality works", {
  skip_on_cran()

  aa <- get_records("b146a93c-657b-4768-aa51-9cabe3dac808",
                    url = "http://api.gbif.org/v1/oai-pmh/registry")

  expect_is(aa, "list")
  expect_is(aa[[1]], "list")
  expect_is(aa[[1]]$header, "tbl_df")
  expect_is(aa[[1]]$metadata, "tbl_df")
  expect_is(aa[[1]]$header$identifier, "character")
  expect_is(aa[[1]]$header$identifier, "character")
  expect_is(aa[[1]]$metadata$title, "character")
})

test_that("get_records - many record Ids input works", {
  skip_on_cran()

  recs <- c("b146a93c-657b-4768-aa51-9cabe3dac808",
            "38f06820-08c5-42b2-94f6-47cc3e83a54a")
  aa <- get_records(recs, url = "http://api.gbif.org/v1/oai-pmh/registry")

  expect_is(aa, "list")

  expect_is(aa[[1]], "list")
  expect_is(aa[[1]]$header, "tbl_df")
  expect_is(aa[[1]]$metadata, "tbl_df")

  expect_is(aa[[2]], "list")
  expect_is(aa[[2]]$header, "tbl_df")
  expect_is(aa[[2]]$metadata, "tbl_df")

  expect_is(aa[[1]]$header$identifier, "character")
  expect_is(aa[[1]]$metadata$title, "character")
  expect_equal(length(aa), 2)
  expect_equal(unname(vapply(aa, "[[", "", c("header", "identifier"))), recs)
})

test_that("get_records fails well", {
  skip_on_cran()

  expect_error(get_records(),
               "argument \"ids\" is missing, with no default")
  expect_error(get_records(5, url = "http://api.gbif.org/v1/oai-pmh/registry"),
               "idDoesNotExist: The given id does not exist", class = "error")
  expect_error(get_records("oai:oai.datacite.org:32255", url = "stuff"),
               "One or more of your URLs")
})
