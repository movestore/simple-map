library('shiny')
library('move2')
library('sf')
library('maps')
library('shinycssloaders')

shinyModuleUserInterface <- function(id, label) {
  ns <- NS(id)
  
  tagList(
    titlePanel("Simple map with coastlines"),
    sliderInput(inputId = ns("num"), 
                label = "Choose edge size", 
                value = 0, min = 0, max = 30),
    withSpinner(plotOutput(ns("map"),height="90vh"))
  )
}

# The parameter "data" is reserved for the data object passed on from the previous app
shinyModule <- function(input, output, session, data) {
  # all IDs of UI functions need to be wrapped in ns()
  dataObj <- reactive({ data })
  current <- reactiveVal(data)
  
  #transform to lonlat
  if (!st_is_longlat(data))
  {
    data_proj <- st_crs(data)
    data <- data |> 
      sf::st_transform(4326)
    logger.info("Transformed data to LonLat for calcualtions.")
  }
  
  lon <- reactive({st_coordinates(data)[,1]})
  lat <- reactive({st_coordinates(data)[,2]})
  ids <- reactive({unique(mt_track_id(data))})
  COL <- reactive({rainbow(n=length(ids()))})
  data_spl <- reactive({split(data,mt_track_id(data))})
  
  plotInput <- reactive({
    map("world",xlim=c(min(lon())-input$num,max(lon())+input$num),ylim=c(min(lat())-input$num,max(lat())+input$num))
    
    for (i in seq(along=ids()))
    {
      loni <- st_coordinates(data_spl()[[i]])[,1]
      lati <- st_coordinates(data_spl()[[i]])[,2]
      points(loni,lati,col=COL()[i],pch=20,cex=2)
      lines(loni,lati,col=COL()[i],lwd=1)
    }
  })
  
  output$map <- renderPlot({
    print(plotInput())
  })
  
  return(reactive({ current() }))
}
