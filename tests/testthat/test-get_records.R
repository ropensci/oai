context("get_records")

test_that("get_records - basic functionality works", {
  skip_on_cran()

  aa <- get_records("b146a93c-657b-4768-aa51-9cabe3dac808",
                    url = "http://api.gbif.org/v1/oai-pmh/registry")

  expect_is(aa, "data.frame")
  expect_is(aa, "oai_df")
  expect_is(aa$identifier, "character")
  expect_is(aa$title, "character")
})

test_that("get_records - many record Ids input works", {
  skip_on_cran()

  recs <- c("b146a93c-657b-4768-aa51-9cabe3dac808",
            "38f06820-08c5-42b2-94f6-47cc3e83a54a")
  aa <- get_records(recs, url = "http://api.gbif.org/v1/oai-pmh/registry")

  expect_is(aa, "data.frame")
  expect_is(aa, "oai_df")
  expect_is(aa$identifier, "character")
  expect_is(aa$title, "character")
  expect_equal(NROW(aa), 2)
  expect_equal(aa$identifier, recs)
})

test_that("get_records fails well", {
  skip_on_cran()

  expect_error(get_records(),
               "argument \"ids\" is missing, with no default")
  expect_error(get_records(5, url = "http://api.gbif.org/v1/oai-pmh/registry"),
               "idDoesNotExist: The given id does not exist")
  expect_error(get_records("oai:oai.datacite.org:32255", url = "stuff"),
               "One or more of your URLs")
})
