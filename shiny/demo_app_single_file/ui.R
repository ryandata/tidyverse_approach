# https://shiny.rstudio.com/gallery/dynamic-ui.html

fluidPage(
  
  titlePanel("Scattered Plot"),
  
  # number in the column expression sets the width of the column
  column(5, wellPanel(
    selectInput("x", "x-axis variable", choices = names(mydata)),
    selectInput("y", "y-axis variable", choices = names(mydata))
  )),
  
  column(6,
         "This is",
         "MY PLOT!!!",
         
         # With the conditionalPanel, the condition is a JavaScript
         # expression. In these expressions, input values like
         # input$n are accessed with dots, as in input.n
         conditionalPanel("input.n >= 50",
                          plotOutput("scatterPlot", height = 300)
         )
  )
)