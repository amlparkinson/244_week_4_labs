# lab 4 session 4 example 2


# load packages -----------------------------------------------------------

library(shiny)
library(tidyverse)
library(shinythemes)

# User interface ----------------------------------------------------------

ui <- navbarPage("Navigation Bar!",
                 theme = shinytheme("cyborg"),
                 tabPanel("First Tab",
                          h1("Big Header"),  # like in r markdown where the number of #s corresponds to text size, in shiny we use h1, h2, h3, h4, h5, (etc?) to indicate text hize. h1= largest and the other h# get progressively smaller
                          p("Heres some regular text in paragraph..."),
                          plotOutput(outputId = 'diamond_plot')), # p stands for paragraph. Can add it decent amount of text. If have a lot of text, can import external text or r markdown files instead, but didnt go over that in class
                 tabPanel("Second Tab",
                          sidebarLayout(  # in sidebar layout, need to specify what is in the main panel and side panel
                            sidebarPanel("text here",
                                         checkboxGroupInput(inputId = "diamondclarity",
                                                            label = "Choose Some Options!",
                                                            choices = c(levels(diamonds$clarity)))),  # when there are several options for a value in a column, can use this method of inputing the options (works here bc this column is recognized by r as an ordered factor)
                            mainPanel("Main Panel text here",
                                      plotOutput(outputId = 'diamond_plot2'))
                          ))
                 )

# Server ------------------------------------------------------------------

server <- function(input, output) {
  
  output$diamond_plot <- renderPlot({
    ggplot(data = diamonds, aes(x = carat, y= price)) +  #dont need {} in renderplot bc not a reactive graph, dont need () after the data bc again, not reactive plot
      geom_point(aes(color = clarity))
  })
  
  diamond_clarity <- reactive({
    diamonds %>% 
      filter(clarity %in% input$diamondclarity)
  })
  output$diamond_plot2 <- renderPlot({
    
    ggplot(data = diamond_clarity(), aes(x = clarity, y = price)) +
      geom_violin(aes(fill = clarity))
    
  })
}

# run shiny app -----------------------------------------------------------

shinyApp(ui = ui, server = server)

