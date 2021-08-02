#' Database summary function
#'
#' This function creates a summary of the contents of the Avian Diet Database
#' @param No parameters for this function
#' @keywords summary
#' @export
#' @examples
#' dbSummary()

dbSummary = function() {

  require(dplyr)
  options(dplyr.summarise.inform = FALSE)

  orders = unique(NA_specieslist[, c('order', 'family')]) %>%
    rename(Order = order, Family = family)
  species = unique(dietdb[, c('Common_Name', 'Family')])
  allspecies = NA_specieslist[, c('common_name', 'family')]
  numSpecies = nrow(species)
  numStudies = length(unique(dietdb$Source))
  numRecords = nrow(dietdb)
  recordsPerSpecies = count(dietdb, Common_Name, Family)
  spCountByFamily = data.frame(table(species$Family))
  noDataSpecies = subset(allspecies, !common_name %in% species$Common_Name)
  noDataSpCountByFamily = data.frame(table(noDataSpecies$family))
  spCountByFamily2 = merge(spCountByFamily, noDataSpCountByFamily, by = "Var1", all = T)
  names(spCountByFamily2) = c('Family', 'SpeciesWithData', 'WithoutData')
  spCountByFamily2$Family = as.character(spCountByFamily2$Family)
  spCountByFamily2$WithoutData[is.na(spCountByFamily2$WithoutData)] = 0
  spCountByFamily2 = spCountByFamily2[spCountByFamily2$Family != "", ]
  spCountByFamily2$SpeciesWithData[is.na(spCountByFamily2$SpeciesWithData)] = 0
  spCountByFamily3 = spCountByFamily2 %>%
    inner_join(orders, by = 'Family') %>%
    mutate(TotalSpeciesABA = SpeciesWithData + WithoutData,
           PercentComplete = round(100*SpeciesWithData/(SpeciesWithData + WithoutData))) %>%
    select(Order, Family, SpeciesWithData, TotalSpeciesABA, PercentComplete) %>%
    arrange(Order) %>%
    as_tibble()
  warning("This is a summary of the most recent database version released on Zenodo (https://doi.org/10.5281/zenodo.4960688).\nA development version which may include more recent entries, but which may not yet be fully vetted, is available at 'https://github.com/hurlbertlab/dietdatabase/blob/master/AvianDietDatabase.txt'.")
  return(list(numRecords=numRecords,
              numSpecies=numSpecies,
              numStudies=numStudies,
              recordsPerSpecies=recordsPerSpecies,
              speciesPerFamily = spCountByFamily3))
}
