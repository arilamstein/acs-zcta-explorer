library(shiny)
library(choroplethrZip)
library(dplyr)

# get a list of all MSAs in the US
data(zip.regions)
msa_county_df = zip.regions %>%
  filter(metropolitan.micropolitan.statistical.area == "Metropolitan Statistical Area") 
msa_list = unique(msa_county_df$cbsa.title)

msa = sample(msa_list, 1)
county_list = zip.regions %>%
  filter(cbsa.title == msa) %>%
  select(county.name) %>%
  unique()
county_list = county_list$county.name

county_list = zip.regions %>%
  filter(cbsa.title == msa) %>%
  select(county.name) %>%
  unique()
county_list = county_list$county.name

zcta_list = zip.regions %>%
  filter(cbsa.title == msa) %>%
  select(region) %>%
  unique()
zcta_list = zcta_list$region

shinyUI(fluidPage(

  titlePanel("American Community Survey ZIP Explorer"),

  sidebarLayout(
    sidebarPanel(
      selectInput("msa", 
                  "Metropolitan Statistical Area (MSA)", 
                  msa_list,
                  msa),
      
      uiOutput("counties"),
      
      selectInput("ZIP Code Tabulated Areas (ZCTAS):", "ZIP Codes", zcta_list, selected=zcta_list, multiple=TRUE)
      
    ),

    mainPanel(
      plotOutput("map")
    )
  )
))
