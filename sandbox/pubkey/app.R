library(shiny)
library(shinydashboard)

library(dplyr)
library(stringr)
library(rvest)
library(rebus)

library(pubkey)
library(rentrez)

ui <- dashboardPage(
  dashboardHeader(
    title = "PubKey"
  ),
  
  dashboardSidebar(
    sidebarMenu(id="sbmenu",
                menuItem("Instructions", tabName = "Instructions", icon = icon("list")),
                menuSubItem("Estimate Time", tabName = "Estimate_Time", icon = icon("clock")),
                menuItem("Search PubMed", tabName = "Search_PubMed", icon = icon("search")),
                menuItem("Data Table", tabName =  "data_table", icon = icon("calendar")),
                menuItem("Keyword Bar Graph", tabName = "keyword_bar_graph", icon = icon("signal")),
                menuItem("Keyword Trends Line Graph", tabName = "keyword_trends_line_graph", icon = icon("globe")),
                menuItem("Go to PubMed!", icon = icon("send")), href = "https://www.ncbi.nlm.nih.gov/pubmed/")
  ),
  
  dashboardBody(
    tabItems(
      tabItem("Instructions", h1("How to use PubKey")),
      tabItem("Estimate_Time", h1("Estimate the time it will take to complete your query"), 
              textInput("example_Search_Term", label="Enter search term"), 
              textOutput("time_estimate")),
      tabItem("Search_PubMed", h1("Download your initial dataframe"), 
              textInput("Search_Term", label="Enter search term"),
              tags$iframe(src = "https://www.ncbi.nlm.nih.gov/pubmed/advanced", 
                                                                                                                     style="width:100%;",  frameborder="0",
                                                                                                                     id="iframe",
                                                                                                                     height = "600px"),
              dataTableOutput("raw_data")),
      tabItem("data_table", h1("key_summary()"),dataTableOutput("data")),
      tabItem("keyword_bar_graph", h1("key_bgraph()")),
      tabItem("keyword_trends_line_graph", h1("key_lgraph()"))
    )
  )
)



server <- function(input, output) {
  getPage<-function() {
    return(tags$iframe(src = "https://www.ncbi.nlm.nih.gov/pubmed/advanced", 
                       style="width:100%;",  frameborder="0",
                       id="iframe",
                       height = "600px"))
  }
  output$PubSearch <-renderUI({
    getPage()
  })
  
  output$time_estimate <- renderText({key_estimate_time(input$example_Search_Term)})
  
  output$raw_data <- renderDataTable({key_download(input$Search_Term)})
}

shinyApp(ui,server)