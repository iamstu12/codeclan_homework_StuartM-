

# Load in Libraries ----

library(tidyverse)
library(CodeClanData)
library(shiny)
library(dplyr)
library(ggplot2)
library(DT)
library(shinythemes)

# Load in Data ----

game_sales <- game_sales


# Clean Data ----

# Rename columns and change to 'title' case

game_sales <- game_sales %>% 
  
  rename('year of release' = year_of_release) %>%
  rename('critic score' = critic_score) %>%
  rename('user score' = user_score) %>%
  rename(console = platform)

colnames(game_sales) <- str_to_title(colnames(game_sales))

# Create a new column called 'platform', based on the type of console

game_sales <- game_sales %>% 
  
  mutate(Platform = case_when(
    Console == "PS4" ~ "Playstation",
    Console == "PS3" ~ "Playstation",
    Console == "PS2" ~ "Playstation",
    Console == "PS" ~ "Playstation",
    Console == "PSP" ~ "Playstation",
    Console == "PSV" ~ "Playstation",
    Console == "X360" ~ "Xbox",
    Console == "XOne" ~ "Xbox",
    Console == "XB" ~ "Xbox",
    Console == "PC" ~ "PC",
    TRUE ~ "Nintendo"
  ))

# Rename some of the consoles

game_sales <- game_sales %>%
  
  arrange(desc("Critic Score")) %>%
  mutate(Console = recode(Console,
                           "X360" = "Xbox 360",
                           "PS" = "PS One",
                           "XOne" = "Xbox One",
                           "XB" = "Xbox",
                           "GC" = "GameCube",
                           "GBA" = "Gameboy Advance",
                           "WiiU" = "Wii U")) 


# Game App ----

ui <- fluidPage(
  
  theme = shinytheme("united"),
  titlePanel("Top Rated Games"),
  
  
  radioButtons("platform",
               "Select Platform",
               choices = unique(game_sales$Platform)
               ),
  
  
  selectInput("console",
               "Choose your Console",
               choices = unique(game_sales$Console)
              ),
  
  actionButton("update", "Here We GO!"),
  

  DT::dataTableOutput("table_output")
  
  
)  # < ---- closes fluid page



server <- function(input, output) {
  
  game_data <- eventReactive(input$update, {
    
    game_sales %>%
      select("Name", "Genre", "Year Of Release", "Critic Score", "User Score", "Platform", "Console") %>%
      filter(Platform == input$platform) %>%
      filter(Console == input$console)
  })
    
    output$table_output <- DT::renderDataTable({
      game_data()
      
    })
}


shinyApp(ui = ui, server = server)













