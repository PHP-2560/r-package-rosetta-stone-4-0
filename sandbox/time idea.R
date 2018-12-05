source("functions/obtain_data.R")

time_elapsed <- function(query){
  start <- Sys.time()
  number_articles <- nrow(obtain_data(query))
  end <- Sys.time()
  c(number_articles, end - start)
}

example <- time_elapsed(query = "health")

example[2]* 60 / example[1]
