library(shiny)
library(choroplethrZip)
library(dplyr)

shinyServer(function(input, output) {

  output$map = renderPlot({

    data(df_pop_zip)
    zip_choropleth(df_pop_zip, msa_zoom=input$msa)
  })
  
  output$counties = renderUI({ 
    county_list = zip.regions %>%
      filter(cbsa.title == input$msa) %>%
      select(county.name) %>%
      unique()
    county_list = county_list$county.name
    
    selectInput("counties", "Counties", county_list, selected=county_list, multiple=TRUE)
  })

})
