library(shiny)
library(choroplethrZip)
library(dplyr)

# get a list of all MSAs in the US
data(zip.regions)
msa_county_df = zip.regions %>%
  filter(metropolitan.micropolitan.statistical.area == "Metropolitan Statistical Area") 
msa_list = unique(msa_county_df$cbsa.title)

values = c("Population"                                         = "total_population", 
           "Per Capita Income"                                  = "per_capita_income",
           "Median Rent"                                        = "median_rent", 
           "% White not Hispanic or Latino"                     = "percent_white", 
           "% Black or African American not Hispanic or Latino" = "percent_black", 
           "% Asian not Hispanic or Latino"                     = "percent_asian", 
           "% Hispanic or Latino"                               = "percent_hispanic",
           "Median Age"                                         = "median_age")

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
                  selected = "total_population"),
      
      selectInput("num_colors",
                  "Number of Colors",
                  1:7,
                  selected=7),
      
      uiOutput("counties"),
      uiOutput("zips")
    ),

    mainPanel(
      plotOutput("map")
    )
  )
))
