## Test environments

* local OS X install, R 3.3.2
* ubuntu 12.04 (on travis-ci), R 3.3.2
* win-builder (devel and release)
* R-hub (Windows Server R-oldrel, Ubuntu Linux R-release, Fedora Linux R-devel)

## R CMD check results

0 errors | 0 warnings | 1 note

  License components with restrictions and base license permitting such:
    MIT + file LICENSE
  File 'LICENSE':
    YEAR: 2016
    COPYRIGHT HOLDER: Scott Chamberlain

## Reverse dependencies

* I have run R CMD check on the 4 downstream dependencies, with 
no problems related to this package. Results are at
<https://github.com/ropensci/oai/blob/master/revdep/README.md>
* The revdep maintainers are me.

------

This version adds new parsing ability for certain data types, now
imports tibble for compact data.frame's and other minor improvements.


Thanks!
Scott Chamberlain
