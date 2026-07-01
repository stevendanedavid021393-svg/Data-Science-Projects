# ============================================================
# 31 - R Shiny Basics
# Lesson 1: Welcome to Shiny
# Source: https://shiny.posit.co/r/getstarted/shiny-basics/lesson1/
#
# A Shiny app lives in its own directory as a single app.R file with
# three parts: a UI object, a server function, and a call to shinyApp().
# This is the "Hello Shiny" example app, modified per the lesson's
# practice exercise:
#   1. Title changed from "Hello Shiny!" to "Hello World!"
#   2. Slider minimum lowered from 1 to 5
#   3. Histogram border color changed from white to orange
# Run with: shiny::runApp("Lesson1_Welcome_To_Shiny")
# ============================================================

library(shiny)
library(bslib)

# Define UI ----
ui <- page_sidebar(
  title = "Hello World!",
  sidebar = sidebar(
    sliderInput(
      inputId = "bins",
      label = "Number of bins:",
      min = 5,
      max = 50,
      value = 30
    )
  ),
  plotOutput(outputId = "distPlot")
)

# Define server logic ----
server <- function(input, output) {
  output$distPlot <- renderPlot({
    x    <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = "#007bc2", border = "orange",
         xlab = "Waiting time to next eruption (in mins)",
         main = "Histogram of waiting times")
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)
