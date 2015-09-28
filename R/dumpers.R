#' Result dumpers
#'
#' Result dumpers are functions allowing to handle the results from OAI-PMH
#' service "on the fly". Handling can include processing, writing to files,
#' databases etc. This package implements a couple of exemplary dumpers. See
#' Details for how to write your own.
#'
#' A dumper is a function that needs to accept at least the arguments:
#' \code{res}, \code{args}, \code{as}. They will get values by the enclosing
#' function internally.
#'
#' @param res results, depends on \code{as}, not to be specified by the user
#' @param args list, query arguments, not to be specified by the user
#' @param as character, type of result to return, not to be specified by the
#'   user
#' @param ... arguments passed to other functions
#'
#' @return Dumpers should return \code{NULL} or a value that will be collected
#' and returned by the function calling the dumper (e.g.
#' \code{\link{list_records}}).
#'
#' @aliases dumpers
#' @name dumpers
NULL



#' @rdname dumpers
#'
#' @details
#'
#' `dump_raw_to_txt` writes raw XML to text files. It requires \code{as=="raw"}.
#' File names are created with \code{\link{Sys.time}} with ":" and spaces
#' replaced with "-" and "_" respectively. \code{file_prefix} is used when
#' provided.
#'
#' @param file_prefix character or \code{NULL} a file name prefix prepended to
#'   the target file name with \code{\link{file.path}}
#'
#' @return `dump_raw_to_txt` returns the name of the created file
#'
#' @export
dump_raw_to_txt <- function(res, args, as, file_prefix=NULL, ...) {
  stopifnot(as == "raw")
  filename <- paste0(chartr(": ", "-_", Sys.time()), ".xml")
  if( !is.null(file_prefix) ) {
    filename <- file.path(file_prefix, filename)
  }
  cat( as.character(res), file=filename, ... )
  filename
}




#' @rdname dumpers
#'
#' @details
#'
#' `dump_xml_to_db` writes raw XMLs to a single text column in a database.
#' Requires \code{as == "raw"}.
#'
#' @param dbcon DBI-compliant database connection
#' @param table_name character, name of the table to write into
#' @param field_name character, name of the field to write into
#'
#' @return `dump_xml_to_db` returns \code{NULL}
#'
#' @export
dump_raw_to_db <- function(res, args, as, dbcon, table_name, field_name, ...) {
  stopifnot( as == "raw" )
  dframe <- data.frame(x=as.character(res), stringsAsFactors = FALSE)
  names(dframe) <- field_name
  DBI::dbWriteTable(con=dbcon, name=table_name, value=dframe, row.names=FALSE, append=TRUE, ...)
  invisible(NULL)
}





#' @rdname dumpers
#'
#' @details
#'
#' `dump_to_rds` saves results in an `.rds` file via \code{\link{saveRDS}}. Type
#' of object being saved is determined by \code{as} argument. File names are
#' created with \code{\link{Sys.time}} with ":" and spaces replaced with "-" and
#' "_" respectively. \code{file_prefix} is used when provided.
#'
#' @return `dump_to_rds` returns the name of the created file.
#'
#' @export
dump_to_rds <- function(res, args, as, file_prefix=NULL, ...) {
  filename <- paste0(chartr(": ", "-_", Sys.time()), ".rds")
  if( !is.null(file_prefix) ) {
    filename <- file.path(file_prefix, filename)
  }
  saveRDS(res, file=filename, ...)
  filename
}




# Checking dumper arguments
valid_dumper <- function(dumper, dumper_args) {
  rval <- NULL
  stopifnot(is.function(dumper))

  # Arguments of dumper function
  dargs <- formals(dumper)
  darg_has_default <- !sapply(dargs, is.symbol)
  d_has_ddd <- "..." %in% names(dargs)

  # Dumper has minimal obligatory args
  a <- c("res", "args", "as")
  has_a <- a %in% names(dargs)
  if(!all(has_a))
    rval <- c(rval,
              paste("dumper misses obligatory arguments:",
                    paste(a[has_a], collapse=", ") )
    )

  # Additional user arguments for dumper: dumper_args

  # Dumper requires user arguments which are not supplied
  aa <- setdiff( names(dargs[!darg_has_default]), c(a, "..."))
  z <- aa %in% names(dumper_args)
  if(any(!z))
    rval <- c(rval,
              paste("required user arguments (dumper_args) missing:",
                    paste(aa[!z], collapse=", ") )
              )



  if(!is.null(dumper_args)) {
    uargs <- names(dumper_args)

    # User supplied res/args/as argument(s)
    z <- a %in% names(dumper_args)
    if( any(z) )
      rval <- c(rval, paste("dumper_args not allowed:",
                            paste(a[z], collapse=", ") ))

    # User arguments that will not be accepted by dumper
    z <- uargs %in% names(dargs)
    if( any(!z) && !d_has_ddd )
      rval <- c(rval, paste("user arguments (dumper_args) not accepted by dumper:",
                            paste(names(dumper_args)[!z], collapse=", ") )
      )
  }

  # Returning
  if(is.null(rval)) {
    return(TRUE)
  } else {
    stop( paste(rval, collapse="\n"))
  }
}