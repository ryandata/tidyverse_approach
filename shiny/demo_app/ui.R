
# dynamically generated user interface text
# https://shiny.rstudio.com/gallery/dynamic-ui.html

fluidPage(
  
  titlePanel("Scattered Plot"),
  
  # number in the column expression sets the width of the column
 sidebarPanel(
    selectInput("myx", label = "x-axis variable", choices = c("age","height","weight"), selected="age"),
    selectInput("myy", label="y-axis variable", choices = c("age","height","weight"), selected="age")
  ),
  
 mainPanel("scattered",
                          plotOutput("scatterPlot", height="600px")
         )
  )