Key_table<- function(data){

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

NamesTracker<-1
#For making our final table

keyword_count_df <- as.data.frame(NULL)


for(i in 1:length(years)){
  
  if(TableTracker==1){#If the table has not been initialized yet
    
    Filtered_Keylist<-Keylist %>%
      filter(date==years[i])
    
    Unlisted<- unlist(Filtered_Keylist$keywords)
    
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
    
    keyword_count_df <- as.data.frame(table(Unlisted[Unlisted!=""]), 
                                      stringsAsFactors = FALSE)  
    To_Join<-keyword_count_df[order(keyword_count_df$Freq, decreasing = TRUE),]
    
    
    if(length(To_Join)==0){#if the dataset is empty then we use the empty table created earlier
      
      TableTracker<-0 #Future years will be joined to our now correctly initialized table
      
      Full_table <- full_join(Full_table,empty, by = "Var1")
      
    }else{
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
