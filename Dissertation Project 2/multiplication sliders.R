ui <- fluidPage(
  sliderInput("x", label = "If x is", min = 1, max = 50, value = 30),
  sliderInput("y", label = "and y is", min = 1, max = 50, value = 30),
  "then x times y is",
  textOutput("product"),
  "and x times y plus five is",
  textOutput("productplusfive"),
  "and x times y plus ten is",
  textOutput("productplusten")
)

server <- function(input, output, session) {
  
  multiplied <- reactive({
    input$x * input$y
  })
  
  output$product <- renderText({ 
    multiplied()
  })
  
  output$productplusfive <- renderText({
    multiplied() + 5
  })
  
  output$productplusten <- renderText({
    multiplied() + 10
  })
}

shinyApp(ui, server)