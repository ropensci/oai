# oai_dc parser
parse_oai_dc <- function(x) {
  xml2::xml_ns_strip(x)
  records <- xml2::xml_find_all(x, ".//record", xml_ns(x))

  # header
  header <- unlist(lapply(
    xml2::xml_children(xml2::xml_find_first(records[[1]], "header")),
    name_vec
  ), FALSE)
  header <- uniqify(header)

  # metadata
  meta <- xml2::xml_find_first(records[[1]], "metadata")
  meta <- unlist(lapply(xml2::xml_find_all(meta, "//dc:*"), name_vec), FALSE)
  meta <- uniqify(meta)

  list(
    header = tibble::as_data_frame(header),
    metadata = tibble::as_data_frame(meta)
  )
}


# oai_dc parser
parse_oai_datacite <- function(x) {
  xml2::xml_ns_strip(x)
  records <- xml2::xml_find_all(x, ".//record", xml_ns(x))

  # header
  header <- unlist(lapply(
    xml2::xml_children(xml2::xml_find_first(records[[1]], "header")),
    name_vec
  ), FALSE)
  header <- uniqify(header)

  # metadata
  meta <- xml2::xml_find_first(records[[1]], "metadata")
  meta <- list(
    isReferenceQuality = name_vec(xml2::xml_find_first(meta, "//isReferenceQuality")),
    schemaVersion = name_vec(xml2::xml_find_first(meta, "//schemaVersion")),
    datacentreSymbol = name_vec(xml2::xml_find_first(meta, "//datacentreSymbol")),
    payload = parse_payload(meta)
  )

  list(
    header = tibble::as_data_frame(header),
    metadata = meta
  )
}

parse_payload <- function(x) {
  x <- xml2::xml_find_first(x, "//payload/resource")
  list(
    identifier = list_and_atts(xml2::xml_find_all(x, "identifier")),
    creators = just_text_all(x, "creators/creator/creatorName"),
    titles = just_text_first(x, "titles/title"),
    publisher = just_text_first(x, "publisher"),
    publicationYear = just_text_first(x, "publicationYear"),
    subjects = {
      tmp <- xml2::xml_find_all(x, "subjects/subject")
      lapply(tmp, function(z) {
        if (length(xml2::xml_attrs(z)) > 0) {
          txt <- name_vec(z)[[1]]
          atts <- as.list(xml2::xml_attrs(z))
          attr(txt, names(atts)) <- atts[[1]]
          txt
        } else {
          name_vec(z)[[1]]
        }
      })
    },
    contributors = just_text_all(x, "contributors/contributor"),
    dates = list_and_atts(xml2::xml_find_all(x, "dates/date")),
    language = just_text_first(x, "language"),
    resourceType = as.list(xml2::xml_attrs(xml2::xml_find_first(x, "resourceType"))),
    relatedIdentifiers = list_and_atts(xml2::xml_find_all(x, "relatedIdentifiers/relatedIdentifier")),
    rightsList = list_and_atts(xml2::xml_find_all(x, "rightsList/rights")),
    descriptions = list_and_atts(xml2::xml_find_all(x, "descriptions/description"))
  )
}



# helpers -------------------
list_and_atts <- function(m) {
  lapply(m, function(x) {
    c(
      as.list(xml_attrs(x)),
      name_vec(x)
    )
  })
}

just_text_first <- function(x, xpath) {
  xml2::xml_text(xml2::xml_find_first(x, xpath))
}

just_text_all <- function(x, xpath) {
  xml2::xml_text(xml2::xml_find_all(x, xpath))
}

name_vec <- function(x) {
  as.list(setNames(xml2::xml_text(x), xml2::xml_name(x)))
}

uniqify <- function(w) {
  stats::setNames(
    lapply(unique(names(w)), function(x) paste0(unlist(w[names(w) == x]), collapse = ";")),
    unique(names(w))
  )
}
