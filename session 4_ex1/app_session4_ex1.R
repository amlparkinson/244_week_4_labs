# This is an awesome introduction to making a Shiny app: https://deanattali.com/blog/building-shiny-apps-tutorial/

# And here are a bunch of tutorials and examples: https://shiny.rstudio.com/tutorial/

# Here are some cool examples of what you can do with Shiny: https://shiny.rstudio.com/gallery/

# Step 1. Create a new project.
# Step 2. Open a new R Script.
# Step 3. Add the following lines of code:

# library(shiny)
# library(shinydashboard)
# ui <- fluidPage()
# server <- function(input, output) {}
# shinyApp(ui = ui, server = server)

# Then start building from there:

# Here I'm attaching the necessary packages:
library(tidyverse)
library(shiny)
library(shinydashboard)

# Reading in data from my working directory:
penguins <- read_csv("penguins.csv")

# Creating the user interface
ui <- fluidPage(
  titlePanel("I am adding a title!"), # This is the title!
  sidebarLayout( # Adding a sidebar & main panel
    sidebarPanel("put my widgets here",
                 radioButtons(inputId = "species", label = "Choose penguin species", choices = c("Adelie","Gentoo","Cool Chinstrap Penguins!" = "Chinstrap"), # This is my first widget for penguins species
                 ),
                 selectInput(inputId = "pt_color", label = "Select point color", choices = c("Awesome red!" = "red", "Pretty purple" = "purple", "ORAAANGE" = "orange"))
                 ),
    mainPanel("put my graph here", # Adding things to the main panel
              plotOutput(outputId = "penguin_plot"),
              tableOutput(outputId = "penguin_table")
              )
  )
)

# Building the server:
server <- function(input, output) {

  penguin_select <- reactive({

    penguins %>%
      filter(sp_short == input$species)

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

  # Create a reactive plot, which depends on 'species' widget selection:
  output$penguin_plot <- renderPlot({



    ggplot(data = penguin_select(), aes(x = flipper_length_mm, y = body_mass_g)) +
      geom_point(color = input$pt_color)

  })

  output$penguin_table <- renderTable({

    penguin_table()

  })

}
shinyApp(ui = ui, server = server)
