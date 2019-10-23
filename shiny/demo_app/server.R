library(tidyverse)
mydata<-read_csv("sample.csv")
attach(mydata)

shinyServer(function(input, output) {
  
  # mydata <- reactive({mydata[, c(input$my_x, input$my_y)]})
  output$scatterPlot <- renderPlot({
    # plot(mydata$age,mydata$height)
    # plot(data=cars, input$x, input$y)
    myx<-reactive(input$myx)
    myy<-reactive(input$myy)
    # plot(df[,1]~df[,2])
    plot(x=mydata$myx,y=mydata$myy, xlim=c(0,100), ylim=c(0,100))
    # ggplot(mydata, aes(my_x,my_y))+geom_point()
  })
  
})