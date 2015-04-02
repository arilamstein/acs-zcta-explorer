library(shiny)
library(choroplethrZip)
library(dplyr)

#data(df_demographics)
shinyServer(function(input, output) {

  output$map = renderPlot({
    df_demographics$value = df_demographics[, input$value]
    num_colors = as.numeric(input$num_colors)
    zip_choropleth(df_demographics, num_colors=num_colors, msa_zoom=input$msa)
  })
  
  output$counties = renderUI({ 
    county_list = get_all_counties_in_msa(input$msa)
    
    selectInput("counties", "Counties", county_list, selected=county_list, multiple=TRUE)
  })

  output$zips = renderUI({ 
    if (input$counties == get_all_counties_in_msa(input$msa)) {
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
    select(county.name) %>%
    unique()
  county_list$county.name
}

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
}
