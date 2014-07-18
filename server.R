library(shiny)
library(rCharts)
library(datasets)

shinyServer(function(input, output) {
   
   
   # Making the data set reactive with the inputs from UI. User selects,
   # which points to include on the map by StationID range.
   stationData <- reactive({
      dataset <- subset(dat
         , ( start.station.id >= min(input$stationSlider) &
               start.station.id <= max(input$stationSlider))
         , select=c(start.station.latitude
            , start.station.longitude
            , start.station.id
            , start.station.name
         )
      )
      dataset <- unique(dataset)
      return(dataset)
   })
   
   ## select corresponding data and needed attributes to display the data
   bikeData <- reactive({
      dataset <- subset(dat
         , (bikeid == input$bikeSelect)
         , select=c(starttime
            , stoptime
            , start.station.latitude
            , start.station.longitude
            , start.station.id
            , start.station.name
            , end.station.latitude
            , end.station.longitude
            , end.station.id
            , end.station.name
         )
      )
      dataset <- dataset[order(dataset$starttime), ]
      if ( nrow(dataset) > 0 )
      {
         dataset$nr <- 1:nrow(dataset)
      }
      return(dataset)
   })
   
   
   # simple helper function
   # to center the map according to all selected
   # coordinates by mean lat and long
   getMapCenter <- function(stations){
      lat = mean(stations[,1])
      lng = mean(stations[,2])
      return(list(lat = lat, lng = lng))
   }
   
   
   #### Station Chart ####
   output$StationChart <- renderMap({
      map <- Leaflet$new()
      data_ <- stationData()
      center_ <- getMapCenter(data_)
      
      # setView to centre of dataset-points
      map$setView(c(center_$lat, center_$lng), zoom=13)
      
      # plot selected stations
      for (i in 1:nrow(data_))
      {
         map$marker( c(data_[i,"start.station.latitude"]
            , data_[i,"start.station.longitude"])
            , bindPopup = paste0("Station (ID-", data_[i,"start.station.id"], "): ",data_[i,"start.station.name"])
         )
      }
      
      map$tileLayer(provider = 'Esri.WorldImagery')
      map$set(width = 1000, height = 600)
      map$enablePopover(TRUE)
      map$fullScreen(TRUE)
      return(map)
   })
   
   #### Bike History Chart ####
   
   output$BikeHistChart <- renderMap({
      L1 <- Leaflet$new()
      data_  <- bikeData()
      #      center_ <- getMapCenter(data_)
      
      # setView to centre of dataset-points
      #L1$setView(c(center_$lat, center_$lng), zoom=14)
      L1$setView(c(40.74096, -73.98602), zoom=13)
      
      
      #### 
      for (i in 1:nrow(data_))
      {
         L1$marker(c(data_[i, "start.station.latitude"], data_[i, "start.station.longitude"])
            , bindPopup = paste0("Station (ID-", data_[i,"start.station.id"], "): ",data_[i,"start.station.name"]
               , "<br /> Stoptime: ", data_[i,"starttime"]
               , "<br /> Starttime: ", data_[i,"stoptime"]
               , "<br /> Nr: ", data_[i,"nr"])
         )
      }
      ### 
      
      L1$set(width = 1000, height = 600)
      L1$tileLayer(provider = 'Esri.WorldImagery')
      return(L1)
   })
})
