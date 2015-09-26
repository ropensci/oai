context("Safe reading of XMLs")

inputs <- c(
  "<p>Some paragraph with <b>text in bold</b> which should be OK</p>",
  "<p>Some paragraph with <b>also in bold</b> with a an illegal character \u0019</p>"
)

test_that("proper XML is parsed correctly", {
  expect_equal( read_xml_safely(inputs[1]), xml2::read_xml(inputs[1]) )
} )


test_that("RESTART: improper characters are translated", {
  expect_warning( res <- read_xml_safely(inputs[2]) )
  expect_equal(res, xml2::read_xml( gsub("\u0019", "", inputs[2]) ))
} )


