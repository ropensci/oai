while_oai <- function(url, args, token, as, dumper=NULL, dumper_args=NULL, ...) {
  iter <- 0
  token <- "characters"
  out <- list()
  while (is.character(token)) {
    iter <- iter + 1
    args2 <- args
    if (token != "characters") {
      args2$resumptionToken <- token
      args2$from <- NULL
      args2$until <- NULL
      args2$set <- NULL
      args2$metadataPrefix <- NULL
    }

    res <- GET(url, query = args2, ...)
    stop_for_status(res)
    tt <- content(res, "text")
    xml_orig <- xml2::read_xml(tt)
    handle_errors(xml_orig)
    xml <- xml2::xml_children(xml2::xml_children(xml_orig)[[3]])
    trytok <- xml2::as_list(xml[sapply(xml, xml_name) == "resumptionToken"])
    if (length(trytok) == 0) {
      tok <- list(token = "")
    } else {
      tok <- xml2::xml_text(trytok[[1]])
      tok_atts <- xml2::xml_attrs(trytok[[1]])
      tok <- c(token = tok, as.list(tok_atts))
    }
    # `as` determines what the `dumper` gets
    res <- if (as == "raw") {
      tt
    } else {
      switch(args$verb,
             ListRecords = get_data(xml, as = as),
             ListIdentifiers = parse_listid(xml, as = as),
             ListSets = get_sets(xml, as = as)
      )
    }
    # Collect values returned by `dumper` if they are not NULL
    if (is.null(dumper)) {
      out[[iter]] <- res
    } else {
      valid_dumper(dumper, dumper_args)
      dumper_res <- do.call("dumper", c(list(res = res, args = args2, as = as), dumper_args))
      if (!is.null(dumper_res))
        out[[iter]] <- dumper_res
    }
    if (tok$token == "") {
      token <- 1
    } else {
      token <- tok$token
    }
  }

  switch(args$verb,
         ListRecords = do.call("c", out),
         ListIdentifiers = do.call("c", out),
         ListSets = out
  )
}
