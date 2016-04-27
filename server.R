
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library("shiny")
library("lubridate")

shinyServer(function(input, output) {

  output$text1 <- renderText({
    
    avgTemp <- (input$high + input$low) / 2
    
    # gives first constant
    k1 <- (24*60)/pi  
    
    # the solar constant
    solar.constant <- 0.0820  
    
    # day of year as an integer
    day.of.year <- yday(input$date) 
    
    # inverse relative distance Earth-Sun, d-sub-r and solar declination
    inverse.distance <- 1 + 0.033 * cos(((2 * pi) / 365) * day.of.year)
    solar.declination <- 0.409 * sin((((2 * pi) / 365) * day.of.year) - 1.39)
    latitudeRadians <- (pi/180) * input$latitude 
    sunset.hour.angle <- acos(-tan(latitudeRadians) * tan(solar.declination))
   
    # Ra, extraterrestrial irradiance
    Ra <- ((k1 * solar.constant) * inverse.distance) *
      (sunset.hour.angle * sin(latitudeRadians) * sin(solar.declination) +
         cos(latitudeRadians) * cos(solar.declination) * sin(sunset.hour.angle))
    
    # Ra expressed in equivalent evaporation
    RaMm <- Ra * 0.408
    
    ETo <- 0.0023 * (avgTemp + 17.8) *
      (input$high - input$low)^0.5 * RaMm
    
    ETc <- ETo * input$kC
    
    paste("基準 ET の日",
          input$date, 
          " その日の最高気温 ",
          input$high,
          "°C, 最低気温 ",
          input$low,
          "°C, その場所の緯度 ",
          input$latitude,
          "° を入力 ",
          formatC(ETo, digits = 2), 
          " mm. 作物係数が ",
          input$kC,
          " その植物のET は ",
          formatC(ETc, digits = 2),
          " mm.", sep = "")

  })

})
