sc <- function(l) Filter(Negate(is.null), l)

pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

last <- function(x) x[length(x)][[1]]

datacite_base <- function() "http://oai.datacite.org/oai"





# Simple condition generator as shown here
# http://adv-r.had.co.nz/Exceptions-Debugging.html#condition-handling
condition <- function(subclass, message, call = sys.call(-1), ...) {
  structure(
    class = unique(c(subclass, "condition")),
    list(message = message, call = call),
    ...
  )
}

# is it a condition?
is.condition <- function(x) inherits(x, "condition")
