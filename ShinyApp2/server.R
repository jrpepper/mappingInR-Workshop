function(input, output, session) {
  
  output$mymap <- renderLeaflet({
    leaflet(berkeleyCrime) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addCircleMarkers(
        stroke = FALSE, fillOpacity = 0.5, radius=6, color = ~offenseColor(CVLEGEND),
        #clusterOptions = markerClusterOptions(spiderfyDistanceMultiplier=2, maxClusterRadius=60),
        popup = ~paste("<strong>Offense:</strong>",CVLEGEND,
                       "<br>",
                       "<strong>Date:</strong>",EVENTDT,
                       "<br>",
                       "<strong>Time:</strong>",EVENTTM)
      ) %>%
      addLegend(title = "Type of Offense", pal = offenseColor, values = ~CVLEGEND, opacity = 1)
  })
}