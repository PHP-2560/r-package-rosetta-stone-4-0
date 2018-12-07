# install.packages("rentrez")
# install.packages("stringr")
# install.packages("rvest")
# install.packages("dplyr")

library(rentrez)
library(stringr)
library(rvest)
library(dplyr)
library(rebus)

#example to load
example_load <- as.data.frame(source("example_data/example.txt"), stringsAsFactors = F)[, -6]
names(example_load) <- str_remove(names(example_load), "value.")

example_load <- data

Keylist<-example_load %>%
select(date,keywords) %>%
group_by(date) %>%
filter(!is.na(date)) %>%
arrange(desc(date))

years<-unique(Keylist$date)
years <- tolower(years[!is.na(years)])

TableTracker<-1
#We need this variable due to the way table joining works.  

#TEST CODE
#####################
Filtered_Keylist<-Keylist %>%
  filter(date==years[5])

Unlisted<- unlist(Filtered_Keylist$keywords)

keyword_count_df <- as.data.frame(table(Unlisted[Unlisted!=""]), 
                                  stringsAsFactors = FALSE)  

Full_table<-keyword_count_df[order(keyword_count_df$Freq, decreasing = TRUE),]

if(length(Full_table)==0){
  print("This works")
}

Full_table[[1,1]]

empty<-data.frame(Var1=Full_table[[1,1]],freq=NA)

is.null(integer(0))
Full_table==0


######################


Filtered_Keylist<-Keylist %>%
  filter(date==years[1])

for(i in 1:length(years)){
  
  if(TableTracker=1){
    Unlisted<- unlist(Filtered_Keylist$keywords)
    
    keyword_count_df <- as.data.frame(table(Unlisted[Unlisted!=""]), 
                                      stringsAsFactors = FALSE)  
    
    Full_table<-keyword_count_df[order(keyword_count_df$Freq, decreasing = TRUE),]
  }
  
  
  
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

Full_table<-Full_table
  
Full_table<-mutate_if(Full_table,is.numeric, funs(replace(., is.na(.), 0)))

#Add total column

Full_table<-Full_table %>%
mutate(Total = select(., -Keyword) %>% rowSums()) %>%
arrange(desc(Total))
