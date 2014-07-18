
library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
   
   # Application title
   titlePanel("CityBike"),
   
   # Sidebar with a slider input for the number of bins
   sidebarLayout(
      
      conditionalPanel( condition = "input.tabsetPanel != 'dataPanel'"
                      , sidebarPanel( width = 2
                                   
                                    , conditionalPanel( condition = "input.tabsetPanel == 'stationPanel'"
                                                      , sliderInput(inputId = "stationSlider"
                                                                  , label = "Stations:"
                                                                  , min = min(dat$start.station.id)+0
                                                                  , max = max(dat$start.station.id)+0
                                                                  , value = c(min(dat$start.station.id)
                                                                             ,min(dat$start.station.id)+1000))
                                                      )
                                    , conditionalPanel( condition = "input.tabsetPanel == 'bikeHistPanel'"
                                                      , selectInput(inputId = "bikeSelect"
                                                                  , label = "BikeId:"
                                                                  , choices = dat[order(dat$bikeid),]$bikeid)
                                                      )
                                    )
      ),
      
      # Show a plot of the generated distribution
      mainPanel(
         tabsetPanel( id = "tabsetPanel"
                    , tabPanel(title = "Station overview"
                             , value = "stationPanel"
                             , mapOutput('StationChart'))
                    , tabPanel(title = "Bike history"
                             , value ="bikeHistPanel"
                             , mapOutput('BikeHistChart'))
                    , tabPanel(title = "Data"
                             , value ="dataPanel")
                    )
               )
   )
))
