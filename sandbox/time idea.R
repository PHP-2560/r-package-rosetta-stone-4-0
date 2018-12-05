source("functions/obtain_data.R")

time_elapsed <- function(query){
  start <- sys.time()
  obtain_data(query)
  end <- sys.time()
  end - stard
}