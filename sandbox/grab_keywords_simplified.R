library(rentrez)
library(rvest)
library(stringr)

#Make sure to change your working directory to go to the Data file, 
#Use getwd and add "/Data"
setwd("C:/Users/Frank/Desktop/Git Work/In-Class work/Final Project/r-package-rosetta-stone-4-0/Data")

#Simplified way to grab keywords of all articles from a given pubmed

#NOTE: I had a 2014 search with no hits, I got a error message but we need to make the break or make an empty file casue it just used the save 2015 data

#Note from Frank: Included search variable 
term <- "Biostatistics[MeSH Term] AND epidemic"
year<-2016
search <-paste(term, "AND (", year, "[PDAT])")

n=10000 #Set number of search results wanted
vivax_search <- entrez_search(db = "pubmed",
                              term = search, retmax=n) #Altered to view biostats

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
          str_split("; ")#Note from Frank: Fixed to include space
}

keywords <- as.data.frame(table(unlist(lapply(date_and_cite, get_keywords))))
write.csv(keywords, file = paste("Keywords_",search,".csv",sep=""))#Note from Frank: Included file output for table merge
