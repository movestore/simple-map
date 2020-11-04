library('move')
library('shiny')
library('maps')

shinyModuleUserInterface <- function(id, label,num=2) {
  ns <- NS(id)
  
  tagList(
    titlePanel("Simple map"),
    sliderInput(inputId = ns("num"), 
                label = "Choose a margin size", 
                value = num, min = 1, max = 30),
    plotOutput(ns("map"))
  )
}

shinyModuleConfiguration <- function(id, input) {
  ns <- NS(id)
  configuration <- list()

  configuration
}

shinyModule <- function(input, output, session, data,num=2) {
  dataObj <- reactive({ data })
  current <- reactiveVal(data)

  lon <- reactive({coordinates(data)[,1]})
  lat <- reactive({coordinates(data)[,2]})
  ids <- reactive({namesIndiv(data)})
  COL <- reactive({rainbow(n=length(ids()))})
  data_spl <- reactive({move::split(data)})

  plotInput <- reactive({
    map("world",xlim=c(min(lon())-input$num,max(lon())+input$num),ylim=c(min(lat())-input$num,max(lat())+input$num))
    
    for (i in seq(along=ids()))
    {
      loni <- coordinates(data_spl()[[i]])[,1]
      lati <- coordinates(data_spl()[[i]])[,2]
      points(loni,lati,col=COL()[i],pch=20,cex=2)
      lines(loni,lati,col=COL()[i],lwd=1)
    }
  })
  
  output$map <- renderPlot({
    print(plotInput())
  })
  
  return(reactive({ current() }))
}