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

dump_xml_to_txt <- function(res, args, file=NULL, ...) {
  if(is.null(file))
    file <- paste0(chartr(": ", "-_", Sys.time()), ".xml")
  cat(res, file=file)
  cat("Dumped to file ", file, "\n", sep="")
}
