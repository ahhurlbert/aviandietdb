#' Flexible diet summary function
#'
#' This function provides a summary of quantitative diet data for a given bird species, taxonomic level of prey resolution, data type, season, region, and year range
#' @param commonName common name of bird species to summarize; case-insensitive.
#' @param by taxonomic level of prey to summarize diet by; possibile values include 'Kingdom', 'Phylum', 'Class', 'Order', 'Family', 'Genus', or 'Species'; defaults to 'Order'.
#' @param dietType the type of quantitative diet data; possible values include percent by 'Items', 'Wt_or_Vol' (weight or volume), or percent 'Occurrence'; defaults to 'Items'.
#' @param season the season for which a diet summary should be conducted; possible values include 'spring', 'summer', 'fall', 'winter', or 'any'; defaults to 'any'.
#' @param region the region for which a diet summary should be conducted; typically these are US or Mexican state or Canadian province names.
#' @param yearRange a vector specifying the minimum and maximum years over which a diet summary should be conducted; by default all years will be included.
#' @keywords diet summary
#' @export
#' @examples
#' dietSummary("Bald Eagle")
#' dietSummary("Bald Eagle", by = "Class", season = "winter", dietType = "Items", yearRange = c(1985, 2000))


dietSummary = function(commonName,
                       by = 'Order',
                       dietType = 'Items',
                       season = NULL,
                       region = NULL,
                       yearRange = c(1700, 2100)) {

  require(dplyr)

  # Checking for valid arguments
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

  if (!dietType %in% c('Items', 'Wt_or_Vol', 'Unspecified', 'Occurrence')) {
    warning("dietType argument must be one of the following: 'Items', 'Wt_or_Vol', 'Unspecified', or 'Occurrence'.")
    return(NULL)
  }


  dietsub = filter(dietdb, tolower(Common_Name) == tolower(commonName),
                   Observation_Year_End >= min(yearRange),
                   Observation_Year_End <= max(yearRange))

  if (is.null(dietType)) {
    dietType = c('Items', 'Wt_or_Vol', 'Unspecified', 'Occurrence')
  }
  if (is.null(season)) {
    season = unique(dietsub$Observation_Season)
  } else {
    season = tolower(season)
    if (sum(sapply(season, function(x) x %in% c('spring', 'summer', 'fall', 'winter', 'any'))) != length(season)) {
      warning("season argument must be one or more of the following: 'spring', 'summer', 'fall', 'winter', or 'any'.")
      return(NULL)
    }
    if ('any' %in% season) {
      season = unique(dietsub$Observation_Season)
    }
  }
  if (is.null(region)) {
    region = unique(dietsub$Location_Region)
  }

  dietsp = filter(dietsub, Diet_Type %in% dietType,
                  tolower(Observation_Season) %in% season,
                  Location_Region %in% region)


  if (nrow(dietsp) == 0) {
    warning("No records for the specified combination of diet type, season, region, and years.")
    return(NULL)
  }


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

  # Equal-weighted mean fraction of diet (all studies weighted equally despite
  #  variation in sample size)

  numAnalyses = dietsp %>%
    select(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season,
           Bird_Sample_Size, Habitat_type, Location_Region, Location_Specific, Item_Sample_Size, Diet_Type, Study_Type) %>%
    distinct() %>%
    nrow()

  if (dietType == 'Occurrence') {
    # Fraction Occurrence values don't sum to 1, so all we can do is say that at
    # a given taxonomic level, at least X% of samples included that prey type
    # based on the maximum % occurrence of prey within that taxonomic group.
    # We then average occurrence values across studies/analyses.
    preySummary = dietsp %>% filter(Diet_Type == "Occurrence") %>%

      group_by(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season,
               Bird_Sample_Size, Habitat_type, Location_Region, Item_Sample_Size, Taxon) %>%

      summarize(Max_Diet = max(Fraction_Diet, na.rm = T)) %>%
      group_by(Taxon) %>%
      summarize(Sum_Diet2 = sum(Max_Diet, na.rm = T)) %>%
      mutate(Frac_Diet = round(Sum_Diet2/numAnalyses, 4)) %>%
      select(Taxon, Frac_Diet) %>%
      arrange(desc(Frac_Diet)) %>%
      data.frame()

  } else {
    preySummary = dietsp %>% filter(Diet_Type == dietType) %>%

      group_by(Source, Observation_Year_Begin, Observation_Month_Begin, Observation_Season,
               Bird_Sample_Size, Habitat_type, Location_Region, Item_Sample_Size, Taxon) %>%

      summarize(Sum_Diet = sum(Fraction_Diet, na.rm = T)) %>%
      group_by(Taxon) %>%
      summarize(Sum_Diet2 = sum(Sum_Diet, na.rm = T)) %>%
      mutate(Frac_Diet = round(Sum_Diet2/numAnalyses, 4)) %>%
      select(Taxon, Frac_Diet) %>%
      arrange(desc(Frac_Diet)) %>%
      data.frame()
  }

  return(preySummary)
}
