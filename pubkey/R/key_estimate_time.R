#function: key estimate time
#dependent packages: rentrez

#input:
##query: Character string for pubmed query

#output: prints message to screen reporting the number of articles matching the query and estimated time to download

key_estimate_time <- function(query){
  count <- entrez_search(db = "pubmed",term = query)$count
  hours <- count * 0.7464883 / 60
  print_message <- paste("Search returned",count,"articles. We estimate that your download will take approximatley", as.character(round(hours)), "minutes to complete.")
  if (hours > 30){
    print_message <- paste(print_message, "Please consider using the advanced search option at https://www.ncbi.nlm.nih.gov/pubmed/advanced to create a more concise search.")
  }
  print_message
}
