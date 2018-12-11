#function: key_bgraph()
#dependent packages: dplyr, ggplot2

#inputs: 
##df: dataframe from the key_data() function
##n_values: value indicating how many keywords would be included in the bar graph (default value = 10)

#output: ggplot2 bar graph with keywords on the y-axis and total amount in x-axis

#example usage:
##pubmed_graph <- bgraph_key(Full_table, n=15) 

key_bgraph<- function(df, n_values = 10) { #arguments are the sample dataframe (from sum_key) and #values of keywords
  
  df %>%
    select(Keyword, Total) %>% #use select to rename Var1 to Keyword and Freq to Total
    slice(1:n_values) %>% #allows user to pick by number of terms instead of values
    
    ggplot(., aes(x = Keyword, y = Total)) + #creates our bar graph using ggplot
    geom_bar(stat = "identity", fill = "#336699") + #stat = identity because values are given
    theme(axis.ticks = element_blank())+
    coord_flip() + #inverts the x and y axis to allow for more keywords to be visible in the bar graph
    theme_minimal() + 
    theme(axis.line = element_line(color = 'black'))
}