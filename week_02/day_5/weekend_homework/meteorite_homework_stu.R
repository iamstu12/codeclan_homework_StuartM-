
# Meteorite Homework ------------------------------------------------------


# Load Libraries ----------------------------------------------------------

library(tidyverse)
library(janitor)
library(stringr)

# 1.1 The .R file ---------------------------------------------------------

# Question 1 - Read the data into R ----

meteorite_landings <- read_csv("meteorite_landings.csv")

# Question 2 - Change the names of the variables to follow our naming standards. ----

meteorite_clean_names <- clean_names(meteorite_landings)

# Question 3 - Split in column GeoLocation into latitude and longitude, ----
# the new latitude and longitude columns should be numeric. 

meteorite_lat_long <- meteorite_clean_names %>%
 separate(geo_location, c("latitude", "longitude"),
         sep = ",") %>%
  mutate(latitude = str_remove(
    latitude, pattern = "\\("
  )) %>%
  mutate(longitude = str_remove(
    longitude, pattern = "\\)"
  )) %>% 
  mutate(latitude = as.double(latitude)) %>%
  mutate(longitude = as.double(longitude))

# Question 4 - Replace any missing values in latitude and longitude with zeros. ----

meteorite_missing_values <- meteorite_lat_long %>%
  mutate(latitude = coalesce(latitude, na.rm = 0)) %>%
  mutate(longitude = coalesce(longitude, na.rm = 0)) 

# Question 5 - Remove meteorites less than 1000g in weight from the data. ----

meteorite_more_than_1000g <- meteorite_missing_values %>%
  filter(mass_g >= 1000) 

# Question 6 - Order the data by the year of discovery. ----

meteorite_arranged_by_year <- meteorite_more_than_1000g %>%
  arrange(year) 
  





  







