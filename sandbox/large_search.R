library(rentrez)
library(stringr)
library(rvest)

query <- "(Biostatistics AND Public Health AND Prostate Cancer AND Drug) AND 2015[PDAT]"
search <-entrez_search(db = "pubmed",term = query, use_history = T)
max <- search$count

n = 360
results <- c()
for(seq_start in seq(1,max,n)){
  recs <- entrez_summary(db = "pubmed",
                         term = query, 
                         retmax=n, 
                         retstart=seq_start, 
                         web_history = search$web_history)
  results <- c(results, recs)
}

filter_esummary <- function(data){
  c(data$uid, data$title, data$epubdate, paste(data$authors$name, collapse = ", "))
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

#save data frame
dput(filtered_data, file="example_data/example.txt")

#example to load
example_load <- as.data.frame(source("example_data/example.txt"), stringsAsFactors = F)[, -6]
names(example_load) <- str_remove(names(example_load), "value.")
