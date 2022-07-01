#' @title Time Series Plot
#' @description The function returns times series of the evolution of different production surface areas' ecological footprints over the years for one or more selected countries.
#' @param countries_list List of countries chosen by the user.
#' @param record_type Record chosen by the user.
#' @param indicator Indicator selected by the user (crop land, grazing land, forest land, fishing ground, built-up land, carbon and total).
#' @return A Time Series of the evolution of ecological footprint of chosen countries.
#' @importFrom magrittr "%>%"
#' @import fpp3
#' @export
#' @examples
#' country_list <- list("Spain", "Italy","France", "Germany","Switzerland")
#' G6_timeseries(country_list, "EFProdTotGHA", "fishing_ground")

G6_timeseries <- function(countries_list, record_type, indicator){

  #read data
  data <- readr::read_csv(system.file("extdata", "NFA_2019_public_data.csv", package = "G6"))


  # select variables and filter for country and record
  data_country_ts <- data %>%
                     dplyr::select(year, country, record, {{indicator}}) %>%
                     dplyr::filter(country %in% countries_list & record == record_type)

  data_country_ts <- data_country_ts %>%
                     tsibble::tsibble(index = year, key = country) %>%
                     dplyr::mutate(indicator_name = as.double(data_country_ts[[indicator]]))




    standard_plot <- data_country_ts %>%
                     feasts::autoplot(indicator_name) +
                     ggplot2::ggtitle(paste("Time series by country and year for :",indicator)) +
                     ggplot2::xlab("year") +
                     ggplot2::ylab(paste0("for record: ", data_country_ts$record[1]))

    return(standard_plot)



}



