# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.3.2 (2016-10-31) |
|system   |x86_64, darwin13.4.0         |
|ui       |X11                          |
|language |(EN)                         |
|collate  |en_US.UTF-8                  |
|tz       |America/Los_Angeles          |
|date     |2016-11-23                   |

## Packages

|package |*  |version  |date       |source                             |
|:-------|:--|:--------|:----------|:----------------------------------|
|oai     |   |0.2.2    |2016-11-23 |local (ropensci/oai@NA)            |
|RSQLite |   |1.0.9017 |2016-11-23 |Github (rstats-db/RSQLite@892a49f) |

# Check results
1 packages with problems

## rgbif (0.9.5)
Maintainer: Scott Chamberlain <myrmecocystus@gmail.com>  
Bug reports: https://github.com/ropensci/rgbif/issues

1 error  | 0 warnings | 0 notes

```
checking tests ... ERROR
Running the tests in ‘tests/test-all.R’ failed.
Last 13 lines of output:
  > library(testthat)
  > test_check("rgbif")
  Loading required package: rgbif
  1. Failure: occ_facet paging works (@test-occ_facet.R#30) ----------------------
  Names of `aa` ('hasCoordinate', 'basisOfRecord', 'country') don't match 'country', 'basisOfRecord', 'hasCoordinate'
  
  
  testthat results ================================================================
  OK: 67 SKIPPED: 98 FAILED: 1
  1. Failure: occ_facet paging works (@test-occ_facet.R#30) 
  
  Error: testthat unit tests failed
  Execution halted
```

