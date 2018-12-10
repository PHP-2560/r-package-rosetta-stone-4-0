library(shiny)
library(shinydashboard)

  ui <- dashboardPage(
      header <- dashboardHeader(title = "PubKey"),
      sidebar <- dashboardSidebar(
        sidebarMenu(
          menuItem("Dashboard", tabname = "dashboard", icon = icon("dashboard")), 
          menuItem("Instructions", icon = icon("list", lib='glyphicon'), href = "https://www.ncbi.nlm.nih.gov/pubmed/"),
          menuItem("Search PubMed", icon = icon("flash"), lib='glyphicon'), 
          menuItem("Data Table", icon = icon("th"), lib='glyphicon'),
          menuItem("Keyword Bar Graph", icon = icon("signal"), lib = 'glyphicon'),
          menuItem("Keyword Trends Line Graph", icon = icon("glass"), lib = 'glyphicon')
        )
      ),
      
      
      
      dashboardBody()
    
    
    
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

