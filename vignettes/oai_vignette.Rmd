<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{oai introduction}
%\VignetteEncoding{UTF-8}
-->



oai introduction
================

A general purpose client to work with any 'OAI-PMH' service. The 'OAI-PMH' protocol is described at [http://www.openarchives.org/OAI/openarchivesprotocol.html](http://www.openarchives.org/OAI/openarchivesprotocol.html). The main functions follow the OAI-PMH verbs:

* `GetRecord`
* `Identify`
* `ListIdentifiers`
* `ListMetadataFormats`
* `ListRecords`
* `ListSets`

## Get oai

Install from CRAN


```r
install.packages("oai")
```

Or install the development version from GitHub


```r
devtools::install_github("ropensci/oai")
```

Load `oai`


```r
library("oai")
```

## Identify


```r
id("http://oai.datacite.org/oai")
#>   repositoryName                     baseURL protocolVersion
#> 1   DataCite MDS http://oai.datacite.org/oai             2.0
#>           adminEmail    earliestDatestamp deletedRecord
#> 1 admin@datacite.org 2011-01-01T00:00:00Z    persistent
#>            granularity compression compression.1
#> 1 YYYY-MM-DDThh:mm:ssZ        gzip       deflate
#>                                      description
#> 1 oaioai.datacite.org:oai:oai.datacite.org:12425
```

## ListIdentifiers


```r
list_identifiers(from = '2011-05-01T', until = '2011-09-01T')
#> # A tibble: 889 × 6
#>                    identifier            datestamp setSpec setSpec.1
#>                         <chr>                <chr>   <chr>     <chr>
#> 1  oai:oai.datacite.org:32153 2011-06-08T08:57:11Z     TIB  TIB.WDCC
#> 2  oai:oai.datacite.org:32200 2011-06-20T08:12:41Z     TIB TIB.DAGST
#> 3  oai:oai.datacite.org:32220 2011-06-28T14:11:08Z     TIB TIB.DAGST
#> 4  oai:oai.datacite.org:32241 2011-06-30T13:24:45Z     TIB TIB.DAGST
#> 5  oai:oai.datacite.org:32255 2011-07-01T12:09:24Z     TIB TIB.DAGST
#> 6  oai:oai.datacite.org:32282 2011-07-05T09:08:10Z     TIB TIB.DAGST
#> 7  oai:oai.datacite.org:32309 2011-07-06T12:30:54Z     TIB TIB.DAGST
#> 8  oai:oai.datacite.org:32310 2011-07-06T12:42:32Z     TIB TIB.DAGST
#> 9  oai:oai.datacite.org:32325 2011-07-07T11:17:46Z     TIB TIB.DAGST
#> 10 oai:oai.datacite.org:32326 2011-07-07T11:18:47Z     TIB TIB.DAGST
#> # ... with 879 more rows, and 2 more variables: setSpec.2 <chr>,
#> #   setSpec.3 <chr>
```

## Count Identifiers


```r
count_identifiers()
#>                           url   count
#> 1 http://oai.datacite.org/oai 8333894
```

## ListRecords


```r
list_records(from = '2011-05-01T', until = '2011-08-15T')
#> # A tibble: 109 × 44
#>                    identifier            datestamp setSpec setSpec.1
#>                         <chr>                <chr>   <chr>     <chr>
#> 1  oai:oai.datacite.org:32153 2011-06-08T08:57:11Z     TIB  TIB.WDCC
#> 2  oai:oai.datacite.org:32200 2011-06-20T08:12:41Z     TIB TIB.DAGST
#> 3  oai:oai.datacite.org:32220 2011-06-28T14:11:08Z     TIB TIB.DAGST
#> 4  oai:oai.datacite.org:32241 2011-06-30T13:24:45Z     TIB TIB.DAGST
#> 5  oai:oai.datacite.org:32255 2011-07-01T12:09:24Z     TIB TIB.DAGST
#> 6  oai:oai.datacite.org:32282 2011-07-05T09:08:10Z     TIB TIB.DAGST
#> 7  oai:oai.datacite.org:32309 2011-07-06T12:30:54Z     TIB TIB.DAGST
#> 8  oai:oai.datacite.org:32310 2011-07-06T12:42:32Z     TIB TIB.DAGST
#> 9  oai:oai.datacite.org:32325 2011-07-07T11:17:46Z     TIB TIB.DAGST
#> 10 oai:oai.datacite.org:32326 2011-07-07T11:18:47Z     TIB TIB.DAGST
#> # ... with 99 more rows, and 40 more variables: title <chr>,
#> #   creator <chr>, creator.1 <chr>, creator.2 <chr>, creator.3 <chr>,
#> #   creator.4 <chr>, creator.5 <chr>, creator.6 <chr>, creator.7 <chr>,
#> #   publisher <chr>, date <chr>, identifier.2 <chr>, identifier.1 <chr>,
#> #   subject <chr>, description <chr>, description.1 <chr>,
#> #   contributor <chr>, language <chr>, type <chr>, type.1 <chr>,
#> #   format <chr>, format.1 <chr>, rights <chr>, subject.1 <chr>,
#> #   relation <chr>, subject.2 <chr>, subject.3 <chr>, subject.4 <chr>,
#> #   setSpec.2 <chr>, setSpec.3 <chr>, format.2 <chr>, subject.5 <chr>,
#> #   subject.6 <chr>, subject.7 <chr>, description.2 <chr>,
#> #   description.3 <chr>, description.4 <chr>, description.5 <chr>,
#> #   title.1 <chr>, contributor.1 <chr>
```

## GetRecords


```r
get_records(c("oai:oai.datacite.org:32255", "oai:oai.datacite.org:32325"))
#> # A tibble: 2 × 23
#>                   identifier            datestamp setSpec setSpec.1
#>                        <chr>                <chr>   <chr>     <chr>
#> 1 oai:oai.datacite.org:32255 2011-07-01T12:09:24Z     TIB TIB.DAGST
#> 2 oai:oai.datacite.org:32325 2011-07-07T11:17:46Z     TIB TIB.DAGST
#> # ... with 19 more variables: title <chr>, creator <chr>, creator.1 <chr>,
#> #   creator.2 <chr>, creator.3 <chr>, publisher <chr>, date <chr>,
#> #   identifier.1 <chr>, subject <chr>, subject.1 <chr>, description <chr>,
#> #   description.1 <chr>, contributor <chr>, language <chr>, type <chr>,
#> #   type.1 <chr>, format <chr>, format.1 <chr>, rights <chr>
```

## List MetadataFormats


```r
list_metadataformats(id = "oai:oai.datacite.org:32348")
#> $`oai:oai.datacite.org:32348`
#>   metadataPrefix
#> 1         oai_dc
#> 2       datacite
#> 3   oai_datacite
#>                                                        schema
#> 1              http://www.openarchives.org/OAI/2.0/oai_dc.xsd
#> 2 http://schema.datacite.org/meta/nonexistant/nonexistant.xsd
#> 3              http://schema.datacite.org/oai/oai-1.0/oai.xsd
#>                             metadataNamespace
#> 1 http://www.openarchives.org/OAI/2.0/oai_dc/
#> 2      http://datacite.org/schema/nonexistant
#> 3     http://schema.datacite.org/oai/oai-1.0/
```

## List Sets


```r
list_sets("http://oai.datacite.org/oai")
#> # A tibble: 1,651 × 2
#>                     setSpec
#>                       <chr>
#> 1                REFQUALITY
#> 2                      ANDS
#> 3           ANDS.REFQUALITY
#> 4             ANDS.CENTRE-1
#> 5  ANDS.CENTRE-1.REFQUALITY
#> 6             ANDS.CENTRE-2
#> 7  ANDS.CENTRE-2.REFQUALITY
#> 8             ANDS.CENTRE-3
#> 9  ANDS.CENTRE-3.REFQUALITY
#> 10            ANDS.CENTRE-5
#> # ... with 1,641 more rows, and 1 more variables: setName <chr>
```

## Examples of other OAI providers

### Global Biodiversity Information Facility

Identify


```r
id("http://api.gbif.org/v1/oai-pmh/registry")
#>   repositoryName                                 baseURL protocolVersion
#> 1  GBIF Registry http://api.gbif.org/v1/oai-pmh/registry             2.0
#>     adminEmail    earliestDatestamp deletedRecord          granularity
#> 1 dev@gbif.org 2007-01-01T00:00:01Z    persistent YYYY-MM-DDThh:mm:ssZ
#>                                                                                                                                                                                                                                                                                                                    description
#> 1 GBIF RegistryGlobal Biodiversity Information Facility Secretariat\n\t\tThe GBIF Registry — the entities that make up the GBIF network.\n\t\tThis OAI-PMH service exposes Datasets, organized into sets of country, installation and resource type.\n\t\tFor more information, see http://www.gbif.org/developer/registry\n\t
```

Get records


```r
get_records(c("816f4734-6b49-41ab-8a1d-1b21e6b5486d", "95e3042f-f48d-4a04-8251-f755bebeced6"),
            url = "http://api.gbif.org/v1/oai-pmh/registry")
#> # A tibble: 2 × 28
#>                             identifier            datestamp
#>                                  <chr>                <chr>
#> 1 816f4734-6b49-41ab-8a1d-1b21e6b5486d 2016-01-28T15:36:07Z
#> 2 95e3042f-f48d-4a04-8251-f755bebeced6 2016-08-30T13:43:31Z
#> # ... with 26 more variables: setSpec <chr>, setSpec.1 <chr>,
#> #   setSpec.2 <chr>, title <chr>, publisher <chr>, identifier.1 <chr>,
#> #   source <chr>, description <chr>, description.1 <chr>, type <chr>,
#> #   language <chr>, format <chr>, source.1 <chr>, subject <chr>,
#> #   subject.1 <chr>, subject.2 <chr>, subject.3 <chr>, subject.4 <chr>,
#> #   subject.5 <chr>, description.2 <chr>, creator <chr>, creator.1 <chr>,
#> #   date <chr>, coverage <chr>, coverage.1 <chr>, coverage.2 <chr>
```

### Biodiversity Heritage Library

Identify


```r
id("http://www.biodiversitylibrary.org/oai")
#>                                 repositoryName
#> 1 Biodiversity Heritage Library OAI Repository
#>                                  baseURL protocolVersion
#> 1 http://www.biodiversitylibrary.org/oai             2.0
#>                    adminEmail earliestDatestamp deletedRecord granularity
#> 1 oai@biodiversitylibrary.org        2006-01-01            no  YYYY-MM-DD
#>                                                        description
#> 1 oaibiodiversitylibrary.org:oai:biodiversitylibrary.org:item/1000
```

Get records


```r
get_records(c("oai:biodiversitylibrary.org:item/7", "oai:biodiversitylibrary.org:item/9"),
            url = "http://www.biodiversitylibrary.org/oai")
#> # A tibble: 2 × 17
#>                           identifier            datestamp setSpec
#>                                <chr>                <chr>   <chr>
#> 1 oai:biodiversitylibrary.org:item/7 2016-07-13T08:13:41Z    item
#> 2 oai:biodiversitylibrary.org:item/9 2016-07-13T08:13:41Z    item
#> # ... with 14 more variables: title <chr>, creator <chr>, subject <chr>,
#> #   subject.1 <chr>, subject.2 <chr>, description <chr>, publisher <chr>,
#> #   contributor <chr>, date <chr>, type <chr>, type.1 <chr>,
#> #   identifier.1 <chr>, language <chr>, rights <chr>
```
