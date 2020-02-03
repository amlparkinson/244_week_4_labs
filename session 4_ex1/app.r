
# Lab 4 session 4 example 1 

# load packages -----------------------------------------------------------

library(shiny)
library(tidyverse)
library(shinydashboard)

# add data ----------------------------------------------------------------

penguins <- read.csv("penguins.csv")

# create user interface (ui) ----------------------------------------------

ui <- fluidPage(
  titlePanel("Shiny App Title"),
  sidebarLayout(
    sidebarPanel("Enter text here: Widgets",
                 radioButtons(inputId = "species",  # radio buttons = all options visible with little bubble next to it to selct that option
                              label = "Choose Penguin Species:",
                              choices = c("Adelie", "Gentoo", "Awesome Chinstrap" = "Chinstrap")), # these choices = same as the options in the sp_short column. They HAVE TO match, ,otherwise will get issues, but to get around this can use the "" = "", within the same comma space. This changes what the user sees, but when filter the data can filter for chinstrap and wont have issues
                 selectInput(inputId = "pt_color",
                             label = "Select a Fun Color!",
                             choices = c("Rad Red" = "red", 
                                         "Pretty Purple" = "purple",
                                         "orange"))),  #select input = drop down menu
    mainPanel("Graph!", 
              plotOutput(outputId = "penguin_plot"),
              tableOutput(outputId = "penguin_table"))
  )
)

# create server -----------------------------------------------------------

server <- function(input, output) {
  
  penguin_select <- reactive({
    penguins %>% filter(sp_short == input$species) # this says, in this penguiins data set, filter to only include the observations from the species selected by the user (input) in the widget called species (--> input$name of widget)
  }) # have to tell R the output is reactive and the bracket format has to be: ({}) when creating reactive function (alsouse this bracket formaat for renderPlot, etc bc theyre reactive)
 
  output$penguin_plot <- renderPlot({
    ggplot(data = penguin_select(), aes(x = flipper_length_mm, y = body_mass_g)) + #when referencing a reactive data frame, have to include empty brackets at the end --> ()
     geom_point(color = input$pt_color) 
  })
  
  
  penguin_table <- reactive({
    penguins %>%
      filter(sp_short == input$species) %>%
      group_by(sex) %>%
      summarize(
        mean_flip = mean(flipper_length_mm),
        mean_mass = mean(body_mass_g)
      )
  })
  output$penguin_table <- renderTable({
    
    penguin_table()
    
  })
}

# combine ui and server into an app ---------------------------------------

shinyApp(ui = ui, server = server)
# must save r script as "app.r" before running the shinyApp code above. WHen do run it, a web page will show up 
