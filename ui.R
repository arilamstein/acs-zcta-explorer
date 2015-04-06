library(shiny)
library(dplyr)
require(markdown)

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

  titlePanel("US Zip Code Demographic Explorer"),

  fluidRow(column(12, includeMarkdown("1.md"))),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("msa", 
                  "Metropolitan Statistical Area (MSA)", 
                  msa_list,
                  sample(msa_list, 1)),
      
      selectInput("value",
                  "Value",
                  values,
                  selected = sample(values, 1)),
      
      selectInput("num_colors",
                  "Number of Colors",
                  1:7,
                  selected=sample(1:7, 1)),
      
      uiOutput("counties"),
      uiOutput("zips")
    ),

    mainPanel(
      plotOutput("map")
    )
  )
))
