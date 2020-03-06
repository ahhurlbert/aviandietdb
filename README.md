
<!-- README.md is generated from README.Rmd. Please edit that file -->

# aviandietdb

<!-- badges: start -->

<!-- badges: end -->

**aviandietdb** provides access to the Avian Diet Database, which
contains quantitative diet data for bird species as well as contextual
information about where and when those data were collected.

The archived database currently includes **56,008** diet records for
**600** bird species. This is a growing database, and while it is
currently North American biased, we hope to continue adding avian diet
data from around the world.

You can find the development version of the database
[here](https://github.com/hurlbertlab/dietdatabase).

This R package provides a few simple functions for summarizing and
querying the database.

## Installation

You can install **aviandietdb** from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ahhurlbert/aviandietdb")
```

## Database

Load the library and then the R data file that contains the raw data.

``` r
library(aviandietdb)

data(dietdb)
```

Typing `?dietdb` will provide a description of the 42 data fields in
this database.

A summary of the total number of records by species, and the total
number of species with data by family is provided using `dbSummary()`.

``` r
dbSummary()
#> $numRecords
#> [1] 56008
#> 
#> $numSpecies
#> [1] 600
#> 
#> $numStudies
#> [1] 778
#> 
#> $recordsPerSpecies
#> # A tibble: 600 x 3
#>    Common_Name                                   Family               n
#>    <chr>                                         <chr>            <int>
#>  1 Abert's Towhee                                Passerellidae       17
#>  2 Acadian Flycatcher                            Tyrannidae          37
#>  3 Acorn Woodpecker                              Picidae             70
#>  4 Adelaide's Warbler                            Parulidae           33
#>  5 African Pygmy-Goose                           Anatidae            10
#>  6 Alder/Willow Flycatcher (Traill's Flycatcher) Tyrannidae          87
#>  7 American Avocet                               Recurvirostridae     8
#>  8 American Black Duck                           Anatidae            51
#>  9 American Coot                                 Rallidae           198
#> 10 American Crow                                 Corvidae           225
#> # ... with 590 more rows
#> 
#> $speciesPerFamily
#> # A tibble: 99 x 4
#>    Order            Family        SpeciesWithData PercentComplete
#>    <chr>            <chr>                   <dbl>           <dbl>
#>  1 Accipitriformes  Accipitridae               25              71
#>  2 Accipitriformes  Pandionidae                 1             100
#>  3 Anseriformes     Anatidae                  103              88
#>  4 Bucerotiformes   Upupidae                    0               0
#>  5 Caprimulgiformes Apodidae                    2              20
#>  6 Caprimulgiformes Caprimulgidae               4              40
#>  7 Caprimulgiformes Trochilidae                11              37
#>  8 Cathartiformes   Cathartidae                 3              75
#>  9 Charadriiformes  Alcidae                     1               4
#> 10 Charadriiformes  Charadriidae                1               6
#> # ... with 89 more rows
```

## Diet\_Type

When examining these diet data it is important to understand the
different possible ways that investigators may have quantified the
importance of different diet items, because these different methods are
not necessarily comparable with each other. This means any summaries
will be specific to a particular ‘Diet\_Type’. In this database, the
possible values are:

  - **Items** - the fraction of the diet based on the proportion of
    total diet items examined (e.g. 9 out of 12 prey items examined were
    ants);  
  - **Wt\_or\_Vol** - the fraction of the diet based on the proportional
    weight or volume of the prey taxa examined (e.g. ants made up 10% of
    the diet by mass);  
  - **Occurrence** - the proportion of bird specimens (e.g. stomachs,
    nests, fecal samples) that included at least one of the specified
    prey taxa (e.g. ants occurred in 90% of stomachs examined);
    **NOTE:** this is the one measure that need not sum to 100% across
    diet items within a given analysis;  
  - **Unspecified** - in the event that it is unclear from the Methods
    section of the study which measure was being used, it is listed as
    “Unspecified”

## Summary functions

For now, we provide just three simple ways to summarize data from the
Diet Database.

### speciesSummary()

The `speciesSummary()` function provides a summary of what kinds of data
are available for the specified bird species, as well as a quantitative
summary at the taxonomic level specified. In the example below, you can
see (1) the list of all studies providing quantitative diet data, (2)
the total number of diet records, (3) the distribution of those records
seasonally, (4) the distribution of those records across years and
states/provinces, (5) the distribution of records by the taxonomic level
to which prey were identified, (6) the distribution of records by
Diet\_Type, (7) the total number of diet analyses conducted for each
Diet\_Type, and (8) a quantitative summary of the diet at the specified
taxonomic level averaged across all available studies of a given
Diet\_Type.

``` r
speciesSummary("Sharp-shinned hawk", by = "Class")
#> $Studies
#> [1] "Joy, S. M., R. T. Reynolds, R. L. Knight, and R. W. Hoffman. 1994. Feeding ecology of Sharp-shinned Hawks nesting in deciduous and coniferous forests in Colorado. Condor 96:455-467."
#> [2] "Quinn, M. S. 1991. Nest site and prey of a pair of Sharp-shinned Hawks in Alberta. Journal of Raptor Research 25:18-19."                                                              
#> [3] "Reynolds, R. T. and E. C. Meslow. 1984. Partitioning of food and niche characteristics of coexisting Accipiter during breeding. Auk 101:761-777."                                     
#> [4] "Snyder, N. F. R. and J. W. Wiley. 1976. Sexual size dimorphism in hawks and owls of North America. Ornithological Monographs 20."                                                     
#> [5] "Storer, R. W. 1966. Sexual dimorphism and food habits of three North American accipiters. Auk 83:423-436."                                                                            
#> [6] "Toland, B. 1986. Hunting success of some Missouri raptors. Wilson Bulletin 98:116-125."                                                                                               
#> [7] "Mitchell, R. T. 1952. Consumption of Spruce Budworms by Birds in a Maine Spruce-Fir Forest. Journal of Forestry 50(5):387-389. "                                                      
#> 
#> $numRecords
#> [1] 206
#> 
#> $recordsPerSeason
#>   Observation_Season   n
#> 1           multiple   2
#> 2             summer   9
#> 3        unspecified 195
#> 
#> $recordsPerYearRegion
#>   Location_Region 1950 1966 1974 1976 1985 1987 1989
#> 1         Alberta   NA   NA   NA   NA   NA    8   NA
#> 2        Colorado   NA   NA   NA   NA   NA   NA  105
#> 3           Maine    1   NA   NA   NA   NA   NA   NA
#> 4        Missouri   NA   NA   NA   NA    2   NA   NA
#> 5   North America   NA   19   NA    4   NA   NA   NA
#> 6          Oregon   NA   NA   67   NA   NA   NA   NA
#> 
#> $recordsPerPreyIDLevel
#>     level   n
#> 1 Kingdom   3
#> 2  Phylum   2
#> 3   Class   6
#> 4   Order   0
#> 5  Family   8
#> 6   Genus  41
#> 7 Species 146
#> 
#> $recordsPerType
#>   Diet_Type   n
#> 1     Items 186
#> 2 Wt_or_Vol  20
#> 
#> $analysesPerDietType
#>   Diet_Type n
#> 1     Items 6
#> 2 Wt_or_Vol 2
#> 
#> $preySummary
#>            Taxon  Items Wt_or_Vol
#> 1           Aves 0.8975    0.3571
#> 4 Unid. Animalia 0.0626    0.1194
#> 2       Mammalia 0.0373    0.0234
#> 3       Reptilia 0.0014        NA
#> 5 Unid. Chordata 0.0010    0.5000
```

### dietSummary()

The `dietSummary()` function only returns the quantitative diet summary,
but is more flexible with respect to specifying a season, region, set of
years, or Diet\_Type of interest.

``` r
dietSummary("Bald Eagle", by = "Class", season = "winter", yearRange = c(1985, 2000), dietType = "Wt_or_Vol")
#>       Taxon Frac_Diet
#> 1      Aves    0.5710
#> 2 Teleostei    0.3137
#> 3  Mammalia    0.1157

dietSummary("Black-throated Blue Warbler", by = "Order", season = "summer", dietType = "Items")
#>               Taxon Frac_Diet
#> 1 Lepidoptera larva    0.5415
#> 2        Coleoptera    0.2500
#> 3           Diptera    0.0690
#> 4       Lepidoptera    0.0690
#> 5         Hemiptera    0.0260
#> 6       Hymenoptera    0.0260
#> 7           Araneae    0.0185
```

### dietSummaryByPrey()

Finally, the `dietSummaryByPrey()` function provides a list of all bird
species that consume a particular prey taxon in decreasing order of
importance (and grouped by Diet\_Type). In addition to providing the
prey taxon name, you must also specify the taxonomic level of that name.
Like the `dietSummary()` function you can filter results just to
particular seasons, regions, years, or types of diet data.

There are two additional argument not present in `dietSummary()`. One is
`larvaOnly`, which if TRUE, only returns records in which the specified
prey taxon was consumed in larval form. If FALSE, records for any life
stage are returned. This is most relevant for Lepidoptera and a few
other insect groups, where one wants to single out the importance of
caterpillars or other larvae.

This returns a summary at the level of individual studies, in which a
single bird species might be listed multiple times because analyses were
carried out in different, seasons, regions, years, etc.

``` r
caterpillars = dietSummaryByPrey("Lepidoptera", preyLevel = "Order", dietType = "Items", larvaOnly = TRUE)

head(caterpillars, 10)
#>                     Common_Name       Family Location_Region
#> 1                  Oak Titmouse      Paridae      California
#> 2            Philadelphia Vireo   Vireonidae   New Hampshire
#> 3                Red-eyed Vireo   Vireonidae   New Hampshire
#> 4          Yellow-billed Cuckoo    Cuculidae     Puerto Rico
#> 5        Rose-breasted Grosbeak Cardinalidae   New Hampshire
#> 6  Black-throated Green Warbler    Parulidae   New Hampshire
#> 7        Black-capped Chickadee      Paridae   West Virginia
#> 8   Black-throated Blue Warbler    Parulidae   New Hampshire
#> 9             Tennessee Warbler    Parulidae         Ontario
#> 10             Cape May Warbler    Parulidae         Ontario
#>    Observation_Year_End Observation_Season Diet_Type Fraction_Diet
#> 1                  1990             spring     Items     0.8800000
#> 2                  1979             summer     Items     0.8730000
#> 3                  1979             summer     Items     0.8680000
#> 4                  1912             summer     Items     0.8333333
#> 5                  1979             summer     Items     0.8290000
#> 6                  1979             summer     Items     0.8280000
#> 7                  1986             Summer     Items     0.8152466
#> 8                  1979             summer     Items     0.8070000
#> 9                  1994             summer     Items     0.8020000
#> 10                 1994             summer     Items     0.7910000
#>       PreyName PreyLevel LarvaOnly
#> 1  Lepidoptera     Order      TRUE
#> 2  Lepidoptera     Order      TRUE
#> 3  Lepidoptera     Order      TRUE
#> 4  Lepidoptera     Order      TRUE
#> 5  Lepidoptera     Order      TRUE
#> 6  Lepidoptera     Order      TRUE
#> 7  Lepidoptera     Order      TRUE
#> 8  Lepidoptera     Order      TRUE
#> 9  Lepidoptera     Order      TRUE
#> 10 Lepidoptera     Order      TRUE
```

By specifying `speciesMean = TRUE`, only a single value is returned for
each bird species that is the average across all analyses meeting the
season, region, and year criteria.

``` r
caterpillarsMean = dietSummaryByPrey("Lepidoptera", preyLevel = "Order", dietType = "Items", larvaOnly = TRUE, speciesMean = TRUE)

head(caterpillarsMean, 10)
#>                     Common_Name       Family Diet_Type Fraction_Diet
#> 1            Philadelphia Vireo   Vireonidae     Items     0.6865000
#> 2                  Oak Titmouse      Paridae     Items     0.6633333
#> 3  Black-throated Green Warbler    Parulidae     Items     0.5900000
#> 4          Blackburnian Warbler    Parulidae     Items     0.5732500
#> 5   Black-throated Blue Warbler    Parulidae     Items     0.5415000
#> 6              Cerulean Warbler    Parulidae     Items     0.5243750
#> 7        Rose-breasted Grosbeak Cardinalidae     Items     0.4925000
#> 8              Cape May Warbler    Parulidae     Items     0.4835000
#> 9             Blue-headed Vireo   Vireonidae     Items     0.4784500
#> 10            Tennessee Warbler    Parulidae     Items     0.4718333
#>       PreyName PreyLevel LarvaOnly
#> 1  Lepidoptera     Order      TRUE
#> 2  Lepidoptera     Order      TRUE
#> 3  Lepidoptera     Order      TRUE
#> 4  Lepidoptera     Order      TRUE
#> 5  Lepidoptera     Order      TRUE
#> 6  Lepidoptera     Order      TRUE
#> 7  Lepidoptera     Order      TRUE
#> 8  Lepidoptera     Order      TRUE
#> 9  Lepidoptera     Order      TRUE
#> 10 Lepidoptera     Order      TRUE
```
