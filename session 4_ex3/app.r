
# load packages -----------------------------------------------------------

library(shiny)
library(shinydashboard)
library(tidyverse)

# user interface ---------------------------------------------------------

ui <- dashboardPage(
  dashboardHeader(title = "Star Wars"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Homeworld", tabName = "Homes", icon = icon("jedi")),
      menuItem("Species", tabName = "species", icon = icon('pastafarianism'))# use ?icon in console to get link to the diff icon options in font awesome free
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(
        tabName = "Homes", # reference the tab (which was specified above) under which you want this input to be located
        fluidRow (
          box(title = "HomeWorld Graph", # give name you want this info to go under then 
              selectInput('sw_species',
                          label = "Choose Species:",
                          choices = c(unique(starwars$species)))),
          box(plotOutput(outputId = "sw_plot")))


      )
    )
  )
)


# server --------------------------------------------------------------

server <- function(input, output) {
  
  species_df <- reactive ({
    starwars %>% filter(species == input$sw_species)
  })
  output$sw_plot <- renderPlot({
    ggplot(species_df(), aes(x = homeworld)) +
      geom_bar() 
  })
}


# shiny app -----------------------------------------------------------

shinyApp(ui = ui, server = server)
