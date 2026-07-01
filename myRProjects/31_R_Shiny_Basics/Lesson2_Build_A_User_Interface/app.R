# ============================================================
# 31 - R Shiny Basics
# Lesson 2: Build a User Interface
# Source: https://shiny.posit.co/r/getstarted/shiny-basics/lesson2/
#
# Recreates the lesson's "Model Exercise" app: a page_sidebar layout
# combining a sidebar, a card with a header/body/image/footer, to
# demonstrate the main layout building blocks (page_sidebar, sidebar,
# card, card_header, card_image, card_footer).
# Run with: shiny::runApp("Lesson2_Build_A_User_Interface")
# ============================================================

library(shiny)
library(bslib)

# Define UI ----
ui <- page_sidebar(
  title = "My Shiny App",
  sidebar = sidebar(
    "Shiny is available on CRAN, so you can install it in the usual way from your R console:",
    code('install.packages("shiny")')
  ),
  card(
    card_header("Introducing Shiny"),
    "Shiny is a package from Posit that makes it incredibly easy to build interactive web applications with R. For an introduction and live examples, visit the Shiny homepage (https://shiny.posit.co).",
    card_image(file.path("www", "shiny.svg"), height = "300px"),
    card_footer("Shiny is a product of Posit.")
  )
)

# Define server logic ----
server <- function(input, output) {

}

# Run the app ----
shinyApp(ui = ui, server = server)
