oai
===



[![Build Status](https://travis-ci.org/ropensci/oai.svg?branch=master)](https://travis-ci.org/ropensci/oai)
[![Build status](https://ci.appveyor.com/api/projects/status/h5qu574ky0rk3xxv?svg=true)](https://ci.appveyor.com/project/sckott/oai)
[![codecov.io](http://codecov.io/github/ropensci/oai/coverage.svg?branch=master)](http://codecov.io/github/ropensci/oai?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/oai?color=2ED968)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/oai)](http://cran.rstudio.com/web/packages/oai)

`oai` is an R client to work with OAI-PMH (Open Archives Initiative Protocol for Metadata Harvesting) services, a protocol developed by the [Open Archives Initiative](https://en.wikipedia.org/wiki/Open_Archives_Initiative). OAI-PMH uses XML data format transported over HTTP.

OAI-PMH Info:

* [Wikipedia](https://en.wikipedia.org/wiki/Open_Archives_Initiative_Protocol_for_Metadata_Harvesting)
* [OAI V2 specification](http://www.openarchives.org/OAI/openarchivesprotocol.html)

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
#> <ListRecords> 922 X 6 
#> 
#>                    identifier            datestamp setSpec setSpec.1
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
#> ..                        ...                  ...     ...       ...
#> Variables not shown: setSpec.2 (chr), setSpec.3 (chr)
```

## Count Identifiers


```r
count_identifiers()
#>                           url   count
#> 1 http://oai.datacite.org/oai 7070730
```

## ListRecords


```r
list_records(from = '2011-05-01T', until = '2011-08-15T')
#> <ListRecords> 124 X 44 
#> 
#>                    identifier            datestamp setSpec setSpec.1
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
#> ..                        ...                  ...     ...       ...
#> Variables not shown: title (chr), creator (chr), creator.1 (chr),
#>      creator.2 (chr), creator.3 (chr), creator.4 (chr), creator.5 (chr),
#>      creator.6 (chr), creator.7 (chr), publisher (chr), date (chr),
#>      identifier.2 (chr), identifier.1 (chr), subject (chr), description
#>      (chr), description.1 (chr), contributor (chr), language (chr), type
#>      (chr), type.1 (chr), format (chr), format.1 (chr), rights (chr),
#>      subject.1 (chr), relation (chr), subject.2 (chr), subject.3 (chr),
#>      subject.4 (chr), setSpec.2 (chr), setSpec.3 (chr), format.2 (chr),
#>      subject.5 (chr), subject.6 (chr), subject.7 (chr), description.2
#>      (chr), description.3 (chr), description.4 (chr), description.5 (chr),
#>      title.1 (chr), contributor.1 (chr)
```

## GetRecords


```r
get_records(c("oai:oai.datacite.org:32255", "oai:oai.datacite.org:32325"))
#> <GetRecord> 2 X 23 
#> 
#>                   identifier            datestamp setSpec setSpec.1
#> 1 oai:oai.datacite.org:32255 2011-07-01T12:09:24Z     TIB TIB.DAGST
#> 2 oai:oai.datacite.org:32325 2011-07-07T11:17:46Z     TIB TIB.DAGST
#> Variables not shown: title (chr), creator (chr), creator.1 (chr),
#>      creator.2 (chr), creator.3 (chr), publisher (chr), date (chr),
#>      identifier.1 (chr), subject (chr), subject.1 (chr), description
#>      (chr), description.1 (chr), contributor (chr), language (chr), type
#>      (chr), type.1 (chr), format (chr), format.1 (chr), rights (chr)
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
#> <ListSets> 1363 X 2 
#> 
#>                     setSpec
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
#> ..                      ...
#> Variables not shown: setName (chr)
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
#>                                                                                                                                                                                                                                                                                                                                  description
#> 1 \n\tGBIF Registry\n\tGlobal Biodiversity Information Facility Secretariat\n\t\n\t\tThe GBIF Registry — the entities that make up the GBIF network.\n\t\tThis OAI-PMH service exposes Datasets, organized into sets of country, installation and resource type.\n\t\tFor more information, see http://www.gbif.org/developer/registry\n\t\n
```

Get records


```r
get_records(c("816f4734-6b49-41ab-8a1d-1b21e6b5486d", "95e3042f-f48d-4a04-8251-f755bebeced6"),
            url = "http://api.gbif.org/v1/oai-pmh/registry")
#> <GetRecord> 2 X 29 
#> 
#>                             identifier            datestamp
#> 1 816f4734-6b49-41ab-8a1d-1b21e6b5486d 2016-01-28T15:36:07Z
#> 2 95e3042f-f48d-4a04-8251-f755bebeced6 2016-01-24T23:01:17Z
#> Variables not shown: setSpec (chr), setSpec.1 (chr), setSpec.2 (chr),
#>      title (chr), publisher (chr), identifier.1 (chr), source (chr),
#>      description (chr), description.1 (chr), type (chr), language (chr),
#>      format (chr), source.1 (chr), subject (chr), subject.1 (chr),
#>      subject.2 (chr), subject.3 (chr), subject.4 (chr), subject.5 (chr),
#>      description.2 (chr), creator (chr), creator.1 (chr), date (chr),
#>      rights (chr), coverage (chr), coverage.1 (chr), coverage.2 (chr)
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
#>                                                                                                        description
#> 1 \n\t\t\n\t\t\toai\n\t\t\tbiodiversitylibrary.org\n\t\t\t:\n\t\t\toai:biodiversitylibrary.org:item/1000\n\t\t\n\t
```

Get records


```r
get_records(c("oai:biodiversitylibrary.org:item/7", "oai:biodiversitylibrary.org:item/9"),
            url = "http://www.biodiversitylibrary.org/oai")
#> <GetRecord> 2 X 32 
#> 
#>                           identifier            datestamp setSpec
#> 1 oai:biodiversitylibrary.org:item/7 2016-01-26T05:05:20Z    item
#> 2 oai:biodiversitylibrary.org:item/9 2016-01-26T05:05:20Z    item
#> Variables not shown: title (chr), creator (chr), creator.1 (chr),
#>      creator.2 (chr), subject (chr), subject.1 (chr), subject.2 (chr),
#>      subject.3 (chr), subject.4 (chr), subject.5 (chr), subject.6 (chr),
#>      subject.7 (chr), subject.8 (chr), subject.9 (chr), subject.10 (chr),
#>      subject.11 (chr), subject.12 (chr), subject.13 (chr), subject.14
#>      (chr), subject.15 (chr), description (chr), publisher (chr),
#>      contributor (chr), date (chr), type (chr), type.1 (chr), identifier.1
#>      (chr), language (chr), rights (chr)
```


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/oai/issues).
* License: MIT
* Get citation information for `oai` in R doing `citation(package = 'oai')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

[![ropensci_footer](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
