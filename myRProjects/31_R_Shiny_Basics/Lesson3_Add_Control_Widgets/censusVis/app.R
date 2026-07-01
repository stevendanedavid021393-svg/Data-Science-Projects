# ============================================================
# 31 - R Shiny Basics
# Lesson 3: Add Control Widgets -- "Your Turn" exercise
# Source: https://shiny.posit.co/r/getstarted/shiny-basics/lesson3/
#
# Build the UI (no server logic yet) for a "censusVis" app that will
# display 2010 US Census demographic maps. Requirements from the
# exercise: a select box named "var" and a slider named "range" that
# accepts two values, both inside a sidebar.
#
# This UI carries forward and grows in later lessons:
#   Lesson 4 adds reactive text output to this same UI.
#   Lesson 5 turns it into the final choropleth map app.
# Run with: shiny::runApp("Lesson3_Add_Control_Widgets/censusVis")
# ============================================================

library(shiny)
library(bslib)

# Define UI ----
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
        list(
          "Percent White",
          "Percent Black",
          "Percent Hispanic",
          "Percent Asian"
        ),
      selected = "Percent White"
    ),
    sliderInput("range",
                label = "Range of interest:",
                min = 0, max = 100, value = c(0, 100))
  )
)

# Define server logic ----
server <- function(input, output) {

}

# Run the app ----
shinyApp(ui = ui, server = server)
