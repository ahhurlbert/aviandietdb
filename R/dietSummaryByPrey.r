#' Summarize the importance of a single prey item across bird species
#'
#' This function provides a summary of quantitative diet data for a given prey type
#' @param preyName scientific name of prey item to summarize, which may be at any taxonomic level denoted by preyLevel
#' @param preyLevel taxonomic level of prey; possibile values include 'Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus', or 'Species'
#' @param preyStage defaults to 'any'; one can alternatively specify 'adult', 'larva', or 'pupa' to narrow summary results to those that match these specific life stages
#' @param dietType the way in which diet data were quantified; possible values include percent by 'Items', 'Wt_or_Vol' (weight or volume), or 'Occurrence'; defaults to NULL, in which case summaries will be provided for each Diet_Type for which data exist.
#' @param season the season for which a diet summary should be conducted; possible values include 'spring', 'summer', 'fall', 'winter', or 'any'; defaults to 'any'.
#' @param region the region for which a diet summary should be conducted; typically these are US or Mexican state or Canadian province names; by default all regions will be included.
#' @param yearRange a vector specifying the minimum and maximum years over which a diet summary should be conducted; by default all years will be included.
#' @param speciesMean logical value indicating whether to average across all regions, years and seasons to yield a single diet value per bird species-Diet_Type combination; default is FALSE in which case all diet analyses in which the prey taxon appears will be listed separately.
#' @param db used to specify an alternative Diet Database object, mainly for testing; the default results in the main 'dietdb' data object being used.
#' @keywords diet summary prey
#' @export
#' @examples
#' dietSummaryByPrey("Lepidoptera", preyLevel = "Order", larvaOnly = TRUE, dietType = "Items", season = "spring")



dietSummaryByPrey = function(preyName,
                             preyLevel,
                             preyStage = 'any',
                             dietType = NULL,
                             season = NULL,
                             region = NULL,
                             yearRange = c(1700, 2100),
                             speciesMean = FALSE,
                             db = NULL) {

  require(dplyr)
  options(dplyr.summarise.inform = FALSE)

  # Load dietdb unless otherwise specified

  if (!is.null(db)) {
    dietdb = db
  } else {
    data(dietdb)
  }

  # Checking for valid arguments

  if (preyLevel == 'Species') { preyLevel = 'Scientific_Name' }

  if (!preyLevel %in% c('Kingdom', 'Phylum', 'Class', 'Order', 'Suborder',
                        'Family', 'Genus', 'Scientific_Name')) {
    warning("Please specify one of the following taxonomic levels for describing prey:\n   Kingdom, Phylum, Class, Order, Suborder, Family, Genus, or Scientific_Name")
    return(NULL)
  }

  taxonLevel = paste('Prey_', preyLevel, sep = '')

  if (!tolower(preyName) %in% tolower(dietdb[, taxonLevel])) {
    warning(paste("No prey taxa named", preyName, "at the level of", preyLevel, "were found in the Diet Database."))
    return(NULL)
  }

  if (is.null(dietType)) {
    dietType = c('Items', 'Wt_or_Vol', 'Unspecified', 'Occurrence')
  } else {
    if (!dietType %in% c('Items', 'Wt_or_Vol', 'Unspecified', 'Occurrence')) {
      warning("dietType argument must be one or more of the following: 'Items', 'Wt_or_Vol', 'Unspecified', or 'Occurrence'.")
      return(NULL)
    }
  }

  if (is.null(season)) {
    season = unique(dietdb$Observation_Season)
  } else {
    season = tolower(season)
    if (sum(sapply(season, function(x) x %in% c('spring', 'summer', 'fall', 'winter', 'any'))) != length(season)) {
      warning("season argument must be one or more of the following: 'spring', 'summer', 'fall', 'winter', or 'any'.")
      return(NULL)
    }
    if ('any' %in% season) {
      season = unique(dietdb$Observation_Season)
    }
  }

  if (is.null(region)) {
    region = unique(dietdb$Location_Region)
  }


  if (!preyStage %in% c('any', 'larva', 'pupa', 'adult')) {
    warning("Please specify one of the following prey life stages:\n   larva, pupa, adult, any")
    return(NULL)
  }


  # Note this is inclusive, and will include records which list 'larva' in addition to other stages
  # (e.g. ('pupa; larva' or 'adult; larva')). Absence of Prey_Stage field is assumed to indicate adult.
  if (preyStage == 'any') {
    diet2 = dietdb
  } else if (preyStage == 'adult') {
    diet2 = filter(dietdb, grepl('adult', Prey_Stage) | Prey_Stage == "")
  } else {
    diet2 = filter(dietdb, grepl(preyStage, Prey_Stage))
  }



  # Filter summary to prey, years, season, and region specified
  dietsub = diet2 %>%
    filter(get(taxonLevel) == preyName,
           Observation_Year_End >= min(yearRange),
           Observation_Year_End <= max(yearRange),
           tolower(Observation_Season) %in% season,
           Location_Region %in% region,
           Diet_Type %in% dietType)

  if (nrow(dietsub) == 0) {
    warning("No records for the specified combination of prey, prey stage, diet type, season, region, and years.")
    return(NULL)
  }


  # Separate summaries are required for Occurrence and non-Occurrence data; they will be binded together later

  nullDF = data.frame(Common_Name = NULL,
                      Family = NULL,
                      Location_Region = NULL,
                      Observation_Year_End = NULL,
                      Observation_Season = NULL,
                      Diet_Type = NULL,
                      Prey_Name = NULL,
                      Prey_Level = NULL,
                      Prey_Stage = NULL,
                      Fraction_Diet = NULL,
                      SourceAbbrev = NULL)

  # Equal-weighted mean fraction of diet (all studies weighted equally despite
  #  variation in sample size) for Items, Wt_or_Vol, and Unspecified Diet_Type
  if (length(dietType[dietType != 'Occurrence']) > 0 & nrow(dietsub[dietsub$Diet_Type != "Occurrence",]) > 0) {

    preySummary_nonOccurrence = dietsub %>%

      filter(Diet_Type != "Occurrence") %>%

      group_by(Source, Common_Name, Subspecies, Family, Observation_Year_Begin, Observation_Month_Begin,
               Observation_Year_End, Observation_Month_End, Observation_Season, Analysis_Number,
               Bird_Sample_Size, Habitat_type, Location_Region, Location_Specific, Item_Sample_Size, Diet_Type, Study_Type, Sites) %>%

      summarize(Fraction_Diet = sum(Fraction_Diet, na.rm = T)) %>%

      ungroup() %>%

      mutate(Prey_Name = preyName, Prey_Level = preyLevel, Prey_Stage = preyStage, SourceAbbrev = substr(Source, 1, 20)) %>%

      select(Common_Name, Family, Location_Region, Observation_Year_End, Observation_Season, Diet_Type,
             Prey_Name, Prey_Level, Prey_Stage, Fraction_Diet, SourceAbbrev) %>%

      arrange(Diet_Type, desc(Fraction_Diet)) %>%

      data.frame()

  } else {

    preySummary_nonOccurrence = nullDF

  }

  # Fraction Occurrence values don't sum to 1, so all we can do is say that at
  # a given taxonomic level, at least X% of samples included that prey type
  # based on the maximum % occurrence of prey within that taxonomic group.

  if ("Occurrence" %in% dietType & nrow(dietsub[dietsub$Diet_Type == "Occurrence", ]) > 0) {

    preySummary_Occurrence = dietsub %>%

      filter(Diet_Type == "Occurrence") %>%

      group_by(Source, Common_Name, Subspecies, Family, Observation_Year_Begin, Observation_Month_Begin,
               Observation_Year_End, Observation_Month_End, Observation_Season, Analysis_Number,
               Bird_Sample_Size, Habitat_type, Location_Region, Location_Specific, Item_Sample_Size, Diet_Type, Study_Type, Sites) %>%

      summarize(Fraction_Diet = max(Fraction_Diet, na.rm = T)) %>%

      ungroup() %>%

      mutate(Prey_Name = preyName, Prey_Level = preyLevel, Prey_Stage = preyStage, SourceAbbrev = substr(Source, 1, 20)) %>%

      select(Common_Name, Family, Location_Region, Observation_Year_End, Observation_Season, Diet_Type,
             Prey_Name, Prey_Level, Prey_Stage, Fraction_Diet, SourceAbbrev) %>%

      arrange(Diet_Type, desc(Fraction_Diet)) %>%

      data.frame()

  } else {

    preySummary_Occurrence = nullDF

  }

  preySummary = rbind(preySummary_nonOccurrence, preySummary_Occurrence)


  if (speciesMean) {

    numAnalysesBySpecies = dietdb %>%
      filter(Common_Name %in% dietsub$Common_Name[dietsub$Diet_Type != "Occurrence"]) %>%

      distinct(Source, Common_Name, Subspecies, Family, Observation_Year_Begin, Observation_Month_Begin,
               Observation_Year_End, Observation_Month_End, Observation_Season, Analysis_Number,
               Bird_Sample_Size, Habitat_type, Location_Region, Location_Specific, Item_Sample_Size, Diet_Type, Study_Type, Sites) %>%

      group_by(Common_Name, Diet_Type) %>%

      summarize(numAnalyses = n())



    output = preySummary %>%
      group_by(Common_Name, Family, Diet_Type, Prey_Name, Prey_Level) %>%
      summarize(Sum_Fraction_Diet = sum(Fraction_Diet, na.rm = TRUE)) %>%
      left_join(numAnalysesBySpecies, by = c('Common_Name', 'Diet_Type')) %>%
      mutate(Mean_Fraction_Diet = Sum_Fraction_Diet/numAnalyses) %>%
      arrange(Diet_Type, desc(Mean_Fraction_Diet)) %>%
      mutate(Prey_Stage = case_when(
        preyStage == 'any' ~ '',
        preyStage != 'any' ~ preyStage
        )) %>%
      select(Common_Name, Family, Diet_Type, Mean_Fraction_Diet, Prey_Name, Prey_Level, Prey_Stage) %>%
      rename(Fraction_Diet = Mean_Fraction_Diet) %>%
      data.frame()

  } else {
    output = preySummary
  }

  return(output)
}
