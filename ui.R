library(shiny)
library(choroplethrZip)
library(dplyr)

# get a list of all MSAs in the US
data(zip.regions)
msa_county_df = zip.regions %>%
  filter(metropolitan.micropolitan.statistical.area == "Metropolitan Statistical Area") 
msa_list = unique(msa_county_df$cbsa.title)

values = c("Population", 
           "Per Capita Income", 
           "Median Rent", 
           "% White not Hispanic or Latino", 
           "% Black or African American not Hispanic or Latino", 
           "% Asian not Hispanic or Latino", 
           "% Hispanic or Latino",
           "Median Age")

shinyUI(fluidPage(

  titlePanel("American Community Survey ZIP Explorer"),

  sidebarLayout(
    sidebarPanel(
      selectInput("msa", 
                  "Metropolitan Statistical Area (MSA)", 
                  msa_list,
                  sample(msa_list, 1)),
      
      selectInput("value",
                  "Value",
                  values,
                  selected = "Population"),
      
      uiOutput("counties"),
      uiOutput("zips")
    ),

    mainPanel(
      plotOutput("map")
    )
  )
))
