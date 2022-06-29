require(shiny)
require(readxl)

# sha of test files
sha_xlsx <- as.character(openssl::sha256(file('./../DATA/iris.xlsx')))
sha_xls <- as.character(openssl::sha256(file('./../DATA/iris.xls')))
sha_csv <- as.character(openssl::sha256(file('./../DATA/iris.csv')))

ui <- fluidPage(
  titlePanel("test xlsx upload"),
  sidebarLayout(sidebarPanel(
    fileInput('file1', 'Choose a file', accept = c(".xlsx",".xls",".csv")),
    tags$hr(),
    
    radioButtons("ext", "File extension",
                 choices = c(XLSX = "xlsx",
                             XLS = "xls",
                             CSV = "csv"),
                 selected = "xlsx"),
    
    ),
  
  mainPanel(
    tableOutput('uploaded file'),
    
    h4('Path of uploaded file'),
    verbatimTextOutput("path"),
    h4('Expected SHA for uploaded file'),
    p(paste0('iris.xlsx: ',sha_xlsx)),
    p(paste0('iris.xls: ',sha_xls)),
    p(paste0('iris.csv: ',sha_csv)),
    
    h4('SHA of uploaded file'),
    verbatimTextOutput("sha"),
    
    h4('Detected encoding of uploaded file'),
    tableOutput("enc"),
    
    h4('Table output of uploaded file'),
    tableOutput('file3')
  )
  ))

server <- function(input, output, session) {
  
  inFile <- reactive({
    input$file1
  })
  
  output$file2 <- renderTable({
    readxl::format_from_signature(inFile()$datapath)
  })
  
  output$path <- renderText({inFile()$datapath})
  output$sha <- renderText({
    req(input$file1)
    as.character(openssl::sha256(file(inFile()$datapath)))
    })
  output$enc <- renderTable({readr::guess_encoding(inFile()$datapath)})
  
  output$file3 <- renderTable({
    
    req(input$file1)
    if(input$ext == 'xlsx' || input$ext == 'xls'){
      return(readxl::read_excel(inFile()$datapath, 1))
    }
    else {
      return(read.csv(inFile()$datapath, 1))
    }
  
  })  
}

shinyApp(ui, server)

