library(teal)
library(teal.modules.general)
library(random.cdisc.data)
library(teal.modules.clinical)

set.seed(314)
ADSL <- radsl()
ADAE <- radae(ADSL)
ADTTE <- radtte(ADSL)

data <- teal_data(
  ADSL = ADSL,
  ADAE = ADAE,
  ADTTE = ADTTE,
  join_keys = default_cdisc_join_keys,
  code = "
  set.seed(314)
  ADSL <- radsl()
  ADAE <- radae(ADSL)
  ADTTE <- radtte(ADSL)
  "
)

data <- verify(data)

app <- init(
  data = data,
  modules = modules(
    tm_variable_browser(
      label = "Data Overview"
    ),
    tm_g_km(
      label = "Kaplan Meier plot",
      dataname = "ADTTE",
      arm_var = choices_selected(
        choices = variable_choices(data[["ADSL"]], c("ARM", "ARMCD")),
        selected = "ARM"
      ),

      strata_var = choices_selected(
        choices = variable_choices(data[["ADSL"]], c("SEX", "AGE", "RACE")),
        selected = NULL 
      ),
      paramcd = choices_selected(
        choices = value_choices(data[["ADTTE"]], "PARAMCD"),
        selected = "OS"
      ),
      aval_var = choices_selected(
        choices = variable_choices(data[["ADTTE"]], "AVAL"),
        selected = "AVAL"
      ),
      cnsr_var = choices_selected(
        choices = variable_choices(data[["ADTTE"]], "CNSR"),
        selected = "CNSR"
      ),
      facet_var = choices_selected(
        choices = variable_choices(data[["ADSL"]], c("SEX", "RACE")),
        selected = "SEX"
      )
    )
  )
)



shinyApp(app$ui, app$server)