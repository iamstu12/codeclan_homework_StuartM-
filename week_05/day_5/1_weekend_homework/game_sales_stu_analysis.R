

library(tidyverse)
library(CodeClanData)
library(dplyr)

game_sales <- game_sales

nintendo_games <- game_sales %>% 
  filter(publisher == "Nintendo") %>%
  arrange(desc(critic_score))





