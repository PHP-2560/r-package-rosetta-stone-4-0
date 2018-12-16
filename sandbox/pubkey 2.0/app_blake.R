names<-c("dplyr","tidyr","rentrez","stringr","rvest","ggplot2","rebus","tidyverse","rentrez","shinydashboard","shiny")


for(name in names){
  if (!(name %in% installed.packages())){
    # install.packages(name, repos="http://cran.us.r-project.org",quiet=TRUE,dependencies=TRUE) #if package not installed, install the package
    print("here")
    install.packages(name, repos="http://cran.us.r-project.org",quiet=TRUE,dependencies=FALSE)} #if package not installed, install the package
  library(name, character.only=TRUE,warn.conflicts=FALSE,quietly=TRUE)
  
}

library(pubkey)

ui <- dashboardPage(
  dashboardHeader(
    title = "Shiny"
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
      tabItem("Estimate_Time", h1("Please use the below function to estimate the time it will take to complete your query"), 
              textInput("example_Search_Term", label="Enter search term"), textOutput("time_estimate")),
      tabItem("Search_PubMed", h1("key_download()"),
              shiny::tags$iframe(src = "https://www.ncbi.nlm.nih.gov/pubmed/advanced", 
                                 style="width:100%;",  frameborder="0",
                                 id="iframe",
                                 height = "600px"),
              textInput("Search_Term", label="Enter search term"),
              "Click to populate the other tabs with the results of your search",
              actionButton("do", "Create Summaries"),
              dataTableOutput("raw_data")),
      tabItem("data_table", h1("key_summary()"), tableOutput("data")),
      tabItem("keyword_bar_graph", h1("key_bgraph()"), plotOutput("bgraph")),
      tabItem("keyword_trends_line_graph", h1("key_lgraph()"), plotOutput("lgraph"))
    )
  )
)


server <- function(input, output) {
  if(!dir.exists("pubmed_results")){
    dir.create("pubmed_results")
  }
  pubmed_initial <- function(x){
    search <- key_download(x)
    saveRDS(search, file="pubmed_results/temp_data.Rda")
    search
  }
  output$time_estimate <- renderText({key_estimate_time(input$example_Search_Term)})
  
  output$raw_data <- renderDataTable({pubmed_initial(input$Search_Term)})
  
  df <- eventReactive(input$do, {key_summary(as.data.frame(readRDS("pubmed_results/temp_data.Rda")))})
  
  output$data <- renderTable({df()})
  output$bgraph <- renderPlot({key_bgraph(df())})
  output$lgraph <- renderPlot({key_lgraph(df())})
}

shinyApp(ui,server)