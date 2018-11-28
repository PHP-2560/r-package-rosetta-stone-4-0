library(stringr)
library(rebus)

#download our dataset, extract list of keywords
data_df <- read.csv("C:/Users/KR/Desktop/R/week-09-inclass-rosetta-stone-3-0/data-biost-2018.csv",
                    stringsAsFactors = FALSE)
keyword_list <- data_df[["keywords"]]


# tidy list: delete NAs, all letters to lowercase, all hyphens to SPC
keyword_list <- tolower(keyword_list[!is.na(keyword_list)])
keyword_list <- str_replace_all(keyword_list, 
                                pattern = zero_or_more(" ") %R% "-" %R% zero_or_more(" "), 
                                replacement = " ")

# create a dataframe of keywords, splitting strings by ";" or ","
# use stringr and rebus
keyword_df <- str_split(keyword_list, 
                        pattern = or(";", ",") %R% zero_or_more(" "), 
                        simplify = TRUE)

# count frequency of each word, excluding empty strings
keyword_count_df <- as.data.frame(table(keyword_df[keyword_df!=""]), 
                                  stringsAsFactors = FALSE)

# sort the table by decreasing Freq
keyword_count_df <- keyword_count_df[order(keyword_count_df$Freq, decreasing = TRUE),]



