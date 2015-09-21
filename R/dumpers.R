#' Result dumpers
#'
#' Result dumpers are an functions allowing to handle the results from OAI-PMH
#' service "on the fly". Handling can include processing, writing to files,
#' databases etc. This package implements a couple of exemplary dumpers. See
#' Details for how to write your own.
#'
#' @param res
#' @param args
#' @param dumper_args a list of additional arguments accepted by the dumper

dump_xml_to_txt <- function(res, args,
                            file=ifelse(onefile, "oaidump.xml", "oaidump%04d.xml"),
                            onefile=TRUE
  if(!onefile) dumper_call_count <<- 1




}


if(FALSE) {
  con <- file("dupa")
}

