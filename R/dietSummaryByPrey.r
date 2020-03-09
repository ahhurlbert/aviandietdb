#' Summarize the importance of a single prey item across bird species
#'
#' This function provides a summary of quantitative diet data for a given prey type
#' @param preyName scientific name of prey item to summarize, which may be at any taxonomic level denoted by preyLevel
#' @param preyLevel taxonomic level of prey; possibile values include 'Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus', or 'Species'
#' @param preyStage defaults to 'any'; one can alternatively specify 'adult', 'larva', or 'pupa' to narrow summary results to those that match these specific life stages
#' @param dietType the way in which diet data were quantified; possible values include percent by 'Items', 'Wt_or_Vol' (weight or volume), or 'Occurrence'; defaults to 'Items'.
#' @param season the season for which a diet summary should be conducted; possible values include 'spring', 'summer', 'fall', 'winter', or 'any'; defaults to 'any'.
#' @param region the region for which a diet summary should be conducted; typically these are US or Mexican state or Canadian province names; by default all regions will be included.
#' @param yearRange a vector specifying the minimum and maximum years over which a diet summary should be conducted; by default all years will be included.
#' @param speciesMean logical value indicating whether to average across all regions, years and seasons to yield a single diet value per bird species-Diet_Type combination; default is FALSE in which case all diet analyses in which the prey taxon appears will be listed separately.
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
                             speciesMean = FALSE) {

  require(dplyr)

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
      season = unique(diet$Observation_Season)
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

  dietsub = diet2 %>%
    filter(get(taxonLevel) == preyName,
           Observation_Year_End >= min(yearRange),
           Observation_Year_End <= max(yearRange),
           Diet_Type %in% dietType,
           tolower(Observation_Season) %in% season,
           Location_Region %in% region) %>%
    arrange(Diet_Type, desc(Fraction_Diet)) %>%
    mutate(Prey_Name = preyName, Prey_Level = preyLevel) %>%
    select(Common_Name, Family, Location_Region, Observation_Year_End, Observation_Season,
           Diet_Type, Fraction_Diet, Prey_Name, Prey_Level, Prey_Stage)


  if (nrow(dietsub) == 0) {
    warning("No records for the specified combination of prey, prey stage, diet type, season, region, and years.")
    return(NULL)
  }

  if (speciesMean) {
    output = dietsub %>%
      group_by(Common_Name, Family, Diet_Type, Prey_Name, Prey_Level) %>%
      summarize(Mean_Fraction_Diet = mean(Fraction_Diet, na.rm = TRUE)) %>%
      arrange(Diet_Type, desc(Mean_Fraction_Diet)) %>%
      mutate(Prey_Stage = case_when(
        preyStage == 'any' ~ '',
        preyStage != 'any' ~ preyStage
      )) %>%
      select(Common_Name, Family, Diet_Type, Mean_Fraction_Diet, Prey_Name, Prey_Level, Prey_Stage) %>%
      rename(Fraction_Diet = Mean_Fraction_Diet) %>%
      data.frame()
  } else {
    output = dietsub %>%
      data.frame()
  }

  return(output)
}
