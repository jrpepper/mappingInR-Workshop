function(input, output, session) {
  
  #set the initial color palette
  offenseColor <- colorFactor(rainbow(25), berkeleyCrime$CVLEGEND)
  
  #set options for filtering based on type(s) of offense
  filteredData <- reactive({
    if (is.null(input$offenseFilter)) {data <- berkeleyCrime}
    else {data <- subset(berkeleyCrime, CVLEGEND %in% input$offenseFilter)}
  })
  
  output$map <- renderLeaflet({
    # Use leaflet() here, and only include aspects of the map that
    # won't need to change dynamically (at least, not unless the
    # entire map is being torn down and recreated).
    leaflet(filteredData()) %>%
      addProviderTiles("CartoDB.Positron") %>%
      setView(-122.28, 37.87, zoom = 14)
  })
  
  #set mapCluster variable based on input checkbox
  mapClusterResult <- reactive({
    if(input$mapCluster){TRUE}
    else {NULL}
  })
  
  #update map based on changed inputs
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
      addLegend(title = "Type of Offense", position = "bottomleft",
                pal = offenseColor, values = ~CVLEGEND, opacity = 1)
    
    
  })
}