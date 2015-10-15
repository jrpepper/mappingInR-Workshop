##load libraries
library(shiny)
library(leaflet)
library(RColorBrewer)
library(rgdal)
library(raster)
library(ggmap)

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

#remove values with NA lat
berkeleyCrime <- subset(berkeleyCrime, !is.na(berkeleyCrime$lat))

##map data with ggplot


#map with ggmap
bounds <- c(min(berkeleyCrime$long), min(berkeleyCrime$lat), max(berkeleyCrime$long), max(berkeleyCrime$lat))
background <- get_map(location=c(lon = mean(berkeleyCrime$long), lat = mean(berkeleyCrime$lat)), zoom=14, maptype = "terrain", source="google", color="bw")

map <- ggmap(background) + coord_equal() + 
  geom_point(data=berkeleyCrime, aes(x=long, y=lat, alpha=0.3, size=7)) +
  scale_size_continuous(range = c(3)) +
  scale_alpha_continuous(range = c(.3))

map
##map data with leaflet


#add layer selector


##Shiny


#add heatmap