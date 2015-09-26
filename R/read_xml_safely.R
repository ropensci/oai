# Parsing XML while trying to catch (some) exceptions
#
# The catching involves two steps:
#
# 1. The "net", currently `error_handler` for errors, that based on the content
# of the thrown exception invokes a particular restart function. Further
# handlers can be added for other types of exceptions (e.g. warnings, etc.).
#
# 2. A (set of) restart functions that are appropriately invoked by the
# handlers. Restarts should try to modify the object 'x' in the parent
# frame and re-run the parsing.
#
# Handling additional exceptions requires two steps:
#
# 1. Expand the existing, or add a new, exception handler that is called by
# `tryCatch` and trigger a neccessary restart function.
#
# 2. Write a restart function that will modify the `read_xml` input in the
# parent frame.

read_xml_safely <- function(x, ...)
{
  # Handlers:

  # Handles *errors* thrown by xml2::read_xml
  error_handler <- function(er) {
    # Catch invalid characters in XML
    if(grepl("PCDATA invalid Char value", er$message)) {
      msg <- paste0("invalid characters in XML:\n",
                    er$message,
                    "\n",
                    "Removing")
      warning(msg)
      invokeRestart("drop_invalid_chars")
    } else {
      return(er)
    }
  }

  # Try to `read_xml` with restarts
  repeat {
    withRestarts(
      tryCatch(
        return( xml2::read_xml(x, ...) ),
        error = error_handler
      ),

      # Restart functions that should modify `x` in the *parent frame*

      # Remove UTF-8 characters that are invalid in XML
      drop_invalid_chars = function() {
        x <<- gsub("[^\u9\uA\uD\u20-\uD7FF\uE000-\uFFFD\u10000-\u10FFFF]", "", x, perl=TRUE)
      }
    )
  }
}