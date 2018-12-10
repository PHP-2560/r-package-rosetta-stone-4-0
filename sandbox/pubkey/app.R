library(shiny)
library(shinydashboard)

  ui <- dashboardPage(
      header <- dashboardHeader(title = "PubKey"),
      sidebar <- dashboardSidebar(
        sidebarMenu(
          #menuItem("Dashboard", tabname = "dashboard", icon = icon("dashboard")), 
          menuItem("Instructions", tabName = "Instructions", icon = icon("list"), lib='glyphicon'),
          menuItem("Search PubMed", tabName = "Search PubMed", icon = icon("search"), lib='glyphicon'), 
          menuItem("Data Table", tabName =  "Data Table", icon = icon("calendar"), lib='glyphicon'),
          menuItem("Keyword Bar Graph", tabName = "Keyword Bar Graph", icon = icon("signal"), lib = 'glyphicon'),
          menuItem("Keyword Trends Line Graph", tabName = "Keyword Trends Line Graph", icon = icon("globe"), lib = 'glyphicon'),
          menuItem("Go to PubMed!", icon = icon("send"), lib='glyphicon'), href = "https://www.ncbi.nlm.nih.gov/pubmed/") 
      ),
      
     body <- dashboardBody(
        tabItems(
          #First tab content
          tabItem(tabName = "Instructions", "Instructions tab content"), 
          
          #2nd tab content
          tabItem(tabName = "Search PubMed", 
                  h2("add content here"))
                    
                  
          )
        
      )
    
    
    
  )
    
    
    # fluidPage(titlePanel("pubkey"),
    # navlistPanel(
    #   tabPanel("Introduction to pubkey", "include instructional video here"),
    #   tabPanel("Search PubMed", "contents"),
    #   tabPanel("Data Table", "contents"),
    #   tabPanel("Keyword Bar Graph"), 
    #   tabPanel("Keyword Trends Line Graph")
    # ))
  

  server <- function(input, output){
    
    
  }
# Run the application 
shinyApp(ui = ui, server = server)

