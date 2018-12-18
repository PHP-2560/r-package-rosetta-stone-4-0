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
  #skin = "yellow",
  dashboardHeader(
    title = "PubKey App"
  ),
  
  dashboardSidebar(
    sidebarMenu(id="sbmenu",
                menuItem("Instructions", tabName = "Instructions", icon = icon("list")),
                menuSubItem("Estimate Time", tabName = "Estimate_Time", icon = icon("clock")),
                menuItem("Search PubMed", tabName = "Search_PubMed", icon = icon("search")),
                menuItem("Data Table", tabName =  "data_table", icon = icon("floppy-o")),
                menuItem("Keyword Bar Graph", tabName = "keyword_bar_graph", icon = icon("signal")),
                menuItem("Keyword Trends Line Graph", tabName = "keyword_trends_line_graph", icon = icon("globe")),
                menuItem("Go to PubMed!", icon = icon("send"), 
                         href ="https://www.ncbi.nlm.nih.gov/pubmed/"))
  ),
  
  dashboardBody(
     includeCSS("theme.css"),
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
      p("Read PubMed's dataframe output easily in the `Data Table` tab. Here, the user can efficiently see which keywords were most used and see how often they were used by year. This table will automatically list the most popular keywords at the top and will only start the year where the first keyword was detected."),
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
    
#Search tab
      tabItem("Search_PubMed", h1("Download Initial Dataframe"),
              
              
              textInput("Search_Term", label="Enter search term"),
              submitButton("Update Search", icon("refresh")),
              h3("Use PubMed to specify your search query"),
              p("After completing your query, copy and paste the line generated into our search box above."),
              shiny::tags$iframe(src = "https://www.ncbi.nlm.nih.gov/pubmed/advanced", 
                                 style="width:100%;",  frameborder="0",
                                 id="iframe",
                                 height = "600px"),
              
              br(),
              h3("Click Here to Create Your Summary Table:"),
              actionButton("do", "Create Summary Table", icon("cloud-download"), style = "color: #fff; background-color: #2E86C1; border-color: #2E86C1"),
              h3("View Your Inital Dataframe Here!"),
              p("Depending on how long your search query will take, your dataframe may not appear immediately. We promise our app is working!"),
              dataTableOutput("raw_data")),

#Data Table
tabItem("data_table", h1("View Summary Table"), 
        submitButton("Create Table", icon("thumbs-up")),
        #tableOutput
        DTOutput('data')),

#bar graph tab
tabItem("keyword_bar_graph", h1("Keywords Bar Graph"),
        numericInput("numKey", "Number of Keywords Displayed:", value = 5, min = 1, max = 50),
        submitButton("Update Keywords", icon("refresh")),
        #DTOutput('tbl'),
        h3("See Your Keywords Here!"),
        plotOutput(outputId = "bargraph")),

#line graph tab
tabItem("keyword_trends_line_graph", h1("Keyword Trends"),
        numericInput("lineKey", "Number of Keywords Displayed:", value = 6, min = 1),
        submitButton("Update Keywords", icon("refresh")), 
        #DTOutput('tbl'),
        h3("See Your Keyword Trends Here!"), 
        plotOutput(outputId = "linegraph")
    )
  )
))


server <- function(input, output) {
  
  #Code to save and transfer data
  if(!dir.exists("pubmed_results")){
    dir.create("pubmed_results")
  }
  pubmed_initial <- function(x){
    search <- key_download(x)
    saveRDS(search, file="pubmed_results/temp_data.Rda")
    search
  }
  
  #code to embed YouTube video into Shiny (only change the src link)
  output$video <- renderUI({
    HTML(paste0('<iframe width="560" height="315" src="https://www.youtube.com/embed/YCgLaPoTyzs" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'))
  })
  
  #code to embed PubMed advance search page
  getPage<-function() {
    return(shiny::tags$iframe(src = "https://www.ncbi.nlm.nih.gov/pubmed/advanced", 
                              style="width:100%;",  frameborder="0",
                              id="iframe",
                              height = "600px"))
  }
  output$PubSearch <-renderUI({
    getPage()
  })
  
  #code to get the time estimate for the Estimate Time tab  
  output$time_estimate <- renderText({
    if (input$example_Search_Term =="") {
      return (NULL)
    }
    key_estimate_time(input$example_Search_Term)})
  
  
  #code to get the output for the starting table
  output$raw_data <- renderDataTable({
    if (input$Search_Term =="") {
      return (NULL)
    }
    pubmed_initial(input$Search_Term)})
  
  #Code to create working data frame
  df <- eventReactive(input$do, {key_summary(as.data.frame(readRDS("pubmed_results/temp_data.Rda")))})
  
  #Make Keyword table
  #output$data <- renderTable({df()})
  output$data <- renderDT(df(), options = list(lengthChange = FALSE,scrollX=TRUE), width = "50%") 
  
  #code to load dataframe and get bar graph output
  #output$tbl <- renderDT(df(), options = list(lengthChange = FALSE))
  output$bargraph <- renderPlot({key_bgraph(df(), n_values = input$numKey)})
  
  #code to get line graph output  
  output$linegraph <- renderPlot({key_lgraph(df(), n = input$lineKey)})
}

shinyApp(ui,server)