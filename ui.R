#Libraries needed
library(shiny)
library(tidyverse)
library(rsconnect)
library(plotly)

#Data to be used
load("eurostat.RData")


#Creating the user interface
fluidPage(
  #This line allows the app to show properly on mobile devices:
  HTML('<meta name="viewport" content="width=1024">'),
  
  #Setting the relative size of the sidebar and the plot area:
  tags$head(tags$style(HTML(".col-sm-4 { width: 25%;}
                    .col-sm-8 { width: 75%;}")),
            #Title to be shown @ browser (to get rid of html tags)
            tags$title("Plotting Eurostat statistics on income and living conditions")),

  
  # Application title
  headerPanel(HTML("<b><center>Plotting Eurostat statistics on income and living conditions</b></center></br>")),
  

  
  #Giving a tabset appearance to the app
  tabsetPanel(type = "tabs",
              #Each tabPanel call specifies input for contents of tab
              tabPanel("Line plots", #Tab title
                       sidebarLayout( #To have a personalized sidebar per tab
                         sidebarPanel(
                           #creating the select lists for countries, indicators, sex, age:
                           selectInput(inputId = "geo",
                                       label = "Select countries:",
                                       choices = levels(eurostat$Country),
                                       selected = levels(eurostat$Country)[1],
                                       multiple = TRUE), #allowing multiple country selection
                           selectInput(inputId = "ind",
                                       label = "Select indicator:",
                                       choices = levels(eurostat$ind),
                                       selected = levels(eurostat$ind)[5]),
                           selectInput(inputId = "age",
                                       label = "Age groups:",
                                       choices = levels(eurostat$age_groups),
                                       selected = "Total"),
                           selectInput(inputId = "sex",
                                       label = "Sex:",
                                       choices = levels(eurostat$sex),
                                       selected = "Total"),
                           #Slider bar to allow custom x axis
                           sliderInput("years", "Year range",
                                       min(eurostat$Year), max(eurostat$Year),
                                       value = c(1995, 2018),
                                       step = 5)),
                         #The main panel of the tab will show the lines plot(ly)
                         mainPanel(plotlyOutput("lines")))),
              #Same process for the next tab: bar plots 
              #(some changes made to the options in the side panel)
              tabPanel("Bar plots",
                       sidebarLayout(
                         sidebarPanel( selectInput(inputId ="years_b", 
                                                   label = "Year",
                                                   choices = c(1995:2018),
                                                   selected = 2017),
                                       selectInput(inputId = "ind_b",
                                                   label = "Indicator",
                                                   choices = levels(eurostat$ind),
                                                   selected = levels(eurostat$ind)[5]),
                                       selectInput(inputId = "age_b",
                                                   label = "Age groups",
                                                   choices = levels(eurostat$age_groups),
                                                   selected = "Total"),
                                       selectInput(inputId = "sex_b",
                                                   label = "Sex",
                                                   choices = levels(eurostat$sex),
                                                   selected = "Total")),
                         mainPanel(plotlyOutput("bars")))),
              #Panel with information about the app:
              tabPanel("About", 
                       p(HTML("This is a Shiny Application built to plot statistics on income and living conditions from Eurostat.")),
                       p(HTML("It allows to either compare countries across time by using line charts, or to take more specific snapshots of a moment in time by comparing the 34 countries available.")),
                       p(HTML("You can browse through different indicators and look at their values while specifying sex ang age groups.")),
                       p(HTML("Passing the mouse over the chart gives the exact values of the indicators by country and year.")),
                       p(HTML("Code for the app is available on <a href= https://github.com/aaumaitre/eurostat/>Github</a>")),
                       p(HTML("Data comes from Eurostat and has been retrieved using the eurostat package in R")),
                       p(HTML("Plots are generated using ggplot2 and ggplotly.")),
                       p(HTML("</br>For any questions or inquiries, you can find me at <a href=https://arianeaumaitre.com/> arianeaumaitre.com</a> or on <a href = https://twitter.com/ariamsita>Twitter</a>."))
                       )
              
  ))
