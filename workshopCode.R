##load libraries
library(shiny)
library(leaflet)
library(RColorBrewer)
library(rgdal)
library(raster)
library(ggmap)


###CLEAN DATA
    ##load data (and parse data)
    berkeleyCrime <- read.csv("./data/berkeley-crime.csv")
    summary(berkeleyCrime)
    
    #extracting Lat and Long from block location field
    berkeleyCrime$latLong <- gsub(".*\n","",berkeleyCrime$Block_Location)#remove everything before '\n'
    berkeleyCrime$latLong <- gsub(".*\\(","",berkeleyCrime$latLong) #remove '('
    berkeleyCrime$latLong <- gsub(")","",berkeleyCrime$latLong) #remove ')'
    berkeleyCrime$latLong <- gsub(" ","",berkeleyCrime$latLong) #remove spaces
    berkeleyCrime$long <- gsub(".*,","",berkeleyCrime$latLong) #setting long field
    berkeleyCrime$lat <- gsub(",.*","",berkeleyCrime$latLong) #setting lat field
    
    #setting lat and long equal to numeric fields
    berkeleyCrime$long <- as.numeric(berkeleyCrime$long)
    berkeleyCrime$lat <- as.numeric(berkeleyCrime$lat)
    
    berkeleyCrime$lat <- jitter(berkeleyCrime$lat, factor = .5)
    berkeleyCrime$long <- jitter(berkeleyCrime$long, factor = .5)
    
    #remove values with NA lat
    berkeleyCrime <- subset(berkeleyCrime, !is.na(berkeleyCrime$lat))
    
    #remove values that are below 36 degrees lat
    berkeleyCrime <- subset(berkeleyCrime, berkeleyCrime$lat>36)
    
    #cleaning date
    berkeleyCrime$EVENTDT <- gsub(" .*","",berkeleyCrime$EVENTDT)

###GGPLOT
    
  #MAP 1: map with ggplot
    map <- ggplot() + 
           geom_point(data=berkeleyCrime, aes(x=long, y=lat))
    
    map
    
  #MAP 2: adding a background map using ggmap
    background <- get_map(location=c(lon = mean(berkeleyCrime$long), lat = mean(berkeleyCrime$lat)), zoom=14, maptype = "terrain", source="google", color="bw")

    map <- ggmap(background) + coord_equal() + 
      geom_point(data=berkeleyCrime, aes(x=long, y=lat, alpha=0.3, size=7)) +
      scale_size_continuous(range = c(3)) +
      scale_alpha_continuous(range = c(.3))
    
    map

##MAP 3: map data with Leaflet
    leaflet(berkeleyCrime) %>%
      addProviderTiles("CartoDB.Positron") %>%
      addCircleMarkers(
        stroke = FALSE, fillOpacity = 0.5, radius=3,
        popup = ~paste("<strong>Offense:</strong>",OFFENSE,
                       "<br>",
                       "<strong>Date:</strong>",EVENTDT,
                       "<br>",
                       "<strong>Time:</strong>",EVENTTM)
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
      addLegend(title = "Type of Offense", pal = offenseColor, values = ~CVLEGEND, opacity = 1)