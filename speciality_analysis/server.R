library(reshape2)
library(dplyr)
library(xts)
library(dygraphs)
speciality_wise<-readRDS("speciality_wise.rda")
speciality_wise$X<-NULL
speciality_wise$X.1<-NULL
speciality_wise[is.na(speciality_wise)]<-0
df1<-melt(speciality_wise,id.vars = c("Date","Speciality"))
df1$Date<-as.Date(df1$Date, format="%m/%d/%Y")


shinyServer(
  function(input,output){
    selected <- reactive({df1 %>% 
        filter(Speciality==input$Speciality,variable == input$Type) %>% 
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
    
   
  }
)
    
    
    
  
