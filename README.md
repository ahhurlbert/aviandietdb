
<!-- README.md is generated from README.Rmd. Please edit that file -->
aviandietdb
===========

<!-- badges: start -->
<!-- badges: end -->
**aviandietdb** provides access to the Avian Diet Database, which contains quantitative diet data for bird species as well as contextual information about where and when those data were collected.

The archived database currently includes **56,008** diet records for **600** bird species. This is a growing database, and while it is currently North American biased, we hope to continue adding avian diet data from around the world.

You can find the development version of the database (which may include more recent records than what is available in the R package but which may still require data cleaning) [here](https://github.com/hurlbertlab/dietdatabase/blob/master/AvianDietDatabase.txt).

This R package provides a few simple functions for summarizing and querying the database.

Installation
------------

You can install **aviandietdb** from [GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("ahhurlbert/aviandietdb")
```

Database
--------

Load the library and then the R data file that contains the raw data.

``` r
library(aviandietdb)

data(dietdb)
```

Typing `?dietdb` will provide a description of the 42 data fields in this database.

A summary of the total number of records by species, and the total number of species with data by family is provided using `dbSummary()`.

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

Diet\_Type
----------

When examining these diet data it is important to understand the different possible ways that investigators may have quantified the importance of different diet items, because these different methods are not necessarily comparable with each other. This means any summaries will be specific to a particular 'Diet\_Type'. In this database, the possible values are:

-   **Items** - the fraction of the diet based on the proportion of total diet items examined (e.g. 9 out of 12 prey items examined were ants);
-   **Wt\_or\_Vol** - the fraction of the diet based on the proportional weight or volume of the prey taxa examined (e.g. ants made up 10% of the diet by mass);
-   **Occurrence** - the proportion of bird specimens (e.g. stomachs, nests, fecal samples) that included at least one of the specified prey taxa (e.g. ants occurred in 90% of stomachs examined); **NOTE:** this is the one measure that need not sum to 100% across diet items within a given analysis;
-   **Unspecified** - in the event that it is unclear from the Methods section of the study which measure was being used, it is listed as "Unspecified"

Summary functions
-----------------

For now, we provide just three simple ways to summarize data from the Diet Database.

### speciesSummary()

The `speciesSummary()` function provides a summary of what kinds of data are available for the specified bird species, as well as a quantitative summary at the taxonomic level specified. In the example below, you can see (1) the list of all studies providing quantitative diet data, (2) the total number of diet records, (3) the distribution of those records seasonally, (4) the distribution of those records across years and states/provinces, (5) the distribution of records by the taxonomic level to which prey were identified, (6) the distribution of records by Diet\_Type, (7) the total number of diet analyses conducted for each Diet\_Type, and (8) a quantitative summary of the diet at the specified taxonomic level averaged across all available studies of a given Diet\_Type. If the original data source indicated that specific parts of the prey taxon was consumed (e.g. fruit, seed, vegetation, etc.) then they are listed in the Prey_Part field. 

``` r
> speciesSummary("Tundra swan", by = "Class")
$Studies
[1] "Owen, M. and C.J. Cadbury. 1975. The ecology and mortality of swans at the Ouse Washes, England. Wildfowl 26:31-42."            
[2] "Stewart, R.E. and J.H. Manning. 1958. Distribution and ecology of Whistling Swans in the Chesapeake Bay region. Auk 75:203-212."
[3] "Earnst, S.L. 1992. Behavior and ecology of Tundra Swans during summer, autumn, and winter. Ph.D. Thesis. Ohio State University."

$numRecords
[1] 54

$recordsPerSeason
  Observation_Season  n
1                     5
2           multiple 11
3             winter 38

$recordsPerYearRegion
  Location_Region 1956 1975 1992
1          Alaska   NA   NA    5
2         England   NA   38   NA
3   United States   11   NA   NA

$recordsPerPreyIDLevel
     level  n
1  Kingdom  0
2   Phylum  5
3    Class  0
4    Order  1
5 Suborder  0
6   Family  0
7    Genus 11
8  Species 37

$recordsPerType
   Diet_Type  n
1      Items  5
2 Occurrence 38
3  Wt_or_Vol 11

$analysesPerDietType
   Diet_Type n
1      Items 1
2 Occurrence 1
3  Wt_or_Vol 1

$preySummary
               Taxon              Prey_Part Items Wt_or_Vol Occurrence
4      Magnoliopsida root; seed; vegetation 0.599    0.8597     0.0990
3       Cyanophyceae                     NA 0.232        NA         NA
8 Unid. Tracheophyta             vegetation 0.156        NA     0.0495
6   Unid. Arthropoda                     NA 0.013        NA         NA
1           Bivalvia                     NA    NA    0.1064         NA
2       Charophyceae                   gall    NA    0.0338         NA
5     Polypodiopsida             vegetation    NA        NA     0.0099
7  Unid. Chlorophyta             vegetation    NA        NA     0.0198

> speciesSummary("Tundra swan", by = "Family")
$Studies
[1] "Owen, M. and C.J. Cadbury. 1975. The ecology and mortality of swans at the Ouse Washes, England. Wildfowl 26:31-42."            
[2] "Stewart, R.E. and J.H. Manning. 1958. Distribution and ecology of Whistling Swans in the Chesapeake Bay region. Auk 75:203-212."
[3] "Earnst, S.L. 1992. Behavior and ecology of Tundra Swans during summer, autumn, and winter. Ph.D. Thesis. Ohio State University."

$numRecords
[1] 54

$recordsPerSeason
  Observation_Season  n
1                     5
2           multiple 11
3             winter 38

$recordsPerYearRegion
  Location_Region 1956 1975 1992
1          Alaska   NA   NA    5
2         England   NA   38   NA
3   United States   11   NA   NA

$recordsPerPreyIDLevel
     level  n
1  Kingdom  0
2   Phylum  5
3    Class  0
4    Order  1
5 Suborder  0
6   Family  0
7    Genus 11
8  Species 37

$recordsPerType
   Diet_Type  n
1      Items  5
2 Occurrence 38
3  Wt_or_Vol 11

$analysesPerDietType
   Diet_Type n
1      Items 1
2 Occurrence 1
3  Wt_or_Vol 1

$preySummary
                Taxon              Prey_Part Items Wt_or_Vol Occurrence
5          Cyperaceae root; seed; vegetation 0.379    0.0819     0.0297
10        Nostocaceae                     NA 0.232        NA         NA
14   Potamogetonaceae             vegetation 0.220    0.0378     0.0099
24 Unid. Tracheophyta             vegetation 0.156        NA     0.0495
21   Unid. Arthropoda                     NA 0.013        NA         NA
1          Asteraceae                   root    NA        NA     0.0099
2        Boraginaceae             vegetation    NA        NA     0.0099
3        Brassicaceae                   root    NA        NA     0.0396
4           Characeae                   gall    NA    0.0338         NA
6        Equisetaceae             vegetation    NA        NA     0.0099
7            Fabaceae       seed; vegetation    NA        NA     0.0297
8    Hydrocharitaceae             vegetation    NA    0.3378         NA
9              Myidae                     NA    NA    0.0276         NA
11     Plantaginaceae       root; vegetation    NA        NA     0.0099
12            Poaceae       seed; vegetation    NA    0.0276     0.0990
13       Polygonaceae                   seed    NA        NA     0.0297
15      Ranunculaceae       root; vegetation    NA        NA     0.0198
16           Rosaceae             vegetation    NA        NA     0.0099
17         Ruppiaceae             vegetation    NA    0.3306         NA
18         Salicaceae             vegetation    NA        NA     0.0099
19         Solanaceae                   root    NA        NA     0.0297
20         Tellinidae                     NA    NA    0.0788         NA
22  Unid. Chlorophyta             vegetation    NA        NA     0.0198
23       Unid. Poales                   root    NA    0.0440         NA```

### dietSummary()

The `dietSummary()` function only returns the quantitative diet summary, but is more flexible with respect to specifying a season, region, set of years, or Diet\_Type of interest.

``` r
dietSummary("Bald Eagle", by = "Class", season = "winter", yearRange = c(1985, 2000), dietType = "Wt_or_Vol")
      Taxon Prey_Part Frac_Diet
1      Aves        NA    0.5710
2 Teleostei        NA    0.3137
3  Mammalia        NA    0.1157

dietSummary("Black-throated Blue Warbler", by = "Order", season = "summer", dietType = "Items")
              Taxon Prey_Part Frac_Diet
1 Lepidoptera larva        NA    0.5415
2        Coleoptera        NA    0.2500
3           Diptera        NA    0.0690
4       Lepidoptera        NA    0.0690
5         Hemiptera        NA    0.0260
6       Hymenoptera        NA    0.0260
7           Araneae        NA    0.0185
```

### dietSummaryByPrey()

Finally, the `dietSummaryByPrey()` function provides a list of all bird species that consume a particular prey taxon in decreasing order of importance. In addition to providing the prey taxon name, you must also specify the taxonomic level of that name. Like the `dietSummary()` function you can filter results just to particular seasons, regions, years, or types of diet data.

There are two additional argument not present in `dietSummary()`. One is `preyStage`, which specifies the life stage of the prey item (if applicable) for which a summary should be conducted. By default ('any'), diet records will be included regardless of prey stage. Alternatively, one can specify that the summary should only be conducted for records including the terms 'larva', 'adult', or 'pupa' in the Diet Database's 'Prey\_Stage' field. This is most relevant for Lepidoptera and a few other insect groups, where one might want to single out the importance of caterpillars or other larvae, for example.

This returns a summary at the level of individual studies, in which a single bird species might be listed multiple times because analyses were carried out in different, seasons, regions, years, etc.

``` r
caterpillars = dietSummaryByPrey("Lepidoptera", preyLevel = "Order", dietType = "Items", preyStage = "larva")

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
#>    Observation_Year_End Observation_Season Diet_Type Fraction_Diet   Prey_Name
#> 1                  1990             spring     Items     0.8800000 Lepidoptera
#> 2                  1979             summer     Items     0.8730000 Lepidoptera
#> 3                  1979             summer     Items     0.8680000 Lepidoptera
#> 4                  1912             summer     Items     0.8333333 Lepidoptera
#> 5                  1979             summer     Items     0.8290000 Lepidoptera
#> 6                  1979             summer     Items     0.8280000 Lepidoptera
#> 7                  1986             Summer     Items     0.8152466 Lepidoptera
#> 8                  1979             summer     Items     0.8070000 Lepidoptera
#> 9                  1994             summer     Items     0.8020000 Lepidoptera
#> 10                 1994             summer     Items     0.7910000 Lepidoptera
#>    Prey_Level Prey_Stage
#> 1       Order      larva
#> 2       Order      larva
#> 3       Order      larva
#> 4       Order      larva
#> 5       Order      larva
#> 6       Order      larva
#> 7       Order      larva
#> 8       Order      larva
#> 9       Order      larva
#> 10      Order      larva
```

By specifying `speciesMean = TRUE`, only a single value is returned for each bird species that is the average across all analyses meeting the season, region, and year criteria.

``` r
caterpillarsMean = dietSummaryByPrey("Lepidoptera", preyLevel = "Order", dietType = "Items", 
                                     preyStage = "larva", speciesMean = TRUE)

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
#>      Prey_Name Prey_Level Prey_Stage
#> 1  Lepidoptera      Order      larva
#> 2  Lepidoptera      Order      larva
#> 3  Lepidoptera      Order      larva
#> 4  Lepidoptera      Order      larva
#> 5  Lepidoptera      Order      larva
#> 6  Lepidoptera      Order      larva
#> 7  Lepidoptera      Order      larva
#> 8  Lepidoptera      Order      larva
#> 9  Lepidoptera      Order      larva
#> 10 Lepidoptera      Order      larva
```

Final thoughts
--------------

1.  If you have any suggestions on the package please feel free to post an [issue](https://github.com/ahhurlbert/aviandietdb/issues).

2.  We will be submitting the Avian Diet Database as a formal publication with a DOI soon, but if you would like to cite it, for the moment use: Hurlbert, AH, AM Olsen, P Winner. 2020. Avian Diet Database. <https://github.com/ahhurlbert/aviandietdb>

3.  If you are aware of a quantitative study on avian diets that is NOT in the database (especially for North American species), please [post an issue in the Avian Diet Database development repo](https://github.com/hurlbertlab/dietdatabase/issues) with "study with diet data -- \[Author Year\]" as the subject line.
