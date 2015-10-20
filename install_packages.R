##run this script only once, to make sure you have installed all the appropriate packages!
options(repos="https://cran.rstudio.com")
install.packages("shiny")
install.packages("leaflet")
install.packages("RColorBrewer")
install.packages("rgdal")
install.packages("raster")
install.packages("ggmap")

install.packages('devtools')
require(devtools)
install_github('ramnathv/rCharts@dev')
install_github('ramnathv/rMaps')
