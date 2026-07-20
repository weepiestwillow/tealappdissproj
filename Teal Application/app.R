library(teal)
library(teal.modules.general)

data <- teal_data(
  iris2 = iris,
  mtcars2 = mtcars,
  code = "
  iris2 <- iris
  mtcars2 <- mtcars"
)

data <- verify(data)

app <- init(
  data = data,
  modules = modules(
    example_module(),
    tm_data_table()
  )
)

shinyApp(app$ui, app$server)