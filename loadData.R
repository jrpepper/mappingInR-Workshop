###LOAD AND CLEAN DATA
##load data (and parse data)
berkeleyCrime <- read.csv("./data/berkeley-crime-2016.csv")
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