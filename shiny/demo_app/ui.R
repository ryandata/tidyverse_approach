# https://www.showmeshiny.com/
# dynamically generated user interface text
# https://shiny.rstudio.com/gallery/dynamic-ui.html
library(tidyverse)
mydata<-read_csv("sample.csv")
attach(mydata)

fluidPage(
  
  titlePanel("Scattered Plot"),
  
  # number in the column expression sets the width of the column
 sidebarPanel(
    selectInput("myx", "x-axis variable", choices = c("age","height"), selected="age"),
    selectInput("myy", "y-axis variable", choices = c("age","height"), selected="age")
  ),
  
 mainPanel("scattered",
                          plotOutput("scatterPlot", height="600px")
         )
  )