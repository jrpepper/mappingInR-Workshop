function(input, output, session) {
  
  offenseColor <- colorFactor(rainbow(25), berkeleyCrime$CVLEGEND)
  
  #set options for filtering based on input
  filteredData <- reactive({
    if(is.null(input$offenseFilter)) {
      berkeleyCrime
    }
    else{
      subset(berkeleyCrime, CVLEGEND %in% input$offenseFilter)
    }
  })
  
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("CartoDB.Positron")
  })
  
  mapClusterResult <- reactive({
    if(input$mapCluster){TRUE}
    else {NULL}
  })
  
  observe({
    leafletProxy("map", data = filteredData()) %>%
      clearMarkers() %>%
      clearControls() %>%
      clearMarkerClusters %>%
      addCircleMarkers(
        stroke = FALSE, fillOpacity = 0.5, radius=6, color = ~offenseColor(CVLEGEND),
        clusterOptions = mapClusterResult(),
        popup = ~paste("<strong>Offense:</strong>",CVLEGEND,
                       "<br>",
                       "<strong>Date:</strong>",EVENTDT,
                       "<br>",
                       "<strong>Time:</strong>",EVENTTM)
      ) %>%
      addLegend(title = "Type of Offense", position = "bottomleft", pal = offenseColor, values = ~CVLEGEND, opacity = 1)
    
    
  })
}