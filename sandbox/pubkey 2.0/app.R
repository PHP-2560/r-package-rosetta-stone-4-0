library(shiny)
library(shinydashboard)


ui <- dashboardPage(
  dashboardHeader(
    title = "Shiny"
  ),
  
  dashboardSidebar(
    sidebarMenu(id="sbmenu",
                menuItem("Instructions", tabName = "Instructions", icon = icon("list")),
                menuItem("Search PubMed", tabName = "Search_PubMed", icon = icon("search")),
                menuItem("Data Table", tabName =  "data_table", icon = icon("calendar")),
                menuItem("Keyword Bar Graph", tabName = "keyword_bar_graph", icon = icon("signal")),
                menuItem("Keyword Trends Line Graph", tabName = "keyword_trends_line_graph", icon = icon("globe")),
                menuItem("Go to PubMed!", icon = icon("send")), href = "https://www.ncbi.nlm.nih.gov/pubmed/")
  ),
  
  dashboardBody(
    tabItems(
      tabItem("Instructions", h1("How to use PubKey")),
      tabItem("Search_PubMed", h1("key_download()"), 
              textInput("Search_terms", 
                        label = strong("Search Terms"), 
                        value = NULL, 
                        width = "100%", placeholder = "Enter Search Terms Here"),
              helpText("You can create a query yourself or use the PubMed Advanced Search below.",
                       "If you choose the latter, copy and paste the search string you've created to the field above.",
                       "When you are done creating the search, press the \"Submit\" button."),
              submitButton("Submit"),
              htmlOutput("PubSearch")),
      tabItem("data_table", h1("key_summary()")),
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
                       height = "380px"))
  }
  output$PubSearch <-renderUI({
    getPage()
  })
}

shinyApp(ui,server)