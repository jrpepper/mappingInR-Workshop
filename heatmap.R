##heatmap
#run code from workshopCode.R to clean up berkeleyCrime dataframe

#take a subset of crime data
berkeleyCrime.subset <- subset(berkeleyCrime, CVLEGEND=="LARCENY")

#load libraries
library(rMaps)
library(rCharts)

#create leaflet object using rMaps
L2 <- Leaflet$new()
L2$setView(c(37.87,  -122.25), 13)
L2$tileLayer(provider = "MapQuestOpen.OSM")
L2

#turn crime data into JSON
library(plyr)
crime_dat <- ddply(berkeleyCrime.subset, .(lat, long), summarise, count = length(CVLEGEND))
crime_dat = toJSONArray2(na.omit(crime_dat), json = F, names = F)
cat(rjson::toJSON(crime_dat[1:2]))

# Add leaflet-heat plugin.
L2$addAssets(jshead = c(
  "http://leaflet.github.io/Leaflet.heat/dist/leaflet-heat.js"
))

# Add javascript to add heatmap to existing map
L2$setTemplate(afterScript = sprintf("<script>
                                     var addressPoints = %s
                                     var heat = L.heatLayer(addressPoints).addTo(map)           
                                     </script>",
                                     rjson::toJSON(crime_dat)
))

L2