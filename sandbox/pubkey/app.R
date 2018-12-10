library(shiny)
library(shinydashboard)

ui <- 
dashboardPage(
      dashboardHeader(title = "PubKey"),
       
      #dashboard sidebar names
sidebar <- dashboardSidebar(
    sidebarMenu(id = "sbmenu",
          menuItem("Instructions", tabName = "instructions", icon = icon("list")),
          menuItem("Search PubMed", tabName = "search_pubmed", icon = icon("search")), 
          menuItem("Data Table", tabName =  "data table", icon = icon("calendar")),
          menuItem("Keyword Bar Graph", tabName = "keyword bar graph", icon = icon("signal")),
          menuItem("Keyword Trends Line Graph", tabName = "keyword trends line graph", icon = icon("globe")),
          menuItem("Go to PubMed!", icon = icon("send")), href = "https://www.ncbi.nlm.nih.gov/pubmed/") 
      ),
      
    #adding content to each of the tabs
body <- dashboardBody(
        tabItems(
          #First tab content
          tabItem("instructions", "Instructions tab content")), 
          
          #2nd tab content
          tabItem("search_pubmed", "add video here"))
          )

  


  server <- function(input, output){
    observe(print(input$sbmenu))
    
  }
# Run the application 
shinyApp(ui = ui, server = server)

