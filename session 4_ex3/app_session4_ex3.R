library(shiny)
library(shinydashboard)
library(tidyverse)

ui <- dashboardPage(
  dashboardHeader(title = "Star Wars!"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Homeworld", tabName = "homes", icon = icon("jedi")),
      menuItem("Species", tabName = "species", icon = icon("pastafarianism"))
    )
  ),
  dashboardBody(
    tabItems(
    tabItem(
      tabName = "homes",
      fluidRow(
        box(title = "Homeworld Graph",
            selectInput("sw_species",
                        "Choose species to explore homeworlds:",
                        choices = c(unique(starwars$species)))),
        box(plotOutput(outputId = "sw_plot"))
      )
    ),
    tabItem(
      tabName = "species",
      fluidRow(
        box(title = "HELLO!")
      )
    )

)
)
)

server <- function(input, output) {

  species_df <- reactive({
    starwars %>%
      filter(species == input$sw_species)
  })

  output$sw_plot <- renderPlot({
    ggplot(species_df(), aes(x = homeworld)) +
      geom_bar() +
      coord_flip()
  })

}

shinyApp(ui = ui, server = server)
