library(shiny)
library(leaflet)
library(RColorBrewer)
library(rgdal)

r_colors <- rgb(t(col2rgb(colors()) / 255))
names(r_colors) <- colors()