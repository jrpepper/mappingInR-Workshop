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
    background <- get_map(location=c(lon = mean(berkeleyCrime$long),
                                     lat = mean(berkeleyCrime$lat)),
                          zoom=14,
                          maptype = "terrain",
                          source="google",
                          color="bw")
    #EXPLORE: change maptype from "terrain" to "satellite".
    #EXPLORE: change color from "bw" to "color".
    #EXPLORE MORE: In the console, type ?get_map to view other options to customize your background map
    
    
    map <- ggmap(background) + coord_equal() + 
      geom_point(data=berkeleyCrime, aes(x=long, y=lat, alpha=0.3, size=7, color=CVLEGEND)) +
      scale_size_continuous(range = c(3), guide=FALSE) +
      scale_alpha_continuous(range = c(.3), guide=FALSE)
    
    map

##MAP 3: map data with Leaflet.js
    leaflet(berkeleyCrime) %>%
      addProviderTiles("CartoDB.Positron") %>%
      #EXPLORE: Change 'CartoDB.Positron' to 'Esri.WorldImagery' or one of the other
      #provider tiles available at http://leaflet-extras.github.io/leaflet-providers/preview/
      addCircleMarkers(
        stroke = FALSE, fillOpacity = 0.5, radius=4,
        popup = ~paste("<strong>Offense:</strong>",OFFENSE)
      ) #%>% addMarkers(lng=-122.2579, lat=37.87004, popup="Barrows Hall")
        #EXPLORE: uncomment previous line to add a marker on top of Barrows Hall
        #EXPLORE MORE: run ?addControl to view all of the different layers you can add to Leaflet

##MAP 4: add color, legend and clustering
    offenseColor <- colorFactor(rainbow(25), berkeleyCrime$CVLEGEND)
    
    leaflet(berkeleyCrime) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addCircleMarkers(
        stroke = FALSE, fillOpacity = 0.5, radius=6, color = ~offenseColor(CVLEGEND),
        #clusterOptions = markerClusterOptions(spiderfyDistanceMultiplier=2, maxClusterRadius=60),
        #EXPLORE: uncomment the next line to enable clustering of markers on your map
        #EXPLORE MORE: ?markerClusterOptions to view options for customizing clustering
        popup = ~paste("<strong>Offense:</strong>",CVLEGEND,
                       "<br>",
                       "<strong>Date:</strong>",EVENTDT,
                       "<br>",
                       "<strong>Time:</strong>",EVENTTM)
      ) %>%
      addLegend(title = "Type of Offense", pal = offenseColor, values = ~CVLEGEND, opacity = 1, position="bottomleft")
    
    
    
    
    
    
    