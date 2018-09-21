#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(leaflet)
library(rgdal)
library(dplyr)

data <- read.csv("BiasMotivatedCrimes.csv")

transformCoords <- function(xy) {
  colnames(xy) <- c("x","y")
  x <- xy["x"][!is.na(xy["x"])]
  #note that for this dataset either both x and y
  #are present or both are missing
  y <- xy["y"][!is.na(xy["x"])]
  xy <- data.frame(cbind(x,y))
  if (nrow(xy) > 0) {
    xy <- SpatialPoints(xy, CRS("+init=EPSG:3502"))
    proj4string <- "+init=epsg:4326"
    pj <- spTransform(xy,proj4string)
    latlon <- data.frame(lat=pj$y, lon=pj$x)
  } else {
    latlon <- data.frame(lat=c(),lon=c())
  }
  latlon
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$map <- renderLeaflet({
    
    data_intermediate <- data %>% filter(Bias.Type %in% input$bias_type)
    if (is.null(input$bias_type)) {
      data_intermediate <- data
    }
    data_out <- data_intermediate %>% filter(OFFENSE_DESC %in% input$offense)
    if (is.null(input$offense)) {
      data_out <- data_intermediate
    }
    xy <- data_out[c("X_COORDINATE", "Y_COORDINATE")]
    xy <- transformCoords(xy)
    if (nrow(xy) > 0) {
      m <- leaflet(data=xy) %>%
        addTiles() %>%
        addMarkers(~lon,~lat, clusterOptions = markerClusterOptions())
    } else {
      m <- leaflet() %>%
        addTiles()
    }
  })
  
})
