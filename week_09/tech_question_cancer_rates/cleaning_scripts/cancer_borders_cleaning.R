

# Cleaning Script ----


# Load in Libraries: ----

library(tidyverse)
library(janitor)

# Load in Data and Clean Column Names: ----

geography_codes_raw <- read_csv("raw_data/geography_codes_and_labels.csv") %>% 
  clean_names()

scotland_level_raw <- read_csv("raw_data/incidence_scotland_level.csv") %>% 
  clean_names()

regional_level_raw <- read_csv("raw_data/incidence_by_region.csv") %>% 
  clean_names()

health_board_level_raw <- read_csv("raw_data/incidence_by_health_board.csv") %>% 
  clean_names()


# Cleaning Scotland Level: ----

#1 Pivot Data

scotland_level_clean <- scotland_level_raw %>% 
  pivot_longer(
    cols = "incidences_age_under5" : "incidences_all_ages",
    names_to = "age_group",
    values_to = "number_of_incidences"
  )

#2 Select Relevant Columns

scotland_level_clean <- scotland_level_clean %>% 
  select(cancer_site, sex, year, age_group, number_of_incidences)

#3 Rename Column(s)

scotland_level_clean <- scotland_level_clean %>% 
  rename(cancer_type = cancer_site)

#4 Rename Variables

scotland_level_clean <- scotland_level_clean %>% 
  mutate(cancer_type = recode(cancer_type,
                              `All cancer types` = "All")) %>% 
  mutate(age_group = recode(age_group,
                            "incidences_age_under5" = "Under 5",
                            "incidences_age5to9" = "5 to 9",
                            "incidences_age10to14" = "10 to 14",
                            "incidences_age15to19" = "15 to 19",
                            "incidences_age20to24" = "20 to 24",
                            "incidences_age25to29" = "25 to 29",
                            "incidences_age30to34" = "30 to 34",
                            "incidences_age35to39" = "35 to 39",
                            "incidences_age40to44" = "40 to 44",
                            "incidences_age45to49" = "45 to 49",
                            "incidences_age50to54" = "50 to 54",
                            "incidences_age55to59" = "55 to 59",
                            "incidences_age60to64" = "60 to 64",
                            "incidences_age65to69" = "65 to 69",
                            "incidences_age70to74" = "70 to 74",
                            "incidences_age75to79" = "75 to 79",
                            "incidences_age80to84" = "80 to 84",
                            "incidences_age85to89" = "85 to 89",
                            "incidences_age90and_over" = "90 and Over",
                            "incidences_all_ages" = "All"))

#5 Write to Clean Data 

write_csv(scotland_level_clean, "clean_data/scotland_level_clean")

# Cleaning Health Board Level: ----

#1 Pivot Data

health_board_level_clean <- health_board_level_raw %>% 
  pivot_longer(
    cols = "incidences_all_ages",
    names_to = "age_group",
    values_to = "number_of_incidences"
  )

#2 Select Relevant Columns

health_board_level_clean <- health_board_level_clean %>% 
  select(hb, cancer_site, sex, year, age_group, number_of_incidences)

#3 Rename Column(s)

health_board_level_clean <- health_board_level_clean %>% 
  rename(cancer_type = cancer_site,
         health_board = hb)

#4 Rename Variables

health_board_level_clean <- health_board_level_clean %>% 
  mutate(cancer_type = recode(cancer_type,
                              "All cancer types" = "All")) %>% 
  mutate(age_group = recode(age_group,
                            "incidences_all_ages" = "All"))

#5 Join Geography Codes

#5.1 Rename Column in Geography Codes:

geography_codes_raw <- geography_codes_raw %>% 
  rename(health_board = hb,
         health_board_name = hb_name) 


health_board_level_clean <- health_board_level_clean %>% 
  inner_join(geography_codes_raw, by = "health_board")

#6 Select Relevant Columns

health_board_level_clean <- health_board_level_clean %>% 
  select(-health_board, -hb_date_enacted, -hb_date_archived, -country)

#7 Write to Clean Data 

write_csv(health_board_level_clean, "clean_data/health_board_level_clean")













