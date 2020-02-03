# Attach necessary packages
library(shiny)
library(tidyverse)
library(shinythemes)

# Create the user interface:
ui <- navbarPage("A navigation bar!",
                 theme = shinytheme("cyborg"),
                 tabPanel("FIRST",
                          h1("Some text in my first tab yay"),
                          p("Then some normal text..."),
                          plotOutput(outputId = "diamond_plot")
                          ),
                 tabPanel("SECOND",
                            sidebarLayout(
                            sidebarPanel("Some text!",
                                         checkboxGroupInput("diamondclarity", "Choose diamond clarity", choices = c(levels(diamonds$clarity))
                                                      )
                                         ),
                            mainPanel(plotOutput(outputId = "diamond_plot_2"))
                            )
                          ),
                 tabPanel("Wooooo!"
                          )
                 )

# Create the server:
server <- function(input, output) {

  diamond_clarity <- reactive({

    diamonds %>%
      filter(clarity %in% input$diamondclarity)

  })

  output$diamond_plot <- renderPlot({
    ggplot(data = diamonds, aes(x = carat, y = price)) +
    geom_point(aes(color = clarity))
  })

  output$diamond_plot_2 <- renderPlot({

    ggplot(data = diamond_clarity(), aes(x = clarity, y = price)) +
      geom_violin(aes(fill = clarity))

  })

}

# Combine them into an app:
shinyApp(ui = ui, server = server)
