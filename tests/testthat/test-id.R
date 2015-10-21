context("id_entify")

test_that("id_entify - default uses datacite", {
  skip_on_cran()

  aa <- id_entify("http://oai.datacite.org/oai")

  expect_is(aa, "data.frame")
  expect_match(aa$repositoryName, "DataCite")
  expect_match(aa$baseURL, "oai.datacite.org")
})

test_that("id_entify - url param works", {
  skip_on_cran()

  aa <- id_entify("http://export.arxiv.org/oai2")
  bb <- id_entify("http://pub.bsalut.net/cgi/oai2.cgi")
  cc <- id_entify("http://www.diva-portal.org/oai/OAI")

  expect_is(aa, "data.frame")
  expect_is(bb, "data.frame")
  expect_is(cc, "data.frame")

  expect_equal(NROW(aa), 1)
  expect_equal(NROW(bb), 1)
  expect_equal(NROW(cc), 1)
})

test_that("id_entify fails well", {
  skip_on_cran()

  expect_error(id_entify(),
               "argument \"url\" is missing")
  expect_error(id_entify("things"),
               "One or more of your URLs")
})
