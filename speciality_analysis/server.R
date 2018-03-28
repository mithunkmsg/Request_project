library(reshape2)
library(dplyr)
library(xts)
library(dygraphs)
speciality_wise<-readRDS("speciality_wise.rda")
city_wise<-readRDS("city_wise.rda")
speciality_wise$X<-NULL
speciality_wise$X.1<-NULL
speciality_wise[is.na(speciality_wise)]<-0
city_wise[is.na(city_wise)]<-0
df1<-melt(speciality_wise,id.vars = c("Date","Speciality"))
df2<-melt(city_wise,id.vars = c("Date","City_Name"))
df1$Date<-as.Date(df1$Date, format="%m/%d/%Y")
df2$Date<-as.Date(df2$Date, format="%m/%d/%Y")

shinyServer(
  function(input,output){
    selected <- reactive({df1 %>% 
        filter(Speciality==input$Speciality,variable == input$Type) %>% 
        group_by(Date) %>%
        summarise(n = value)})
    
    selected2 <- reactive({df2 %>% 
        filter(City_Name==input$City,variable == input$Type) %>% 
        group_by(Date) %>%
        summarise(n = value)})
    
    output$title <- renderText({
      paste0(input$Type, " in ",input$Speciality)})
    
    
    
    output$dygraph<-renderDygraph({
      spe_xts <- xts(selected()$n, order.by = as.Date(selected()$Date))
      dygraph(spe_xts,xlab = "week (plot for speciatity_wise)",ylab = "Frequency")%>%
        dySeries("V1",label=input$Type,color = "blue", fillGraph = F, strokeWidth = 3, drawPoints = TRUE, pointSize = 6)
              }
      )
    
    output$dygraph2<-renderDygraph({
      spe_xts2<-xts(selected2()$n,order.by = as.Date(selected2()$Date))
      dygraph(spe_xts2,xlab = "week (plot for city_wise)",ylab = "Frequency")%>%
        dySeries("V1",label=input$Type,color="red",fillGraph = F, strokeWidth = 3, drawPoints = T, pointSize = 6)
    })
  }
)
    
    
    
  
