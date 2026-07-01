# ============================================================
# 31 - R Shiny Basics
# Lesson 5: Use R Scripts and Data
# Source: https://shiny.posit.co/r/getstarted/shiny-basics/lesson5/
#
# The directory app.R lives in becomes the app's working directory, so
# helpers.R and data/counties.rds (downloaded verbatim from the lesson)
# are sourced/read with plain relative paths.
#
# Execution timing matters:
#   - code outside server()      -> runs once, when the app launches
#   - the server() function body -> runs once per connecting user
#   - code inside render*()      -> reruns whenever a referenced input changes
# Loading data and sourcing scripts belongs at the top level so every
# user shares one copy instead of reloading it per session.
#
# This is the lesson's final app: the censusVis UI from Lessons 3-4,
# now driving an actual choropleth map via percent_map() from helpers.R.
# Run with: shiny::runApp("Lesson5_Use_R_Scripts_And_Data")
# ============================================================

# Load packages ----
library(shiny)
library(bslib)
library(maps)
library(mapproj)

# Load data ----
counties <- readRDS("data/counties.rds")

# Source helper functions ----
source("helpers.R")

# User interface ----
ui <- page_sidebar(
  title = "censusVis",
  sidebar = sidebar(
    helpText(
      "Create demographic maps with information from the 2010 US Census."
    ),
    selectInput(
      "var",
      label = "Choose a variable to display",
      choices =
        c(
          "Percent White",
          "Percent Black",
          "Percent Hispanic",
          "Percent Asian"
        ),
      selected = "Percent White"
    ),
    sliderInput(
      "range",
      label = "Range of interest:",
      min = 0,
      max = 100,
      value = c(0, 100)
    )
  ),
  card(plotOutput("map"))
)

# Server logic ----
server <- function(input, output) {
  output$map <- renderPlot({
    data <- switch(input$var,
                   "Percent White" = counties$white,
                   "Percent Black" = counties$black,
                   "Percent Hispanic" = counties$hispanic,
                   "Percent Asian" = counties$asian)

    color <- switch(input$var,
                    "Percent White" = "darkgreen",
                    "Percent Black" = "black",
                    "Percent Hispanic" = "darkorange",
                    "Percent Asian" = "darkviolet")

    legend <- switch(input$var,
                     "Percent White" = "% White",
                     "Percent Black" = "% Black",
                     "Percent Hispanic" = "% Hispanic",
                     "Percent Asian" = "% Asian")

    percent_map(data, color, legend, input$range[1], input$range[2])
  })
}

# Run app ----
shinyApp(ui, server)
