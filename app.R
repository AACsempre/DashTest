# LIBRARIES ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
library(shiny)
library(shinythemes)

library(htmlwidgets)
library(rjson)

library(plotly)
library(openair)

source('Htmls0.R')

# SELECT INSTALLATION , ETC ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
i_ch = list("Test_A" = 1, "Test_B" = 2)

sel_install <-  selectInput("inst",
                            label = "Select Installation:",
                            choices = i_ch) 

print("Initial stage loaded OK!")


##### Define UI for application ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
ui <- tagList( 
  #Auto refresh link (might be useful when deploying to shinyapps.io)
  tags$head( tags$script(JS("setTimeout(function(){history.pushState({}, 'DashTest', '/test_link');},5000);")) ) ,
  
   fluidPage(
    #THEME SELECTION 
    theme = shinytheme("flatly"),

    #BROWSER TAB ICON AND TITLE
    titlePanel(tags$head(tags$link(rel = "icon", type = "image/png", href = "d_icon.png"),
                         tags$title("DashTest"))),

    #NAVBAR
    navbarPage(tags$img(height = 32, with = 80, src = "d_icon.png"),  id='navbar',

               
        #TAB_ HOME PAGE - WELCOME TO DashTest
        tabPanel(title= HTML('<hh><p> <strong>  DashTest  </strong> </p></hh>'), 
              fluidRow(column(12, welc_dash)),
              br()
        ),              
                 
        #TAB_ACCOUNT 
        navbarMenu(title = "Account",
        #TAB_ACCOUNT installs
        tabPanel("Installation",
           sidebarLayout(
             #LEFT
             sidebarPanel(
               verbatimTextOutput("user_info"),
               sel_install,
               textOutput("insta_Text"),
               htmlOutput("insta_Text2")
             ),
             #MAIN  
             mainPanel(
               imageOutput("insta_Plot")
             ) )
        ),
        tabPanel("Documents",
           sidebarLayout(
             #LEFT
             sidebarPanel(
               htmlOutput("docs_list0")
             ),
             #MAIN
             mainPanel(
               column(6, htmlOutput("docs_list1")),
               column(6, uiOutput("docs_list2"))
             ) )
        ) ),

        #TAB_MONIT 
        navbarMenu(title = "Monitoring", 
        #TAB_MONIT weather 
        tabPanel("Seasonal Data",
            #TOP
            fluidRow(
             dateRangeInput(inputId = "dates_w", label = "Date range", format = "yyyy-mm-dd", width = NULL)
            ), br(),
            #MAIN   
            fluidRow(
             column(4, plotlyOutput("temp_Plot")),
             column(4, plotlyOutput("hum_Plot")) ,
             column(4, plotlyOutput("prec_Plot"))
            ), br(), br(),
            fluidRow(
             column(4, plotlyOutput("wind_Plot")),
             column(4, plotOutput("windr_Plot")),
             column(4, plotlyOutput("sg_Plot")),  
             br(), br(), br(), br(), br() ),
            br(), br() 
        ),
        
        #TAB_LTE
        tabPanel("Daily Data",    #empty in this example
             #TOP
             fluidRow( ),   #empty in this example
             br(), 
             #MAIN   
             fluidRow( ),   #empty in this example
             br() 
        ) ),
        
        #TAB_ANA 
        navbarMenu(title = "Analysis",    #empty in this example
        
        #TAB_MONIT main events
        tabPanel("",tags$br(),   #empty in this example
           #MAIN                 
           fluidRow(
              #LEFT
              column(3,  
                fluidRow( ) ),
              #MAIN
              column(9,
                fluidRow( ),   
                br() )
           ), 
        )

        ),
        tabPanel(title = "Logout", value="stop", icon = icon("power-off") ),
        
        #FOOTER
        footer = footer_0

    ),
    #TAGS
    tags$style(type = 'text/css', "footer{background-color: rgb(96,96,96); position: fixed; bottom:0%; left:0%; width:100%; padding:1px;}", "head {font-family: Orbitron;}"),
    tags$style(HTML(" @import url('//fonts.googleapis.com/css?family=Orbitron'); hh{font-family: Orbitron;} "))
)
)



##### Define server logic ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
server <- function(input, output, session) {  #possible without "session"

    #LOGOUT
    observe({
      if (input$navbar == "stop") {
        print("Stop App") 
        stopApp() 
      }
    })
   
    #INSTALLATION SELECT 
    install <- reactive({ input$inst })

    output$insta_Text <- renderText({
        print("Installation window")      
        paste("Selected Installation: ") })

    output$insta_Text2 <- renderUI({
        if (install() == 1) install_1
        else if (install() == 2) install_2    
     })
    
    output$insta_Plot <- renderImage({ 
      if (install() == 1)    list(src = paste0("data/", install(), "/base_fig.png"),  width = 896, height = 919)
      else if (install() == 2)    list(src = paste0("data/", install(), "/base_fig.png"),  width = 514, height = 573)      
    }, deleteFile = FALSE)
    
    #DOCUMENTS List
    DocData <- reactive({ 
      DocData0 <- read.csv(paste0("data/", install(), "/DocList.csv"), sep=",", stringsAsFactors = FALSE)
      DocData0
    })    
    
    output$docs_list0<- renderUI({
      docs_list0
    })
    output$docs_list1<- renderUI({
      docs_list1
    })
    output$docs_list2<- renderUI({
      print("Docs window")
      shtm0 = docs_list2a
      shtm1 = ""
      for (i in 1:nrow(DocData())) {
        shtm1 =  paste(shtm1, '<li> <a href="',DocData()[i,2], '" target="_blank" >' , DocData()[i,1],'</a> </li> ' )
      }
      HTML(paste(shtm0, shtm1, ' </ul>    </dl> '))
    })

    #LOAD WEATHER SEASON DATA (LTE) LIST   
    LteData <- reactive({
      invalidateLater(300000,session) #auto update every 5 minutes
      LteData1 <- read.csv(paste0("data/", install(), "/LteList.csv"), sep=",", header = TRUE)
      data.frame(LteData1)
    })
    
    #UPDATE DATE INPUT RANGE
    observe({ 
      lte_days <- as.Date(LteData()[2:nrow(LteData()),"Date"])  #days with data
      if (length(lte_days) == 0)  lte_days <- as.Date(Sys.Date())  #if none, use system data
      min_lte_days <- min(lte_days);
      max_lte_days <- max(lte_days);
      if (max_lte_days - min_lte_days >= 31)  start_lte_days <- max_lte_days - 31 #start by showing laswt month
      else start_lte_days <- min_lte_days
      
      updateDateRangeInput(session, inputId = "dates_w", label = "Date range", start = start_lte_days, end = max_lte_days,
                           min = min_lte_days, max = max_lte_days)
    }) 
    
    #LOAD SENSORS IDS 
    jsID <- reactive({
      fromJSON(file = paste0("data/", install(), "/sIDs.json"))
    })
    
    #get Hardware ID identification - rename it
    transf_hwid <- function(hw_id){
      th_aux <- FALSE
      for (i in 1:length(jsID()$sID)) {
        if (hw_id == jsID()$sID[i]) {
          local = jsID()$sName[i]
          th_aux <- TRUE
          if (th_aux == FALSE) local <- "Unknown"
        } }
      return(local)
    }  
 
    
    #WEATHER PLOTS - REACTIVE DATE
    LteData_sub <- reactive({ subset(LteData()[2:nrow(LteData()),], as.Date(Date) >= input$dates_w[1] & as.Date(Date) <= input$dates_w[2]) })
      #Temperature plot
      output$temp_Plot <- renderPlotly({ 
          print(paste0("Seasonal monit.: " , input$dates_w[1] , " - ", input$dates_w[2]))
        config(plot_ly(source = "zzz"), displaylogo = FALSE, modeBarButtonsToRemove = c('lasso2d', 'select2d', 'autoScale2d'))  %>%
            add_trace(x= LteData_sub()[,"Date"], y=as.numeric(as.character(LteData_sub()[,"Max11"])), name = paste0("High"), mode = 'lines', type = 'scatter', line = list(color = 'red'))  %>%
            add_trace(x= LteData_sub()[,"Date"], y=as.numeric(as.character(LteData_sub()[,"Min11"])), name = paste0("Low"), mode = 'lines', type = 'scatter', line = list(color = 'blue'))  %>%
            layout(title = list(text = "Temperature", x = 0.1), yaxis = list(title = '[ \u00B0C ]'), xaxis = list(type = 'date') )
      })
      #Humidity plot
      output$hum_Plot <- renderPlotly({ 
        config(plot_ly(source = "zzz"), displaylogo = FALSE, modeBarButtonsToRemove = c('lasso2d', 'select2d', 'autoScale2d'))  %>%
          add_trace(x= LteData_sub()[,"Date"], y=as.numeric(as.character(LteData_sub()[,"Max12"])), name = paste0("High"), mode = 'lines', type = 'scatter', line = list(color = 'red'))  %>%
          add_trace(x= LteData_sub()[,"Date"], y=as.numeric(as.character(LteData_sub()[,"Min12"])), name = paste0("Low"), mode = 'lines', type = 'scatter', line = list(color = 'blue'))  %>%
          layout(title = list(text = "Relative Humidity", x = 0.1), yaxis = list(title = '[ % ]'), xaxis = list(type = 'date'))  
      })     
      #Precipitation plot
      output$prec_Plot <- renderPlotly({
        config(plot_ly(source = "zzz"), displaylogo = FALSE, modeBarButtonsToRemove = c('lasso2d', 'select2d', 'autoScale2d'))  %>%
            add_trace(x= LteData_sub()[,"Date"], y=as.numeric(as.character(LteData_sub()[,"Sum06"])), name = paste0("Actual"), type = "bar", marker = list(color = 'darkblue')) %>%
            layout(title = list(text = "Precipitation", x = 0.1), yaxis = list(title = '[ mm ]'), xaxis = list(type = 'date'))  
      })
      #Wind plot
      output$wind_Plot <- renderPlotly({        
        config(plot_ly(source = "zzz"), displaylogo = FALSE, modeBarButtonsToRemove = c('lasso2d', 'select2d', 'autoScale2d'))  %>%
            add_trace(x= LteData_sub()[,"Date"], y=as.numeric(as.character(LteData_sub()[,"Max01"])), name = paste0("High Avg"), mode = 'lines', type = 'scatter', line = list(color = 'red')) %>%
            add_trace(x= LteData_sub()[,"Date"], y=as.numeric(as.character(LteData_sub()[,"Min01"])), name = paste0("Low Avg"), mode = 'lines', type = 'scatter', line = list(color = 'blue')) %>%
            add_trace(x= LteData_sub()[,"Date"], y=as.numeric(as.character(LteData_sub()[,"Max03"])), name = paste0("Wind Gust"), mode = 'lines', type = 'scatter', line = list(color = 'green')) %>%
            layout(title = list(text = "Wind Speed", x = 0.1),  yaxis = list(title = '[ km/h ]'), xaxis = list(type = 'date') )  
      })
      #Wind rose plot
      output$windr_Plot = renderPlot({    #should change to numeric
        if ( (all(is.na(as.numeric(LteData_sub()$"Max01"))) != TRUE) && (all(is.na(as.numeric(LteData_sub()$"Mod04"))) != TRUE) )  {
          if ( (sum(na.omit(as.numeric(LteData_sub()$"Max01"))) > 0) && (sum(na.omit(as.numeric(LteData_sub()$"Mod04"))) > 0) ) {
            windRose(LteData_sub(), ws = na.omit("Max01"), wd = na.omit("Mod04"),  key.footer = "(km/h)", title = 'Wind Rose')   } }
      })  
      #Strains plot
      output$sg_Plot <- renderPlotly({
        Ltecols <- ncol(LteData_sub())
        aux_p <- 1  
        ppp <- plot_ly(source = "zzz")
        for (i in seq(13, Ltecols, by=3)) { 
          lh <- "" #"Avg "
          if (all(is.na(LteData_sub()[,i])) == FALSE) {
            ppp <- add_trace(ppp, x= LteData_sub()[,"Date"], y=as.numeric(as.character(LteData_sub()[,i])), name = paste0(lh , transf_hwid(LteData()[1,i])),
                           mode = 'lines',  type = 'scatter' )
        } } 
        ppp <- config(ppp, displaylogo = FALSE, modeBarButtonsToRemove = c('lasso2d', 'select2d', 'autoScale2d'))         
        ppp <-layout(ppp, title = list(text = "Strain", x = 0.1), yaxis = list(title = '[ \u03BCS ]'), xaxis = list(type = 'date') )  
        ppp
      }) 
      
}


##### Run application ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### ##### #####
shinyApp(ui = ui, server = server)
