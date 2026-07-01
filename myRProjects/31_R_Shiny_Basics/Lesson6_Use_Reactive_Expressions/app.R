# ============================================================
# 31 - R Shiny Basics
# Lesson 6: Use Reactive Expressions
# Source: https://shiny.posit.co/r/getstarted/shiny-basics/lesson6/
#
# Requires internet access + the quantmod package: getSymbols() pulls
# live price data from Yahoo Finance, and helpers.R's adjust() pulls
# the CPI series from FRED for inflation adjustment.
#   install.packages("quantmod")
# The Yahoo Finance fetch works with no setup. The FRED fetch (only used
# if you check "Adjust prices for inflation") now requires a free API
# key -- see the note at the top of helpers.R.
#
# The problem this lesson solves: the original stockVis app refetched
# stock data from Yahoo Finance inside renderPlot() every time ANY
# input changed -- including just toggling the log-scale checkbox,
# which needs no new data at all.
#
# The fix is to isolate each expensive/cheap step into its own
# reactive() expression. A reactive expression caches its result and
# only reruns when the inputs it reads have actually changed:
#   dataInput()  -> only reruns when symb/dates change (network fetch)
#   finalInput() -> only reruns when dataInput() or adjust changes
#   renderPlot   -> reruns on any of the above, or on the log checkbox,
#                   but by then the expensive fetch/adjust are cached
# Run with: shiny::runApp("Lesson6_Use_Reactive_Expressions")
# ============================================================

# Load packages ----
library(shiny)
library(bslib)
library(quantmod)

# Source helpers ----
source("helpers.R")

# User interface ----
ui <- page_sidebar(
  title = "stockVis",
  sidebar = sidebar(
    helpText(
      "Select a stock to examine.

        Information will be collected from Yahoo finance."
    ),
    textInput("symb", "Symbol", "SPY"),
    dateRangeInput(
      "dates",
      "Date range",
      start = "2013-01-01",
      end = as.character(Sys.Date())
    ),
    br(),
    br(),
    checkboxInput(
      "log",
      "Plot y axis on log scale",
      value = FALSE
    ),
    checkboxInput(
      "adjust",
      "Adjust prices for inflation",
      value = FALSE
    )
  ),
  card(
    card_header("Price over time"),
    plotOutput("plot")
  )
)

# Server logic ----
server <- function(input, output) {

  # Fetches from Yahoo Finance -- only reruns when symb/dates change
  dataInput <- reactive({
    getSymbols(input$symb, src = "yahoo",
               from = input$dates[1],
               to = input$dates[2],
               auto.assign = FALSE)
  })

  # Only reruns when dataInput() or the adjust checkbox changes --
  # NOT when the log-scale checkbox is toggled
  finalInput <- reactive({
    if (!input$adjust) return(dataInput())
    adjust(dataInput())
  })

  output$plot <- renderPlot({
    chartSeries(finalInput(), theme = chartTheme("white"),
                type = "line", log.scale = input$log, TA = NULL)
  })

}

# Run the app ----
shinyApp(ui, server)
