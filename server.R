list.of.packages <- c("choroplethr", "choroplethrMaps", "dplyr", "devtools", "shiny", "mapproj")
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

library(shiny)
library(choroplethr)
library(choroplethrMaps)
library(dplyr)
library(devtools)
library(mapproj)
library(ggplot2)

# choroplethrZip is on github
if (!"choroplethrZip" %in% installed.packages()[, "Package"]) {
  install_github('arilamstein/choroplethrZip@v1.1.1')
}
library(choroplethrZip)

load("df_demographics.rdata")

shinyServer(function(input, output) {

  output$map = renderPlot({
    df_demographics$value = df_demographics[, input$value]
    num_colors = as.numeric(input$num_colors)
    if (!is.null(input$zips)) {
      # sometimes maps take a long time to load. 
      # so show a message.
      progress = shiny::Progress$new()
      on.exit(progress$close())
      progress$set(message = "Creating map. Please wait.", value = 0)
      
      zip_choropleth(df_demographics, num_colors=num_colors, zip_zoom=input$zips) + coord_map()
    }
  })

  output$counties = renderUI({ 
    county_list = get_all_counties_in_msa(input$msa)
    
    selectInput("counties", "Counties", county_list, selected=county_list, multiple=TRUE)
  })

  output$zips = renderUI({ 
    x=as.numeric(input$counties)
    y=get_all_counties_in_msa(input$msa)
    names(y)=NULL
    if (identical(x,y)) {
      zcta_list = get_all_zip_in_msa(input$msa)
    } else {
      zcta_list = get_zctas_in_counties(input$counties)
    }
    
    selectInput("zips", "Zips", zcta_list, selected=zcta_list, multiple=TRUE)
  })
  
})

get_all_counties_in_msa = function(msa)
{
  county_list = zip.regions %>%
    filter(cbsa.title == msa) %>%
    select(county.fips.numeric, county.name) %>%
    unique()
  ret = county_list$county.fips.numeric
  names(ret) = county_list$county.name
  ret
}

county_list = zip.regions %>%
  filter(cbsa.title == "Abilene, TX") %>%
  select(county.fips.numeric, county.name) %>%
  unique()

get_all_zip_in_msa = function(msa)
{
  zcta_list = zip.regions %>%
    filter(cbsa.title == msa) %>%
    select(region) %>%
    unique()
  zcta_list$region
}

get_zctas_in_counties = function(counties)
{
  counties = as.numeric(counties)
  zctas = zip.regions %>%
    filter(county.fips.numeric %in% counties) %>%
    select(region) %>%
    unique()
  zctas$region
}
