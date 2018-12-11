#function: key_summary
#dependent packages:

# library(tidyr)
# library(dplyr)
# library(stringr)
#library(rebus)

#input:
##query: data frame from key_download

#output: creates a table listing each keyword and it's frequency by year

key_summary<- function(data){

Keylist<-data %>%
  select(date,keywords) %>%
  group_by(date) %>%
  filter(!is.na(date)) %>%
  arrange(desc(date))

years<-unique(Keylist$date)
years <- tolower(years[!is.na(years)])

TableTracker<-1
#We need this variable due to the way table joining works.

NamesTracker<-1
#For making our final table



for(i in 1:length(years)){

  if(TableTracker==1){#If the table has not been initialized yet

    Filtered_Keylist<-Keylist %>%
      filter(date==years[i])

    Unlisted <- unlist(Filtered_Keylist$keywords)

    #CleanData
    Unlisted <- tolower(Unlisted[!is.na(Unlisted)])
    Unlisted <- str_replace_all(Unlisted,
                                    pattern = zero_or_more(" ") %R% "-" %R% zero_or_more(" "),
                                    replacement = " ")

    keyword_count_df <- as.data.frame(table(Unlisted[Unlisted!=""]),
                                      stringsAsFactors = FALSE)

    Full_table<-keyword_count_df[order(keyword_count_df$Freq, decreasing = TRUE),]

    if(length(Full_table)>0){

      TableTracker<-0 #Future years will be joined to our now correctly initialized table

      empty<-data.frame(Var1=Full_table[[1,1]],Freq=0, stringsAsFactors = FALSE) # We need this table for if there are no entries in a later year

    }else{
      NamesTracker<-NamesTracker+1 #We'll remove these elements
    }
  }else{#Creation of table beyond first column

    Filtered_Keylist<-Keylist %>%
      filter(date==years[i])

    Unlisted<- unlist(Filtered_Keylist$keywords)

    #CleanData
    Unlisted <- tolower(Unlisted[!is.na(Unlisted)])
    Unlisted <- str_replace_all(Unlisted,
                                pattern = zero_or_more(" ") %R% "-" %R% zero_or_more(" "),
                                replacement = " ")

    keyword_count_df <- as.data.frame(table(Unlisted[Unlisted!=""]),
                                      stringsAsFactors = FALSE)
    To_Join<-keyword_count_df[order(keyword_count_df$Freq, decreasing = TRUE),]


    if(length(To_Join)==0){#if the dataset is empty then we use the empty table created earlier

      TableTracker<-0 #Future years will be joined to our now correctly initialized table

      Full_table <- full_join(Full_table,empty, by = "Var1")

    }else{#If it's not empty add the correctly built table to our current one
      Full_table <- full_join(Full_table,To_Join, by = "Var1")
    }



  }
}


name_list<-c("Keyword")
for(i in NamesTracker:length(years)){

  name_list[length(name_list)+1]<-years[i]}

names(Full_table)<-name_list

Full_table<-Full_table

Full_table<-mutate_if(Full_table,is.numeric, funs(replace(., is.na(.), 0)))

#Add total column

Full_table<-Full_table %>%
  mutate(Total = select(., -Keyword) %>% rowSums()) %>%
  arrange(desc(Total))

return(Full_table)
}
