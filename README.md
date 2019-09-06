

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://travis-ci.org/ropensci/oai.svg?branch=master)](https://travis-ci.org/ropensci/oai)
[![Build status](https://ci.appveyor.com/api/projects/status/h5qu574ky0rk3xxv?svg=true)](https://ci.appveyor.com/project/sckott/oai)
[![cran checks](https://cranchecks.info/badges/worst/oai)](https://cranchecks.info/pkgs/oai)
[![codecov.io](http://codecov.io/github/ropensci/oai/coverage.svg?branch=master)](http://codecov.io/github/ropensci/oai?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/oai?color=2ED968)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/oai)](https://cran.r-project.org/package=oai)
[![](https://badges.ropensci.org/19_status.svg)](https://github.com/ropensci/onboarding/issues/19)

`oai` is an R client to work with OAI-PMH (Open Archives Initiative Protocol for Metadata Harvesting) services, a protocol developed by the Open Archives Initiative (https://en.wikipedia.org/wiki/Open_Archives_Initiative). OAI-PMH uses XML data format transported over HTTP.

OAI-PMH Info:

* Wikipedia (https://en.wikipedia.org/wiki/Open_Archives_Initiative_Protocol_for_Metadata_Harvesting)
* OAI V2 specification (http://www.openarchives.org/OAI/openarchivesprotocol.html)

`oai` is built on `xml2` and `httr`. In addition, we give back data.frame's whenever possible to make data comprehension, manipulation, and visualization easier. We also have functions to fetch a large directory of OAI-PMH services - it isn't exhaustive, but does contain a lot.

OAI-PMH instead of paging with e.g., `page` and `per_page` parameters, uses (optionally) `resumptionTokens`, optionally with an expiration date. These tokens can be used to continue on to the next chunk of data, if the first request did not get to the end. Often, OAI-PMH services limit each request to 50 records, but this may vary by provider, I don't know for sure. The API of this package is such that we `while` loop for you internally until we get all records. We may in the future expose e.g., a `limit` parameter so you can say how many records you want, but we haven't done this yet.

## Install

Install from CRAN


```r
install.packages("oai")
```

Development version


```r
devtools::install_github("ropensci/oai")
```


```r
library("oai")
```

## Identify


```r
id("http://oai.datacite.org/oai")
#>   repositoryName                      baseURL protocolVersion
#> 1   DataCite MDS https://oai.datacite.org/oai             2.0
#>             adminEmail    earliestDatestamp deletedRecord
#> 1 support@datacite.org 2011-01-01T00:00:00Z    persistent
#>            granularity compression compression.1
#> 1 YYYY-MM-DDThh:mm:ssZ        gzip       deflate
#>                                      description
#> 1 oaioai.datacite.org:oai:oai.datacite.org:12425
```

## ListIdentifiers


```r
list_identifiers(from = '2018-05-01T', until = '2018-06-01T')
#> # A tibble: 255 x 5
#>    identifier        datestamp    setSpec            setSpec.1    setSpec.2
#>    <chr>             <chr>        <chr>              <chr>        <chr>
#>  1 cf7fbc99-de82-41… 2018-05-31T… installation:791e… dataset_typ… country:…
#>  2 cf7d6c01-309b-45… 2018-05-30T… installation:394c… dataset_typ… country:…
#>  3 cca13f2c-0d2c-4c… 2018-05-30T… installation:394c… dataset_typ… country:…
#>  4 09d5405e-ca86-45… 2018-05-30T… installation:804b… dataset_typ… country:…
#>  5 4b64d1f2-31c2-40… 2018-05-30T… installation:804b… dataset_typ… country:…
#>  6 884378d6-d591-47… 2018-05-29T… installation:a165… dataset_typ… country:…
#>  7 a0b06e2e-287a-46… 2018-05-31T… installation:4c5f… dataset_typ… country:…
#>  8 772de164-541d-4d… 2018-05-22T… installation:6884… dataset_typ… country:…
#>  9 f1a4ce9a-97cd-4d… 2018-05-21T… installation:394c… dataset_typ… country:…
#> 10 9d022797-7aa4-40… 2018-05-18T… installation:73eb… dataset_typ… country:…
#> # … with 245 more rows
```

## Count Identifiers


```r
count_identifiers()
#>                            url   count
#> 1 http://export.arxiv.org/oai2 1586724
```

## ListRecords


```r
list_records(from = '2018-05-01T', until = '2018-05-15T')
#> # A tibble: 44 x 26
#>    identifier datestamp setSpec setSpec.1 setSpec.2 title publisher
#>    <chr>      <chr>     <chr>   <chr>     <chr>     <chr> <chr>
#>  1 18799ce9-… 2018-05-… instal… dataset_… country:… Bird… Sokoine …
#>  2 79f51633-… 2018-05-… instal… dataset_… country:… Impl… Aïgos SAS
#>  3 f83746ee-… 2018-05-… instal… dataset_… country:… NDFF… Dutch Na…
#>  4 a3533a61-… 2018-05-… instal… dataset_… country:… EDP … EDP - En…
#>  5 ba9b66a3-… 2018-05-… instal… dataset_… country:… Ende… Sokoine …
#>  6 78b696d9-… 2018-05-… instal… dataset_… country:… Ende… Sokoine …
#>  7 c791b255-… 2018-05-… instal… dataset_… country:… Ende… Sokoine …
#>  8 b929ccda-… 2018-05-… instal… dataset_… country:… List… Sokoine …
#>  9 da285c2a-… 2018-05-… instal… dataset_… country:… Moni… Corporac…
#> 10 87372877-… 2018-05-… instal… dataset_… country:… Moni… Corporac…
#> # … with 34 more rows, and 19 more variables: identifier.1 <chr>,
#> #   subject <chr>, source <chr>, description <chr>, description.1 <chr>,
#> #   type <chr>, creator <chr>, date <chr>, language <chr>, coverage <chr>,
#> #   coverage.1 <chr>, format <chr>, source.1 <chr>, subject.1 <chr>,
#> #   coverage.2 <chr>, creator.1 <chr>, description.2 <chr>,
#> #   creator.2 <chr>, subject.2 <chr>
```

## GetRecords


```r
ids <- c("87832186-00ea-44dd-a6bf-c2896c4d09b4", "d981c07d-bc43-40a2-be1f-e786e25106ac")
get_records(ids)
#> $`87832186-00ea-44dd-a6bf-c2896c4d09b4`
#> $`87832186-00ea-44dd-a6bf-c2896c4d09b4`$header
#> # A tibble: 1 x 3
#>   identifier             datestamp      setSpec
#>   <chr>                  <chr>          <chr>
#> 1 87832186-00ea-44dd-a6… 2018-06-29T12… installation:729a7375-b120-4e4f-bb…
#>
#> $`87832186-00ea-44dd-a6bf-c2896c4d09b4`$metadata
#> # A tibble: 0 x 0
#>
#>
#> $`d981c07d-bc43-40a2-be1f-e786e25106ac`
#> $`d981c07d-bc43-40a2-be1f-e786e25106ac`$header
#> # A tibble: 1 x 3
#>   identifier             datestamp      setSpec
#>   <chr>                  <chr>          <chr>
#> 1 d981c07d-bc43-40a2-be… 2018-01-21T21… installation:804b8dd0-07ac-4a30-bf…
#>
#> $`d981c07d-bc43-40a2-be1f-e786e25106ac`$metadata
#> # A tibble: 1 x 12
#>   title publisher identifier subject source description type  creator date
#>   <chr> <chr>     <chr>      <chr>   <chr>  <chr>       <chr> <chr>   <chr>
#> 1 Pece… Institut… https://w… peces,… http:… Caracteriz… Data… Fernan… 2018…
#> # … with 3 more variables: language <chr>, coverage <chr>, format <chr>
```

## List MetadataFormats


```r
list_metadataformats(id = "87832186-00ea-44dd-a6bf-c2896c4d09b4")
#> $`87832186-00ea-44dd-a6bf-c2896c4d09b4`
#>   metadataPrefix                                                   schema
#> 1         oai_dc           http://www.openarchives.org/OAI/2.0/oai_dc.xsd
#> 2            eml http://rs.gbif.org/schema/eml-gbif-profile/1.0.2/eml.xsd
#>                             metadataNamespace
#> 1 http://www.openarchives.org/OAI/2.0/oai_dc/
#> 2          eml://ecoinformatics.org/eml-2.1.1
```

## List Sets


```r
list_sets("http://api.gbif.org/v1/oai-pmh/registry")
#> # A tibble: 572 x 2
#>    setSpec                     setName
#>    <chr>                       <chr>
#>  1 dataset_type                per dataset type
#>  2 dataset_type:OCCURRENCE     occurrence
#>  3 dataset_type:CHECKLIST      checklist
#>  4 dataset_type:METADATA       metadata
#>  5 dataset_type:SAMPLING_EVENT sampling_event
#>  6 country                     per country
#>  7 country:AD                  Andorra
#>  8 country:AO                  Angola
#>  9 country:AR                  Argentina
#> 10 country:AT                  Austria
#> # … with 562 more rows
```

## Examples of other OAI providers

### Biodiversity Heritage Library

Identify


```r
id("http://www.biodiversitylibrary.org/oai")
#>                                 repositoryName
#> 1 Biodiversity Heritage Library OAI Repository
#>                                   baseURL protocolVersion
#> 1 https://www.biodiversitylibrary.org/oai             2.0
#>                    adminEmail earliestDatestamp deletedRecord granularity
#> 1 oai@biodiversitylibrary.org        2006-01-01            no  YYYY-MM-DD
#>                                                        description
#> 1 oaibiodiversitylibrary.org:oai:biodiversitylibrary.org:item/1000
```

Get records


```r
get_records(c("oai:biodiversitylibrary.org:item/7", "oai:biodiversitylibrary.org:item/9"),
            url = "http://www.biodiversitylibrary.org/oai")
#> $`oai:biodiversitylibrary.org:item/7`
#> $`oai:biodiversitylibrary.org:item/7`$header
#> # A tibble: 1 x 3
#>   identifier                         datestamp            setSpec
#>   <chr>                              <chr>                <chr>
#> 1 oai:biodiversitylibrary.org:item/7 2016-07-13T09:13:41Z item
#>
#> $`oai:biodiversitylibrary.org:item/7`$metadata
#> # A tibble: 1 x 11
#>   title creator subject description publisher contributor date  type
#>   <chr> <chr>   <chr>   <chr>       <chr>     <chr>       <chr> <chr>
#> 1 Die … Fleisc… Bogor;… pt.5:v.1 (… Leiden :… Missouri B… 1900… text…
#> # … with 3 more variables: identifier <chr>, language <chr>, rights <chr>
#>
#>
#> $`oai:biodiversitylibrary.org:item/9`
#> $`oai:biodiversitylibrary.org:item/9`$header
#> # A tibble: 1 x 3
#>   identifier                         datestamp            setSpec
#>   <chr>                              <chr>                <chr>
#> 1 oai:biodiversitylibrary.org:item/9 2016-07-13T09:13:41Z item
#>
#> $`oai:biodiversitylibrary.org:item/9`$metadata
#> # A tibble: 1 x 11
#>   title creator subject description publisher contributor date  type
#>   <chr> <chr>   <chr>   <chr>       <chr>     <chr>       <chr> <chr>
#> 1 Die … Fleisc… Bogor;… pt.5:v.3 (… Leiden :… Missouri B… 1906… text…
#> # … with 3 more variables: identifier <chr>, language <chr>, rights <chr>
```


## Acknowledgements

Michal Bojanowski thanks National Science Centre for support through grant 2012/07/D/HS6/01971.


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/oai/issues).
* License: MIT
* Get citation information for `oai` in R doing `citation(package = 'oai')`
* Please note that this project is released with a [Contributor Code of Conduct][coc].
By participating in this project you agree to abide by its terms.

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)

[coc]: https://github.com/ropensci/oai/blob/master/CODE_OF_CONDUCT.md
