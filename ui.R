#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

shinyUI(fluidPage(
  
  title = "Species accumulation curve",
  h1("Species accumulation curve"),
  plotOutput("distPlot"),
  
  hr(),
  
  fluidRow(
    column(8,
           h4("Real time data analysis"),
           p("Suppose we are interested in investigating the animal diversity of a particular location. An appropriate data infrastructure enables continuous exploration of the collected data. In this simple example, it's easy to determine when enough sites have been sampled and an adequate biodiversity estimate has been obtained. All without repeated analysis or extra resources. Usually the more expensive the data collection, the more complex the data analysis, or the more urgent the research answer, the more savings can be made by setting up a data infrastructure with automated reports/analysis."),
           p("The graph shows the mean species accumulation curves for a certain number of sampled sites vs random permutations of the data."),
           p("Data for this example can be freely entered in ", strong(a("this", href = "https://ee.kobotoolbox.org/x/#YCb8")), "form. Observation data is based on a subset of observations by", a("Pyke et al. (2001)", href = "http://www.sciencemag.org/cgi/content/full/295/5555/666/DC1"), "in which species names have been modified for simplicity.")
    ),
    # column(4, offset = 1,
    #        "more description"
    # ),
    column(4,
           tableOutput("spp_acc_curve")
    )
  )
))

# # Define UI for application that draws a histogram
# shinyUI(fluidPage(
#   
#   # Application title
#   titlePanel("Speccies accumulation curve"),
#   
#   
#   
#   # Sidebar with a slider input for number of bins 
#   sidebarLayout(
#     sidebarPanel(
#       "asdasd asd asd asd",
#       
#     ),
#     
#     # Show a plot of the generated distribution
#     mainPanel(
#        plotOutput("distPlot")
#     )
#   )
# ))
