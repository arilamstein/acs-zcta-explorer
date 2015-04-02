library(shiny)
library(choroplethrZip)

shinyServer(function(input, output) {

  output$map <- renderPlot({

    data(df_pop_zip)
    zip_choropleth(df_pop_zip, msa_zoom=input$msa)
  })

})
