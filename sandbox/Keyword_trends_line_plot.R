library(ggplot2)
library(tidyr)
library(dplyr)

all.keywords <- read.csv("Total_Keywords.csv", stringsAsFactors = F)

first_year <- names(all.keywords)[4]
last_year <- names(all.keywords)[ncol(all.keywords)]

tidy_all.keywords <- all.keywords %>% 
  # reshape the dataframe; each year is not an individual variable now
  gather(Year, times_used, first_year:last_year) %>%                   
  # select only the columns we need to build a graph
  select(Keyword, Year, times_used) %>%   
  # change NAs to zeros
  mutate_if(is.numeric, funs(replace(., is.na(.), 0)))  
  
ggplot(tidy_all.keywords, aes(x = Year, y = times_used, group=1, col=Keyword)) + 
  # make facets by keyword  
  facet_wrap(~Keyword) +
  geom_line(size = 1.5, show.legend = FALSE) +
  # make y axis labels only integers
  scale_y_discrete(limits=c(0:max(tidy_all.keywords$times_used))) + 
  # prevent x axis labels overlapping
  theme(axis.text.x =
          element_text(size  = 10,
                       angle = 45,
                       hjust = 1,
                       vjust = 1))


