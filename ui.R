#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

data <- read.csv("BiasMotivatedCrimes.csv")
bias_types <- levels(data$Bias.Type)
offenses <- levels(data$OFFENSE_DESC)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Denver Hate Crimes Map"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       p("Leave Bias Type blank to select all bias types."),
       selectInput("bias_type", "Bias Type", bias_types, multiple = TRUE),
       
       p("Leave Offense Type blank to select all offense types."),
       selectInput("offense", "Offense Type", offenses, multiple = TRUE)
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       leafletOutput("map")
    )
  )
))
