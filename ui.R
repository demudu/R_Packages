library(shiny)
library(shinydashboard) # you need both packages to run this application

# Define the overall UI

dashboardPage(skin = "purple",

  # Give title to application
  dashboardHeader(title = h4("My R Packages Dashboard")),

  
  # Define the sidebar with inputs 
  dashboardSidebar(
    strong(h4(" About this Dashboard", allign="center")),
    strong(p(h5("This Dashboard is to helps your to list all R Packages currently installed in your system and identify the list of 
      the datasets embedded in the packages for your easy reference.")
    )),
    br(), # create a breakline for seperation
    
    selectInput("packageID", "Select the your Package to check the datasets.", choices =installed.packages()[,1], selected ="stats"),
    br(),
    br(), # create two breaklines for seperation
   
    # dynamic input from server.R
    uiOutput("vx"),
    br(),
    br(),
    br(),
    br(),
    # create an exit button for this application
    column(4, actionButton("exitbutton", "Exit", icon("sign-out") ))
    
    
  ), # end of sidebarpanel
  
  # define main panel input 
  dashboardBody(
    # create tabsets for multiple tabs
    tabsetPanel(
      tabPanel("R Packages in your machine", dataTableOutput("packagetable")),
      tabPanel("Datasets in selected package", dataTableOutput("datasettable")),
    
      tabPanel("Explore Datasets Available",
            # create subset of tabset to explore datasets
            tabsetPanel(
              tabPanel("Data Structure",  verbatimTextOutput("structure")),
              tabPanel("Summary",  verbatimTextOutput("summary")),
              tabPanel("Plot", plotOutput("plot"))
            ) # end of subset tabset
            )
    
    ) # end of main tabset
  ) # end of main panel
    
) # end of UI

