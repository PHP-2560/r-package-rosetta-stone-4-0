#function: key_download
#dependent packages: rentrez, stringr, rvest

#inputs:
##query: Character string for pubmed query
##full_search: Logical value indicating if obtain_data should obtain data for all results (T) or the first 360 (F)

#output: Dataframe containing uid, title, data published, authors, and keywords for articles matching the query provided

#example usage:
#query <- "(Biostatistics AND Public Health AND Prostate Cancer AND Drug) AND 2015[PDAT]"
#data <- obtain_data(query)

key_download <- function(query, full_search = F){
  search <- entrez_search(db = "pubmed",term = query, use_history = T)
  max <- ifelse(full_search, search$count, 360)

  results <- c()
  for(seq_start in seq(1,max,360)){
    recs <- entrez_summary(db = "pubmed",
                           term = query,
                           retmax=360,
                           retstart=seq_start - 1,
                           web_history = search$web_history,
                           always_return_list = T)
    results <- c(results, recs)
  }

  filter_esummary <- function(data){
    c(data$uid, data$title, data$pubdate, paste(data$authors$name, collapse = ", "))
  }

  filtered_data <- data.frame(matrix(unlist(lapply(results, filter_esummary)), byrow = T, ncol = 4), stringsAsFactors = F)
  names(filtered_data) <- c("uid", "title", "date", "authors")
  filtered_data$date <- as.numeric(str_remove(filtered_data$date, "[A-z]+.+"))

  get_keywords <- function(x){
    url<-paste("https://www.ncbi.nlm.nih.gov/pubmed/",x, sep="" )

    #This body of code grabs the keylist
    results <- read_html(url)
    papers <- html_nodes(results, ".rprt")
    keys_html <- html_nodes(papers, ".keywords")

    keys <- html_text(keys_html) %>%
      str_remove("KEYWORDS: ") %>%
      str_split("; ") #Note, fixed for spacing issue
    keys
  }

  keywords <- lapply(filtered_data$uid, get_keywords)

  filtered_data$keywords <- keywords
  filtered_data
}
