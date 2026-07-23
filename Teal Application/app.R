library(teal)
library(teal.modules.general)
library(random.cdisc.data)
library(teal.modules.clinical)
library(labelled)
library(dplyr)

set.seed(314) #Fixed seed data generation to enable code reproducibility functions
ADSL <- radsl()
ADAE <- radae(ADSL)
ADCM <- radcm(ADSL)
ADTTE <- radtte(ADSL)

ADCM <- ADCM %>% #required renaming of variables to prevent naming conflicts in patient timeline module
  rename(
    CM_ASTDTM = ASTDTM,
    CM_AENDTM = AENDTM,
    CM_ASTDY  = ASTDY,
    CM_AENDY  = AENDY
  )

var_label(ADSL$AGE) <- "Age of Patient"

data <- teal_data( #Assigning datasets to a teal data object with reproducible code
  ADSL = ADSL,
  ADAE = ADAE,
  ADCM = ADCM,
  ADTTE = ADTTE,
  join_keys = default_cdisc_join_keys,
  code = "
  set.seed(314)
  ADSL <- radsl()
  ADAE <- radae(ADSL)
  ADCM <- radcm(ADSL)
  ADTTE <- radtte(ADSL)
  
  ADCM <- ADCM %>%
  rename(
    CM_ASTDTM = ASTDTM,
    CM_AENDTM = AENDTM,
    CM_ASTDY  = ASTDY,
    CM_AENDY  = AENDY
  )
  
  var_label(ADSL$AGE) <- \"Age of Patient\" 
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
    ),
    ##per-patient basic info module##
    tm_t_pp_basic_info(
      label = "Individual Patient Overview",
      dataname = "ADSL",
      patient_col = "USUBJID",
      vars = choices_selected(
        choices = variable_choices(data[["ADSL"]]),
        selected = c("ARM", "AGE", "SEX", "RACE", "ETHNIC", "COUNTRY")
      )
    ),
    ##Per-patient treatment timeline##
    tm_g_pp_patient_timeline(
      label = "Patient Timeline",
      dataname_adcm = "ADCM",
      dataname_adae = "ADAE",
      parentname = "ADSL",
      patient_col = "USUBJID",
      
      aeterm = choices_selected(
        choices = variable_choices(data[["ADAE"]], "AETERM"),
        selected = c("AETERM")
      ), 
      
      cmdecod = choices_selected(
        choices = variable_choices(data[["ADCM"]], "CMDECOD"),
        selected = c("CMDECOD")
      ),
      
      aetime_start = choices_selected(
        choices = variable_choices(data[["ADAE"]], "ASTDTM"),
        selected = c("ASTDTM")
      ),
      
      aetime_end = choices_selected(
        choices = variable_choices(data[["ADAE"]], "AENDTM"),
        selected = c("AENDTM")
      ),
      
      dstime_start = choices_selected(
        choices = variable_choices(data[["ADCM"]], "CM_ASTDTM"),
        selected = c("CM_ASTDTM")
      ),
      
      dstime_end = choices_selected(
        choices = variable_choices(data[["ADCM"]], "CM_AENDTM"),
        selected = c("CM_AENDTM")
      ),
      
      aerelday_start = choices_selected(
        choices = variable_choices(data[["ADAE"]], "ASTDY"),
        selected = c("ASTDY")
      ),
      
      aerelday_end = choices_selected(
        choices = variable_choices(data[["ADAE"]], "AENDY"),
        selected = c("AENDY")
      ),
      
      dsrelday_start = choices_selected(
        choices = variable_choices(data[["ADCM"]], "CM_ASTDY"),
        selected = c("CM_ASTDY")
      ),
      
      dsrelday_end = choices_selected(
        choices = variable_choices(data[["ADCM"]], "CM_AENDY"),
        selected = c("CM_AENDY")
      )
    )
    
    
    
    
    
  )
)



shinyApp(app$ui, app$server)