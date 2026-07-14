library(shiny)
library(bslib)
library(palmerpenguins)

# Define UI ----
ui <- page_sidebar(
  title = "Penguins dashboard",
  sidebar = sidebar(
    varSelectInput(
      "color_by",
      "Color by",
      penguins[c("species", "island", "sex")],
      selected = "species"
    )
  ),
  
  navset_card_underline(
    title = "Histograms by species",
    nav_panel("Bill Length", plotOutput("bill_length")),
    nav_panel("Bill Depth", plotOutput("bill_depth")),
    nav_panel("Body Mass", plotOutput("body_mass"))
  )
)

# Define server logic ----
server <- function(input, output) {
  
}

# Run the app ----
shinyApp(ui = ui, server = server)