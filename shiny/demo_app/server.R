
shinyServer(function(input, output) {
  plotData <- reactive({mydata[, c(input$myx, input$myy)]})
   output$scatterPlot <- renderPlot({
   ggplot(plotData(), aes(input$myx,y=input$myy))+geom_point()
   })
  
})