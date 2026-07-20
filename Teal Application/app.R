library(teal)
library(teal.modules.general)
library(random.cdisc.data)
library(teal.modules.clinical)
library(labelled)

set.seed(314) #Fixed seed data generation to enable code reproducibility functions
ADSL <- radsl()
ADAE <- radae(ADSL)
ADTTE <- radtte(ADSL)

var_label(ADSL$AGE) <- "Age of Subject"

data <- teal_data( #Assigning datasets to a teal data object with reproducible code
  ADSL = ADSL,
  ADAE = ADAE,
  ADTTE = ADTTE,
  join_keys = default_cdisc_join_keys,
  code = "
  set.seed(314)
  ADSL <- radsl()
  ADAE <- radae(ADSL)
  ADTTE <- radtte(ADSL)
  
  var_label(ADSL$AGE) <- \"Age of Subject\" 
  "
  
)

data <- verify(data) #Verification of data

app <- init(
  data = data,
  modules = modules(
    ## Variable browser module for oversight of data##
    tm_variable_browser( 
      label = "Data Overview"
    ),
    ## Pre-built Kaplan-Meier plot module ##
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