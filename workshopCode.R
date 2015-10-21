##load libraries. If you do not have these libraries installed, run the R code file titled 'installLibraries.R'
library(shiny)
library(leaflet)
library(RColorBrewer)
library(rgdal)
library(raster)
library(ggmap)

###Load and clean data
source("loadData.R")

###GGPLOT
    
  #MAP 1: map with ggplot
    map <- ggplot() + 
           geom_point(data=berkeleyCrime, aes(x=long, y=lat))
    
    map
    
  #MAP 2: adding a background map using ggmap
    background <- get_map(location=c(lon = mean(berkeleyCrime$long), lat = mean(berkeleyCrime$lat)), zoom=14, maptype = "terrain", source="google", color="bw")

    map <- ggmap(background) + coord_equal() + 
      geom_point(data=berkeleyCrime, aes(x=long, y=lat, alpha=0.3, size=7, color=CVLEGEND)) +
      scale_size_continuous(range = c(3), guide=FALSE) +
      scale_alpha_continuous(range = c(.3), guide=FALSE)
    
    map

##MAP 3: map data with Leaflet.js
    leaflet(berkeleyCrime) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addCircleMarkers(
        stroke = FALSE, fillOpacity = 0.5, radius=4,
        popup = ~paste("<strong>Offense:</strong>",OFFENSE)
      )

##MAP 4: add color, legend and clustering
    offenseColor <- colorFactor(rainbow(25), berkeleyCrime$CVLEGEND)
    
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
      addLegend(title = "Type of Offense", pal = offenseColor, values = ~CVLEGEND, opacity = 1, position="bottomleft")
    
    
    
    
    
    
    