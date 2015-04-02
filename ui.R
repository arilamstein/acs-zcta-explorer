
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#


#select msa
#auto-population a "county" subnav based on msa.  autopopulate to "all".
#  -start on random msa

#"metric" dropdown.
#-population
#-income
#-% white, black, asian, hispanic
#-rent

library(shiny)
library(choroplethrZip)
library(dplyr)

# get a list of all MSAs in the US
data(zip.regions)
msa_county_df = zip.regions %>%
  filter(metropolitan.micropolitan.statistical.area == "Metropolitan Statistical Area") 

msa_list = unique(msa_county_df$cbsa.title)

shinyUI(fluidPage(

  # Application title
  titlePanel("American Community Survey ZIP Explorer"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      selectInput("msa", 
                  "Select Metropolitan Statistical Area (MSA):", 
                  choices = msa_list,
                  selected = sample(msa_list, 1)),
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30)
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
