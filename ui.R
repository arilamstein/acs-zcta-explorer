library(shiny)
library(choroplethrZip)
library(dplyr)

# get a list of all MSAs in the US
data(zip.regions)
msa_county_df = zip.regions %>%
  filter(metropolitan.micropolitan.statistical.area == "Metropolitan Statistical Area") 
msa_list = unique(msa_county_df$cbsa.title)

shinyUI(fluidPage(

  titlePanel("American Community Survey ZIP Explorer"),

  sidebarLayout(
    sidebarPanel(
      selectInput("msa", 
                  "Select Metropolitan Statistical Area (MSA):", 
                  choices = msa_list,
                  selected = sample(msa_list, 1))
    ),

    mainPanel(
      plotOutput("map")
    )
  )
))
