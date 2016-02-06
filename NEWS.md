oai 0.2.0
===========

### NEW FEATURES

* Changed `id()` to `id_entify()` to not conflict with `dplyr::id()`, and 
didn't want to conflict with `graphics::identify()` (#30)
* A set of new functions for dealing with larger data results: `dump_raw_to_txt()`, `dump_to_rds()`, and `dump_raw_to_db()`. They can be used with `oai` functions 
`list_identifiers()`, `list_sets()`, and `list_records()` (#9) (#15) (#21) 
thanks @mbojan

### MINOR IMPROVEMENTS

* Sped up some tests (#19)
* Better description of OAI protocol in the `DESCRIPTION` file (#28)
* Commented about where some internal functions come from (#31)
* Import `plyr` for `rbind.fill()` (#32)
* Including now some examples using OAI-PMH with GBIF and BHL (#33)
* Better error handling! (#10) (#12) (#22) (#27) thanks @mbojan

### BUG FIXES

* Fixed bug where `list_identifiers()` threw error when no result was found (#13)
* Dealing better with bad inputs to `as` parameter - stop with informative message
now instead of failing without anything returned (#34)

oai 0.1.0
=========

* Released to CRAN.
