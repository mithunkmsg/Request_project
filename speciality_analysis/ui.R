library(shiny)
library(dygraphs)
library(xts)
library(dplyr)
library(tidyr)
library(reshape2)
speciality_wise<-readRDS("speciality_wise.RDA")

speciality_wise$X<-NULL
speciality_wise$X.1<-NULL
speciality_wise[is.na(speciality_wise)]<-0

df1<-melt(speciality_wise,id.vars = c("Date","Speciality"))

df1$Date<-as.Date(df1$Date, format="%m/%d/%Y")



shinyUI(
  pageWithSidebar(
    titlePanel(div(h4(textOutput("title"), align = "center"), style = "color:Green"),windowTitle = "Request Analysis"),
    sidebarPanel(
      selectInput("Speciality","1. Please select a Speciality:",choices = levels(df1$Speciality),selected = "Renal Sciences"),
      selectInput("Type","2. Please select a Type:",choices = levels(df1$variable),selected = "Domestic_Request"),
    
      ),
    mainPanel(
       h4(dygraphOutput("dygraph",height = 200))
          
       )
)
)
