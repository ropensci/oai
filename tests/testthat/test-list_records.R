context("list_records")

# Commented out for now: when these do work, they take a long time to run, 
#    and they often don't work
# test_that("list_records works", {
#   skip_on_cran()
#
#   a <- list_records(from = '2011-06-01T', until = '2011-07-01T')
#
#   expect_is(a, "data.frame")
#   expect_is(a, "tbl_df")
#   expect_is(a$identifier, "character")
# })

test_that("list_records fails well", {
  skip_on_cran()

  expect_error(list_records(from = '2011-06-01T', until = 'adffdsadsf'),
               "OAI-PMH errors: badArgument", class = "error")
  expect_error(list_records(from = '2011-06-01T', until = 5),
               "OAI-PMH errors: badArgument", class = "error")
  expect_error(list_records(url = 5), "One or more of your URLs")
})
