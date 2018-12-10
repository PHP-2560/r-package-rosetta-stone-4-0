library(shiny)
runApp(list(ui= fluidPage(
  titlePanel("opening web pages"),
  sidebarPanel(
    selectInput(inputId='test',label=1,choices=1:5)
  ),
  mainPanel(
    htmlOutput("inc")
  )
),

server = function(input, output) {
  getPage<-function() {
    return(tags$iframe(src = "https://www.ncbi.nlm.nih.gov/pubmed/advanced"
                       , style="width:100%;",  frameborder="0"
                       ,id="iframe"
                       , height = "500px"))
  }
  output$inc<-renderUI({
    x <- input$test
    getPage()
  })
})
)
