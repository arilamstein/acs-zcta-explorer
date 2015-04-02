library(shiny)
library(choroplethrZip)
library(dplyr)

#data(df_demographics)
shinyServer(function(input, output) {

  output$map = renderPlot({

    if (input$value == "Population") {
      df_demographics$value = df_demographics$total_population
    } else if (input$value == "Per Capita Income") {
      df_demographics$value = df_demographics$per_capita_income
    } else if (input$value == "Median Rent") {
      df_demographics$value = df_demographics$median_rent
    } else if (input$value == "% White not Hispanic or Latino") {
      df_demographics$value = df_demographics$percent_white
    } else if (input$value == "% Black or African American not Hispanic or Latino") {
      df_demographics$value = df_demographics$percent_black
    } else if (input$value == "% Asian not Hispanic or Latino") {
      df_demographics$value = df_demographics$percent_asian
    } else if (input$value == "% Hispanic or Latino") {
      df_demographics$value = df_demographics$percent_hispanic
    } else if (input$value == "Median Age") {
      df_demographics$value = df_demographics$median_age
    } else {
      stop("invalid input")
    }

    zip_choropleth(df_demographics, msa_zoom=input$msa)
  })
  
  output$counties = renderUI({ 
    county_list = zip.regions %>%
      filter(cbsa.title == input$msa) %>%
      select(county.name) %>%
      unique()
    county_list = county_list$county.name
    
    selectInput("counties", "Counties", county_list, selected=county_list, multiple=TRUE)
  })

  output$zips = renderUI({ 
    zcta_list = zip.regions %>%
      filter(cbsa.title == input$msa) %>%
      select(region) %>%
      unique()
    zcta_list = zcta_list$region
    
    selectInput("zips", "Zips", zcta_list, selected=zcta_list, multiple=TRUE)
  })
  
})
