#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(dplyr)
library(foreach)

ext_top_data <- function(d, field) {
  d <- lapply(d, function(x) x[[field]])
  d <- unlist(d)
  d <- trimws(d)
  tolower(d)
}

null2na <- function(x){
  if(is.null(x)) NA
  else x
}

community_df <- function(x){
  x <- x[, c("group_kl9eo56", "Site", "_submission_time")]
  xx <- list(0, 0)
  xx <- foreach (i =  1:nrow(x), .combine = rbind) %do% {
    data.frame(sp = null2na(unlist(x[i, 1])), 
               site = null2na(unlist(x[i, 2])),
               time = null2na(unlist(x[i, 3])))
  }
  mutate(xx, time = as.POSIXct(time, "%Y-%m-%dT%H:%M:%S", tz = "GMT"),
         sp = as.character(sp),
         site = as.character(site),
         present = 1) %>%
    filter(time > as.POSIXct("2017-07-20"))
}

community_tb <- function(x){
  xx <- community_df(x)
  xx <- reshape2::acast(xx, site ~ sp, fill = 0, value.var = "present")
  # is.na(xx)
  xx
}

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {

  data <- reactivePoll(5000, session,
    checkFunc = function(){
      form_metadata <- httr::GET("https://kc.kobotoolbox.org/api/v1/forms/143769",
                                 httr::authenticate("efcaguab", "DQe1csPKT14!"))
      form_metadata <- httr::content(form_metadata)
      form_metadata$date_modified
    },
    valueFunc = function(){
      d <- httr::GET("https://kc.kobotoolbox.org/api/v1/data/143769",
                     httr::authenticate("efcaguab", "DQe1csPKT14!"))
      d <- httr::content(d)
      d <- jsonlite::toJSON(d)
      # saveRDS(jsonlite::fromJSON(d), "polldata.rds")
      jsonlite::fromJSON(d)
    }
  )
  
  # data <- reactiveFileReader(1000, session, "polldata.rds", readRDS)


  output$spp_acc_curve <- renderTable({
    # data_file() # Download new data
    community_df(data()) %>%
      group_by(sp) %>%
      summarise(frequency = n_distinct(site)) %>%
      arrange(desc(frequency))
  })
   
  output$distPlot <- renderPlot({
    # data_file()
    # x <- community_tb(data())
    speac <- try(vegan::specaccum(community_tb(data()), "random"), silent = T)
    if(class(speac)=="try-error"){
      plot.new()
    }else{
      plot(speac, ci.type="poly", col="blue", lwd=2, ci.lty=0, ci.col="lightblue")
      boxplot(speac, col="yellow", add=TRUE, pch="+")       
    }
    # x
  })
  
})
