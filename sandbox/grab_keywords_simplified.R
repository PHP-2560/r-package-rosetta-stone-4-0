library(rentrez)
library(rvest)
library(stringr)

n=50 #Set number of search results wanted
vivax_search <- entrez_search(db = "pubmed",
                              term = "Biostatistics[MeSH Major Topic", retmax=n) #Altered to view biostats

multi_summs <- entrez_summary(db="pubmed", id=vivax_search$ids, retmax=n)

date_and_cite <- extract_from_esummary(multi_summs,"uid") ##CAN GET CITATIONS

get_keywords <- function(x){
  url<-paste("https://www.ncbi.nlm.nih.gov/pubmed/",x, sep="" )
  
  #This body of code grabs the keylist
  results <- read_html(url)
  papers <- html_nodes(results, ".rprt")
  keys_html <- html_nodes(papers, ".keywords")
  
  keys <- html_text(keys_html) %>%
    str_remove("KEYWORDS: ") %>%
    str_split("; ") #Note, fixed for spacing issue
}
keywords <- as.data.frame(table(unlist(lapply(date_and_cite, get_keywords))))
