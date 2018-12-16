names<-c("dplyr","tidyr","rentrez","stringr","rvest","ggplot2","rebus","tidyverse","rentrez","shinydashboard","shiny","DT")


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
    title = "PubKey App"
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
      tabItem("Instructions", h1("How To Use PubKey"),
      uiOutput("video"),
      h3("What is PubKey?"), 
      p("PubKey is an R Package created to quickly and efficently gather and analyze keyword trends from any search query on Pubmed. Pubkey works by creating an initial dataframe by taking any search query and webscraping PubMed to gather important information and the keywords from each article in the query." ),
      h3("How to Start Your Search"),
      p("We highly suggest that our users begin with visiting the `Estimate Time` tab. Some search queries will take longer to download the initial dataframe than others. This estimate will allow the user to make a decision to proceed with their inital query or to try to refine their search."),
      p("Once the user has finalized their query, they can begin downloading the initial dataframe in the `Search PubMed` tab. The user can include any words in the query, and even specify dates, authors or any tools available through PubMed's Advanced Search options. For convienece, included in this tab is the `Advanced Search` page from PubMed. Users can easily build their query and copy the output and paste into the specified search box."),
      p("The output from this search may be difficult to read, but we have included additional tabs for the user to easily digest and visualize their keyword dataframe."),
      h3("Read the Results in a Data Table"), 
      p("Read PubMed's dataframe output easily in the `Data Table` tab. Here, the user can efficiently see which keywords were most used and see how often they were used by year. This table will automatically list the most popular keywords at the top and omit any years that no keywords were found."),
      h3("Analyze Keywords in a Bar Graph"),
      p("After getting the data table with the keywords used in the PubMed search query, it might be useful to visually see which keywords were used more often than others. The user is also able to specify the number of keywords the bar graph should include."),
      h3("Analyze Keyword Trends"),
      p("The user can also quickly see how trends in keywords may have changed over time using our `Keyword Trends Line Graph` tab. The user is also able to specify the number of keywords the graphs should include."), 
      h3("Looking for something different? Continue your search on PubMed!")
    ),
    
    #Estimate time tab
    tabItem("Estimate_Time", h1("Estimate Download Time"), 
            br(),
            textInput("example_Search_Term", label="Enter search term"), 
            submitButton("Update Search", icon("refresh")),
            helpText("When you click the button above, you should see the estimated time it will take to download your current search query."),
            textOutput("time_estimate")),
    
    
    
    
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