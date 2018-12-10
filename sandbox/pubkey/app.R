
library(shiny)

  ui <- fluidPage(titlePanel("pubkey"),
    navlistPanel(
      tabPanel("Introduction to pubkey", "include instructional video here"),
      tabPanel("Search PubMed", "contents"),
      tabPanel("Data Table", "contents"),
      tabPanel("Keyword Bar Graph"), 
      tabPanel("Keyword Trends Line Graph")
    ))
  

  server <- function(input, output){
    
    
  }
# Run the application 
shinyApp(ui = ui, server = server)

