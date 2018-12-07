library(dplyr)
library(ggplot2)
# install.packages("forcats") #not necessary for this (attempting to sort by count)
#library(forcats)


#example_load <- as.data.frame(source("C:/Users/nmerc/Desktop/PHP 2560 - Intro to R/r-package-rosetta-stone-4-0/example_data/example.txt"), stringsAsFactors = F)[, -8]


#download test file
#all.keywords <- read.csv("C:/Users/nmerc/Desktop/PHP 2560 - Intro to R/week-09-inclass-rosetta-stone-3-0/Sorted_counted_kw_2008-2018.csv") #incorporate csv file or dataframe here

bgraph_key <- function(df, n_values = 10) { #arguments are the sample dataframe (from sum_key) and #values of keywords

  
df %>%
  select(Keyword, Total) %>% #use select to rename Var1 to Keyword and Freq to Total
  #top_n(n_values) %>% #allows user to pick how many values they want to see from our keyword dataframe
  slice(1:n_values) %>% #allows user to pick by number of terms instead of values
    
ggplot(., aes(x = Keyword, y = Total)) + #creates our bar graph using ggplot
  geom_bar(stat = "identity", fill = "#336699") + #stat = identity because values are given
  theme(axis.ticks = element_blank())+
  coord_flip() + #inverts the x and y axis to allow for more keywords to be visible in the bar graph
  theme_minimal() + 
  theme(axis.line = element_line(color = 'black'))
}

bgraph_key(Full_table)
