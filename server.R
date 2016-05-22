library(shiny) # load shiny package

if (!require("DT")) install.packages('DT') # install package DT if not exist
library(DT) # load package DT 


# create a shiny server
shinyServer(function(input,output){
  
            # identify all packages that has been installed in the local machine
            packagelist <- installed.packages()
            
            # assign the library path in local machine
            libpath <- .libPaths()

            # create a datatable for package list exist in local machine
            output$packagetable  <- DT::renderDataTable(
              datatable(packagelist,rownames = FALSE,  class = 'cell-border stripe')
              
            )  # end of packagetable
  
            # extract names of datasets in the selected apckage
            datasetsinpackage <- reactive({data(package=input$packageID)$results })
  
            # create a datatable for datasets availble in the selected package
            output$datasettable  <- DT::renderDataTable(
                datatable(datasetsinpackage(), colnames = c('Datasets Available' = 'Item'), 
                          class = 'cell-border stripe')
            )  # end of packagetable
  
            # create a dynamic user input if the package contain datasets
            output$vx <- renderUI({
                         selectInput("datasetID", "Select the your Dataset", 
                                     choices =datasetsinpackage()[,3], selected ="")
            }) # end of output$vx 
  
              # loading the selected package and dataset
              myData <- reactive({
                
                # loading the package selected
                library(input$packageID, lib.loc =libpath , character.only = TRUE)
                
                # get the dataset from loaded package
                if (input$datasetID != "") {
                    if (is.null(get(input$datasetID))) {
                        return(NULL)
                    }
                    
                    get(input$datasetID) # getting the data from loaded package
                }
              }) # end of myData
  
              # print the data structure is dataset exist
              output$structure <- renderPrint({
                if (is.null(myData())) {
                        return(NULL)
                }
                       str(myData())
                })

              # print the data summary is dataset exist
              output$summary <- renderPrint({
                if (is.null(myData())) {
                  return(NULL)
                }
            
                summary(myData())
              })
              
              # plot the data if dataset exist
              output$plot <- renderPlot({
                if (is.null(myData())) {
                  return(NULL)
                }
                plot(myData())
              })
              
              observe({
                if(input$exitbutton > 0){
                  stopApp(7)
                }
              })
    
}) # end of shinyserver
  




  

