#' Species diet summary function
#'
#' This function provides a summary of when, where, and what type of diet data are available for a given species, as well as an overall average importance of diet items
#' @param commonName common name of bird species to summarize; case-insensitive
#' @param by taxonomic level of prey to summarize diet by; possibile values include 'Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus', or 'Species'
#' @param db used to specify an alternative Diet Database object, mainly for testing; the default results in the main 'dietdb' data object being used.
#' @keywords summary
#' @export
#' @examples
#' speciesSummary("Bald eagle", by = "Class")

speciesSummary = function(commonName,
                          by = 'Order',
                          db = NULL) {

  require(dplyr)
  require(tidyr)

  # Load dietdb unless otherwise specified

  if (!is.null(db)) {
    dietdb = db
  } else {
    data(dietdb)
  }

  if (!tolower(commonName) %in% tolower(dietdb$Common_Name)) {
    warning("No species with that name in the Diet Database.")
    return(NULL)
  }

  if (by == 'Species') { by = 'Scientific_Name' }

  if (!by %in% c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder',
                 'Family', 'Genus', 'Scientific_Name')) {
    warning("Please specify one of the following taxonomic levels to aggregate prey data:\n   Kingdom, Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }

  dietsp = subset(dietdb, tolower(Common_Name) == tolower(commonName))
  Studies = as.character(unique(dietsp$Source))
  numRecords = nrow(dietsp)
  recordsPerYearRegion = data.frame(count(dietsp, Observation_Year_End, Location_Region)) %>%
    rename(Year = Observation_Year_End) %>%
    spread(Year, value = n)
  recordsPerType = data.frame(count(dietsp, Diet_Type))
  dietsp$Observation_Season[is.na(dietsp$Observation_Season)] = 'unspecified'
  dietsp$Observation_Season = tolower(dietsp$Observation_Season)
  recordsPerSeason = data.frame(count(dietsp, Observation_Season))


  # Report the number of records for which prey are identified to the different
  # taxonomic levels, which will be important for interpreting summary occurrence data
  king_n = nrow(dietsp[!is.na(dietsp$Prey_Kingdom) & dietsp$Prey_Kingdom != "" &
                         !(!is.na(dietsp$Prey_Phylum) & dietsp$Prey_Phylum != "") &
                         !(!is.na(dietsp$Prey_Class) & dietsp$Prey_Class != "") &
                         !(!is.na(dietsp$Prey_Order) & dietsp$Prey_Order != "") &
                         !(!is.na(dietsp$Prey_Suborder) & dietsp$Prey_Suborder != "") &
                         !(!is.na(dietsp$Prey_Family) & dietsp$Prey_Family != "") &
                         !(!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "") &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  phyl_n = nrow(dietsp[!is.na(dietsp$Prey_Phylum) & dietsp$Prey_Phylum != "" &
                         !(!is.na(dietsp$Prey_Class) & dietsp$Prey_Class != "") &
                         !(!is.na(dietsp$Prey_Order) & dietsp$Prey_Order != "") &
                         !(!is.na(dietsp$Prey_Suborder) & dietsp$Prey_Suborder != "") &
                         !(!is.na(dietsp$Prey_Family) & dietsp$Prey_Family != "") &
                         !(!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "") &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  clas_n = nrow(dietsp[!is.na(dietsp$Prey_Class) & dietsp$Prey_Class != "" &
                         !(!is.na(dietsp$Prey_Order) & dietsp$Prey_Order != "") &
                         !(!is.na(dietsp$Prey_Suborder) & dietsp$Prey_Suborder != "") &
                         !(!is.na(dietsp$Prey_Family) & dietsp$Prey_Family != "") &
                         !(!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "") &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  orde_n = nrow(dietsp[!is.na(dietsp$Prey_Order) & dietsp$Prey_Order != "" &
                         !(!is.na(dietsp$Prey_Suborder) & dietsp$Prey_Suborder != "") &
                         !(!is.na(dietsp$Prey_Family) & dietsp$Prey_Family != "") &
                         !(!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "") &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  subo_n = nrow(dietsp[!is.na(dietsp$Prey_Suborder) & dietsp$Prey_Suborder != "" &
                         !(!is.na(dietsp$Prey_Family) & dietsp$Prey_Family != "") &
                         !(!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "") &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  fami_n = nrow(dietsp[!is.na(dietsp$Prey_Family) & dietsp$Prey_Family != "" &
                         !(!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "") &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  genu_n = nrow(dietsp[!is.na(dietsp$Prey_Genus) & dietsp$Prey_Genus != "" &
                         !(!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != ""), ])
  spec_n = nrow(dietsp[!is.na(dietsp$Prey_Scientific_Name) & dietsp$Prey_Scientific_Name != "", ])

  recordsPerPreyIDLevel = data.frame(level = c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder', 'Family', 'Genus', 'Species'),
                                     n = c(king_n, phyl_n, clas_n, orde_n, subo_n, fami_n, genu_n, spec_n))




  taxonLevel = paste('Prey_', by, sep = '')

  # If prey not identified down to taxon level specified, replace "" with
  # "Unidentified XXX" where XXX is the lowest level specified (e.g. Unidentified Animalia)
  dietprey = dietsp[, c('Prey_Kingdom', 'Prey_Phylum', 'Prey_Class',
                        'Prey_Order', 'Prey_Suborder', 'Prey_Family',
                        'Prey_Genus', 'Prey_Scientific_Name')]
  level = which(names(dietprey) == taxonLevel)
  dietsp[, taxonLevel] = apply(dietprey, 1, function(x)
    if(x[level] == "" | is.na(x[level])) { paste("Unid.", x[max(which(x != "")[which(x != "") < level], na.rm = T)])}
    else { x[level] })


  # Prey_Stage should only matter for distinguishing things at the Order level and
  # below (e.g. distinguishing between Lepidoptera larvae and adults).
  if (by %in% c('Order', 'Family', 'Genus', 'Scientific_Name')) {
    stage = dietsp$Prey_Stage
    stage[is.na(stage)] = ""
    stage[stage == 'adult'] = ""
    dietsp$Taxon = paste(dietsp[, taxonLevel], stage) %>% trimws("both")
  } else {
    dietsp$Taxon = dietsp[, taxonLevel]
  }

  analysesPerDietType = dietsp %>%
    select(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season, Analysis_Number,
           Bird_Sample_Size, Habitat_type, Location_Region, Location_Specific, Item_Sample_Size, Diet_Type, Study_Type) %>%
    distinct() %>%
    count(Diet_Type)

  # Equal-weighted mean fraction of diet (all studies weighted equally despite
  #  variation in sample size)
  nonOccurrence = dietsp %>% filter(Diet_Type != "Occurrence")

  if (nrow(nonOccurrence) > 0) {
    preySummary_nonOccurrence = nonOccurrence %>%

      group_by(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season, Analysis_Number,
               Bird_Sample_Size, Habitat_type, Location_Region, Item_Sample_Size, Taxon, Diet_Type) %>%

      summarize(Sum_Diet = sum(Fraction_Diet, na.rm = T)) %>%
      group_by(Diet_Type, Taxon) %>%
      summarize(Sum_Diet2 = sum(Sum_Diet, na.rm = T)) %>%
      left_join(analysesPerDietType, by = c('Diet_Type' = 'Diet_Type')) %>%
      mutate(Frac_Diet = round(Sum_Diet2/n, 4)) %>%
      select(Diet_Type, Taxon, Frac_Diet) %>%
      arrange(Diet_Type, desc(Frac_Diet)) %>%
      data.frame()
  } else {
    preySummary_nonOccurrence = data.frame(Diet_Type = NULL, Frac_Diet = NULL)
  }

  # Fraction Occurrence values don't sum to 1, so all we can do is say that at
  # a given taxonomic level, at least X% of samples included that prey type
  # based on the maximum % occurrence of prey within that taxonomic group.
  # We then average occurrence values across studies/analyses.
  Occurrence = dietsp %>% filter(Diet_Type == "Occurrence")

  if (nrow(Occurrence) > 0) {
    preySummary_Occurrence = Occurrence %>%

      group_by(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season, Analysis_Number,
               Bird_Sample_Size, Habitat_type, Location_Region, Item_Sample_Size, Taxon, Diet_Type) %>%

      summarize(Max_Diet = max(Fraction_Diet, na.rm = T)) %>%
      group_by(Diet_Type, Taxon) %>%
      summarize(Sum_Diet2 = sum(Max_Diet, na.rm = T)) %>%
      left_join(analysesPerDietType, by = c('Diet_Type' = 'Diet_Type')) %>%
      mutate(Frac_Diet = round(Sum_Diet2/n, 4)) %>%
      select(Diet_Type, Taxon, Frac_Diet) %>%
      arrange(Diet_Type, desc(Frac_Diet)) %>%
      data.frame()
  } else {
    preySummary_Occurrence = data.frame(Diet_Type = NULL, Frac_Diet = NULL)
  }


  preySummary = rbind(preySummary_nonOccurrence, preySummary_Occurrence) %>%
    spread(Diet_Type, value = Frac_Diet)

  # Get Frac_Diet output columns in standardized order
  allCols = data.frame(col = c('Items', 'Wt_or_Vol', 'Unspecified', 'Occurrence'), order = 1:4)
  allCols$col = as.character(allCols$col)

  cols = data.frame(col = names(preySummary)[2:ncol(preySummary)])
  cols$col = as.character(cols$col)

  colOrdered = cols %>%
    left_join(allCols, by = 'col') %>%
    arrange(order) %>%
    select(col)

  preySummary2 = preySummary[, c('Taxon', colOrdered[,1])]
  preySummary2 = preySummary2[order(preySummary2[[2]], decreasing = TRUE), ]

  return(list(Studies = Studies,
              numRecords = numRecords,
              recordsPerSeason = recordsPerSeason,
              recordsPerYearRegion = recordsPerYearRegion,
              recordsPerPreyIDLevel = recordsPerPreyIDLevel,
              recordsPerType = recordsPerType,
              analysesPerDietType = data.frame(analysesPerDietType),
              preySummary = data.frame(preySummary2)))
}



