library(rentrez)
library(stringr)

query <- "(Biostatistics AND Public Health AND HIV) AND 2015[PDAT]"
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
  c(data$title,data$elocationid, data$pubdate, paste(data$authors$name, collapse = ", "), data$pmcrefcount)
}

filtered_data <- data.frame(matrix(unlist(lapply(results, filter_esummary)), byrow = T, ncol = 5), stringsAsFactors = F)
names(filtered_data) <- c("Title", "doi", "date", "authors", "pmc_ref_count")
filtered_data$date <- as.numeric(str_remove(filtered_data$date, "[A-z]+.+"))
