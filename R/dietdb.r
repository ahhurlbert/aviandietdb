#' Avian Diet Database
#'
#' Quantitative data on the diet of (mostly North American at the moment) bird species
#' including contextual information about how, where, and when those data were collected.
#'
#' This data object was most recently updated on 2 June 2021.
#'
#' The database is a work in progress and the most up to date version can be found on Github: <https://github.com/hurlbertlab/dietdatabase>
#'
#' @docType data
#'
#' @usage data(dietdb)
#'
#' @format A dataframe with 67894 rows and 42 variables
#' \describe{
#'   \item{Common_Name}{The common name of the species whose diet is being characterized, following the taxonomic authority in Taxonomy}
#'   \item{Scientific_Name}{The genus and species of the species whose diet is being characterized, following the most recent Clements / eBird checklist}
#'   \item{Family}{Family of the species whose diet is being characterized}
#'   \item{Taxonomy}{The taxonomic authority for the scientific name.}
#'   \item{Longitude_dd}{The longitude of the study in decimal degrees, if provided}
#'   \item{Latitude_dd}{The latitude of the study in decimal degrees, if provided}
#'   \item{Altitude_min_m}{Minimum altitude of the study in meters, if provided}
#'   \item{Altitude_mean_m}{Mean altitude of the study in meters, if provided}
#'   \item{Altitude_max_m}{Maximum altitude of the study in meters, if provided}
#'   \item{Location_Region}{Location of the study based on national or subnational place name (e.g., Florida, or Jamaica)}
#'   \item{Location_Specific}{Location of the study using the most specific placename provided in the study (e.g., Hubbard Brook Experimental Forest, Huachuca Mountains)}
#'   \item{Habitat_type}{Habitat in which the study was conducted}
#'   \item{Observation_Month_Begin}{The month number (1-12) in which diet data were first collected}
#'   \item{Observation_Year_Begin}{The year in which diet data were first collected in the study}
#'   \item{Observation_Month_End}{The month number (1-12) in which diet data were last collected}
#'   \item{Observation_Year_End}{The year in which diet data were last collected in the study}
#'   \item{Observation_Season}{The season(s) in which diet data were collected}
#'   \item{Analysis_Number}{A numeric identifier distinguishing different diet analyses (e.g. each of which sum to 100 pct) within the same study that otherwise do not differ with respect to location, habitat, month, year, season, Study_Type, or Diet_Type.}
#'   \item{Prey_Kingdom}{Kingdom to which the prey item belongs}
#'   \item{Prey_Phylum}{Phylum to which the prey item belongs}
#'   \item{Prey_Class}{Class to which the prey item belongs}
#'   \item{Prey_Order}{Order to which prey item belongs}
#'   \item{Prey_Suborder}{Suborder to which prey item belongs (especially within Order Hemiptera)}
#'   \item{Prey_Family}{Family to which prey item belongs}
#'   \item{Prey_Genus}{Genus to which prey item belongs}
#'   \item{Prey_Scientific_Name}{The full scientific name to which the prey item belongs}
#'   \item{Inclusive_Prey_Taxon}{Does the percent diet data listed correspond to the importance of the listed prey taxon inclusively defined ("yes") or only for an unstated subset of the listed prey taxon ("no")}
#'   \item{Prey_Name_ITIS_ID}{The Integrated Taxonomic Information Service (ITIS) taxon ID associated with the prey item}
#'   \item{Prey_Name_Status}{Taxonomic status of the prey name; "verified" indicates the name matched a valid ITIS ID; "unverified" means the name did not match a valid ITIS ID and needs to be further investigated; "accepted" means the name did not match a valid ITIS ID, but it reflects an accepted taxonomic concept not in ITIS}
#'   \item{Prey_Stage}{The life stage of the identified prey item (e.g., 'adult', 'larva')}
#'   \item{Prey_Part}{The part of the prey species represented in the diet if only a part was consumed (e.g. 'flower', 'fruit')}
#'   \item{Prey_Common_Name}{Common name of the prey item, if provided}
#'   \item{Fraction_Diet}{Fraction of the bird's diet made up by this prey item, value between 0 and 1}
#'   \item{Diet_Type}{Method by which diet was quantified; fraction of the diet by number of 'Items', fraction of the diet by 'Wt_or_Vol', 'Occurrence', 'Unspecified'}
#'   \item{Item_Sample_Size}{Total number of prey items identified in the diet sample}
#'   \item{Bird_Sample_Size}{Total number of individuals of the focal bird species used to characterize diet}
#'   \item{Sites}{Number of study sites over which individuals were used to characterize diet}
#'   \item{Study_Type}{The way diet data were collected (e.g., 'emetic', 'stomach contents', 'DNA sequencing')}
#'   \item{Notes}{Any other useful information about the nature of the study}
#'   \item{Entered_By}{Initials of the person entering the data}
#'   \item{Source}{The complete citation of the study from which the diet information comes}
#'  }

#' @references
#'
#' @source Avian Diet Database, \url{https://github.com/hurlbertlab/dietdatabase}
#'
#' @examples
#' data(dietdb)
#' speciesSummary("Bald eagle", by = "Class"))
"dietdb"
