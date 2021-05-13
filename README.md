

[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-check](https://github.com/ropensci/oai/actions/workflows/R-check.yml/badge.svg)](https://github.com/ropensci/oai/actions/workflows/R-check.yml)
[![cran checks](https://cranchecks.info/badges/worst/oai)](https://cranchecks.info/pkgs/oai)
[![codecov.io](https://codecov.io/github/ropensci/oai/coverage.svg?branch=master)](https://codecov.io/github/ropensci/oai?branch=master) 
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/oai?color=2ED968)](https://github.com/r-hub/cranlogs.app) 
[![cran version](https://www.r-pkg.org/badges/version/oai)](https://cran.r-project.org/package=oai) 
[![](https://badges.ropensci.org/19_status.svg)](https://github.com/ropensci/software-review/issues/19)

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
#> 1       DataCite https://oai.datacite.org/oai             2.0
#>             adminEmail    earliestDatestamp deletedRecord          granularity
#> 1 support@datacite.org 2011-01-01T00:00:00Z    persistent YYYY-MM-DDThh:mm:ssZ
#>   compression compression.1                                    description
#> 1        gzip       deflate oaioai.datacite.org:oai:oai.datacite.org:12425
```

## ListIdentifiers


```r
list_identifiers(from = '2018-05-01T', until = '2018-06-01T')
#> # A tibble: 85 x 5
#>    identifier         datestamp     setSpec             setSpec.1      setSpec.2
#>    <chr>              <chr>         <chr>               <chr>          <chr>    
#>  1 cf7fbc99-de82-41a… 2018-05-31T1… installation:791e3… dataset_type:… country:…
#>  2 09d5405e-ca86-45f… 2018-05-30T1… installation:804b8… dataset_type:… country:…
#>  3 4b64d1f2-31c2-40c… 2018-05-30T1… installation:804b8… dataset_type:… country:…
#>  4 884378d6-d591-476… 2018-05-29T1… installation:a1650… dataset_type:… country:…
#>  5 18799ce9-1a66-40f… 2018-05-14T1… installation:d1b0a… dataset_type:… country:…
#>  6 7e91aacb-c994-41e… 2018-05-21T1… installation:d5b61… dataset_type:… country:…
#>  7 f83746ee-4cf2-4e6… 2018-05-08T0… installation:c4195… dataset_type:… country:…
#>  8 a3533a61-6f88-443… 2018-05-08T1… installation:06d75… dataset_type:… country:…
#>  9 ba9b66a3-2d11-419… 2018-05-05T2… installation:d1b0a… dataset_type:… country:…
#> 10 78b696d9-8f0d-41a… 2018-05-05T2… installation:d1b0a… dataset_type:… country:…
#> # … with 75 more rows
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
#> # A tibble: 42 x 26
#>    identifier datestamp setSpec setSpec.1 setSpec.2 title publisher identifier.1
#>    <chr>      <chr>     <chr>   <chr>     <chr>     <chr> <chr>     <chr>       
#>  1 18799ce9-… 2018-05-… instal… dataset_… country:… Bird… Sokoine … https://www…
#>  2 f83746ee-… 2018-05-… instal… dataset_… country:… NDFF… Dutch Na… https://www…
#>  3 a3533a61-… 2018-05-… instal… dataset_… country:… EDP … EDP - En… https://www…
#>  4 ba9b66a3-… 2018-05-… instal… dataset_… country:… Ende… Sokoine … https://www…
#>  5 78b696d9-… 2018-05-… instal… dataset_… country:… Ende… Sokoine … https://www…
#>  6 c791b255-… 2018-05-… instal… dataset_… country:… Ende… Sokoine … https://www…
#>  7 b929ccda-… 2018-05-… instal… dataset_… country:… List… Sokoine … https://www…
#>  8 da285c2a-… 2018-05-… instal… dataset_… country:… Moni… Corporac… https://www…
#>  9 87372877-… 2018-05-… instal… dataset_… country:… Moni… Corporac… https://www…
#> 10 ed7d4c25-… 2018-05-… instal… dataset_… country:… Samo… Ministry… https://www…
#> # … with 32 more rows, and 18 more variables: subject <chr>, source <chr>,
#> #   description <chr>, description.1 <chr>, type <chr>, creator <chr>,
#> #   date <chr>, language <chr>, coverage <chr>, coverage.1 <chr>, format <chr>,
#> #   source.1 <chr>, subject.1 <chr>, creator.1 <chr>, coverage.2 <chr>,
#> #   description.2 <chr>, creator.2 <chr>, subject.2 <chr>
```

## GetRecords


```r
ids <- c("87832186-00ea-44dd-a6bf-c2896c4d09b4", "d981c07d-bc43-40a2-be1f-e786e25106ac")
get_records(ids)
#> $`87832186-00ea-44dd-a6bf-c2896c4d09b4`
#> $`87832186-00ea-44dd-a6bf-c2896c4d09b4`$header
#> # A tibble: 1 x 3
#>   identifier              datestamp      setSpec                                
#>   <chr>                   <chr>          <chr>                                  
#> 1 87832186-00ea-44dd-a6b… 2018-06-29T12… installation:729a7375-b120-4e4f-bb81-a…
#> 
#> $`87832186-00ea-44dd-a6bf-c2896c4d09b4`$metadata
#> # A tibble: 0 x 0
#> 
#> 
#> $`d981c07d-bc43-40a2-be1f-e786e25106ac`
#> $`d981c07d-bc43-40a2-be1f-e786e25106ac`$header
#> # A tibble: 1 x 3
#>   identifier              datestamp      setSpec                                
#>   <chr>                   <chr>          <chr>                                  
#> 1 d981c07d-bc43-40a2-be1… 2018-01-21T21… installation:804b8dd0-07ac-4a30-bf92-3…
#> 
#> $`d981c07d-bc43-40a2-be1f-e786e25106ac`$metadata
#> # A tibble: 1 x 12
#>   title  publisher  identifier  subject  source  description type  creator date 
#>   <chr>  <chr>      <chr>       <chr>    <chr>   <chr>       <chr> <chr>   <chr>
#> 1 Peces… Instituto… https://ww… peces, … http:/… Caracteriz… Data… Fernan… 2018…
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
#> # A tibble: 597 x 2
#>    setSpec                     setName         
#>    <chr>                       <chr>           
#>  1 dataset_type                per dataset type
#>  2 dataset_type:OCCURRENCE     occurrence      
#>  3 dataset_type:CHECKLIST      checklist       
#>  4 dataset_type:METADATA       metadata        
#>  5 dataset_type:SAMPLING_EVENT sampling_event  
#>  6 country                     per country     
#>  7 country:AD                  Andorra         
#>  8 country:AM                  Armenia         
#>  9 country:AO                  Angola          
#> 10 country:AR                  Argentina       
#> # … with 587 more rows
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
#> 1 oai:biodiversitylibrary.org:item/7 2016-01-26T06:05:19Z item   
#> 
#> $`oai:biodiversitylibrary.org:item/7`$metadata
#> # A tibble: 1 x 10
#>   title   creator  subject  description  publisher contributor type  identifier 
#>   <chr>   <chr>    <chr>    <chr>        <chr>     <chr>       <chr> <chr>      
#> 1 Die Mu… Fleisch… Bogor;I… pt.5:v.1 (1… Leiden :… Missouri B… text… https://ww…
#> # … with 2 more variables: language <chr>, rights <chr>
#> 
#> 
#> $`oai:biodiversitylibrary.org:item/9`
#> $`oai:biodiversitylibrary.org:item/9`$header
#> # A tibble: 1 x 3
#>   identifier                         datestamp            setSpec
#>   <chr>                              <chr>                <chr>  
#> 1 oai:biodiversitylibrary.org:item/9 2016-01-26T06:05:19Z item   
#> 
#> $`oai:biodiversitylibrary.org:item/9`$metadata
#> # A tibble: 1 x 10
#>   title   creator  subject  description  publisher contributor type  identifier 
#>   <chr>   <chr>    <chr>    <chr>        <chr>     <chr>       <chr> <chr>      
#> 1 Die Mu… Fleisch… Bogor;I… pt.5:v.3 (1… Leiden :… Missouri B… text… https://ww…
#> # … with 2 more variables: language <chr>, rights <chr>
```


## Acknowledgements

Michal Bojanowski thanks National Science Centre for support through grant 2012/07/D/HS6/01971.


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/oai/issues).
* License: MIT
* Get citation information for `oai` in R doing `citation(package = 'oai')`
* Please note that this project is released with a [Contributor Code of Conduct](https://ropensci.org/code-of-conduct/). By participating in this project you agree to abide by its terms.
