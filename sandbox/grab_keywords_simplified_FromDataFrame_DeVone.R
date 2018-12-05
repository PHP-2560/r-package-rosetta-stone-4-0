# install.packages("rentrez")
# install.packages("stringr")
# install.packages("rvest")
# install.packages("dplyr")

library(rentrez)
library(stringr)
library(rvest)
library(dplyr)

#example to load
example_load <- as.data.frame(source("example_data/example.txt"), stringsAsFactors = F)[, -6]
names(example_load) <- str_remove(names(example_load), "value.")

Keylist<-example_load %>%
select(date,keywords) %>%
group_by(date)

years<-unique(Keylist$date)
years <- tolower(years[!is.na(years)])

for(i in 1:length(years)){
print(years[i])
  
Filtered_Keylist<-Keylist %>%
filter(date==years[i]) %>%
select(keywords)
  
assign(paste("Keywords_",years[i], sep = ""),Filtered_Keylist)
  
}

Unlisted<-unlist(paste("Keywords_",years[1], sep = ""))
keyword_count_df <- as.data.frame(table(Unlisted[Unlisted!=""]), 
                                  stringsAsFactors = FALSE)  
Full_table<-keyword_count_df[order(keyword_count_df$Freq, decreasing = TRUE),]

for(i in 2:length(years)){

#assign(paste("Unlisted_Keywords_",years[i], sep = ""),unlist(paste("Keywords_",years[i], sep = "")))
assign(paste(Unlisted,years[i], sep = ""),unlist(paste("Keywords_",years[i], sep = "")))

keyword_count_df <- as.data.frame(table(Unlisted[Unlisted!=""]), 
                                    stringsAsFactors = FALSE)  

keyword_table_year <- keyword_count_df[order(keyword_count_df$Freq, decreasing = TRUE),]

}





















# count frequency of each word, excluding empty strings


# sort the table by decreasing Freq
keyword_count_df <- keyword_count_df[order(keyword_count_df$Freq, decreasing = TRUE),]


#Simplified way to grab keywords of all articles from a given pubmed

#NOTE: I had a 2014 search with no hits, I got a error message but we need to make the break or make an empty file casue it just used the save 2015 data

#Note from Frank: Included search variable 
term <- "Biostatistics[MeSH Term] AND sugar"
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
write.csv(keywords, file = paste("Data/Keywords_",search,".csv",sep=""))#Note from Frank: Included file output for table merge
