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

Filtered_Keylist<-Keylist %>%
  filter(date==years[1])

Unlisted<- unlist(Filtered_Keylist$keywords)

keyword_count_df <- as.data.frame(table(Unlisted[Unlisted!=""]), 
                                  stringsAsFactors = FALSE)  
Full_table<-keyword_count_df[order(keyword_count_df$Freq, decreasing = TRUE),]

for(i in 2:length(years)){
  
  Filtered_Keylist<-Keylist %>%
    filter(date==years[i])
  
  Unlisted<- unlist(Filtered_Keylist$keywords)
  
  keyword_count_df <- as.data.frame(table(Unlisted[Unlisted!=""]), 
                                    stringsAsFactors = FALSE)  
  To_Join<-keyword_count_df[order(keyword_count_df$Freq, decreasing = TRUE),]
  
  Full_table <- full_join(Full_table,To_Join, by = "Var1")
}


name_list<-c("Keyword")
for(i in 1:length(years)){
  
name_list[length(name_list)+1]<-years[i]}

names(Full_table)<-name_list

