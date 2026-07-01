# ============================================================
# 31 - R Shiny Basics
# Lesson 4: Display Reactive Output
# Source: https://shiny.posit.co/r/getstarted/shiny-basics/lesson4/
#
# Reactive output has two parts: a *Output() function placed in the UI,
# and a matching render*() function in the server that builds it. Any
# render*() expression that references input$... automatically becomes
# reactive -- Shiny reruns it whenever those inputs change.
#
# Builds on the censusVis UI from Lesson 3 by adding two textOutputs:
# one echoing the selected variable, and one (the lesson's exercise)
# echoing the selected slider range.
# Run with: shiny::runApp("Lesson4_Display_Reactive_Output")
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
      choices = c("Percent White",
                  "Percent Black",
                  "Percent Hispanic",
                  "Percent Asian"),
      selected = "Percent White"
    ),
    sliderInput(
      "range",
      label = "Range of interest:",
      min = 0, max = 100, value = c(0, 100)
    )
  ),
  textOutput("selected_var"),
  textOutput("min_max")
)

# Define server logic ----
server <- function(input, output) {

  output$selected_var <- renderText({
    paste("You have selected", input$var)
  })

  # Exercise: echo the slider range back as reactive text
  output$min_max <- renderText({
    paste("You have chosen a range that goes from",
          input$range[1], "to", input$range[2])
  })

}

# Run the app ----
shinyApp(ui, server)
