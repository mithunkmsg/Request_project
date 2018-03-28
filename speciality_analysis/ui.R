library(shiny)
library(dygraphs)
library(xts)
library(dplyr)
library(tidyr)
library(reshape2)
speciality_wise<-read.csv("speciality_wise.csv")
city_wise<-read.csv("city_wise.csv")
speciality_wise$X<-NULL
speciality_wise$X.1<-NULL
speciality_wise[is.na(speciality_wise)]<-0
city_wise[is.na(city_wise)]<-0
df1<-melt(speciality_wise,id.vars = c("Date","Speciality"))
df2<-melt(city_wise,id.vars = c("Date","City_Name"))
df1$Date<-as.Date(df1$Date, format="%m/%d/%Y")
df2$Date<-as.Date(df2$Date, format="%m/%d/%Y")


shinyUI(
  pageWithSidebar(
    titlePanel(div(h4(textOutput("title"), align = "center"), style = "color:Green"),windowTitle = "Request Analysis"),
    sidebarPanel(
      selectInput("Speciality","1. Please select a Speciality:",choices = levels(df1$Speciality),selected = "Renal Sciences"),
      selectInput("Type","2. Please select a Type:",choices = levels(df1$variable),selected = "Domestic_Request"),
      selectInput("City","3. Please select a City:",choices = levels(df2$City_Name),selected = "Delhi NCR")
      ),
    mainPanel(
       h4(dygraphOutput("dygraph",height = 200)),
       br(),
       br(),
       h4(dygraphOutput("dygraph2",height = 200))    
       )
)
)