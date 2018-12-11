#function: key_lgraph
#dependent packages:

# library(ggplot2)
# library(tidyr)
# library(dplyr)





# n is the number of top keywords for which we want to see trends
key_lgraph <- function(all.keywords, n=10) {

  first_year <- names(all.keywords)[2] # first year column
  last_year <- names(all.keywords)[ncol(all.keywords)-1] #all year columns except "Total"

  tidy_all.keywords <- all.keywords[1:n,] %>%
    # reshape the dataframe; each year is not an individual variable now
    gather(Year, times_used, first_year:last_year) %>%
    # select only the columns we need to build a graph
    select(Keyword, Year, times_used) %>%
    # change NAs to zeros
    mutate_if(is.numeric, funs(replace(., is.na(.), 0)))

  ggplot(tidy_all.keywords, aes(x = gsub("[^0-9\\.]", "", Year), y = times_used, group=1, col=Keyword)) +
    xlab("Year") +
    ylab("Times used") +
    # make facets by keyword
    facet_wrap(~Keyword) +
    geom_line(size = 1.5, show.legend = FALSE) +
    # make y axis labels only integers
    scale_y_discrete(limits=c(0:max(tidy_all.keywords$times_used))) +
    # prevent x axis labels overlapping
    theme(axis.text.x =
            element_text(size  = 9,
                         angle = 90,
                         hjust = 0.5,
                         vjust = 0.5))
}

#lgraph_key(read.csv("Data/Total_Keywords.csv", stringsAsFactors = F))
