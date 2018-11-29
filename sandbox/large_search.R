library(rentrez)

search <-entrez_search(db = "pubmed",term = "(Biostatistics AND Public Health) AND 2015[PDAT]", use_history = T)

n = 360
results <- c()
for(seq_start in seq(1,max,n)){
  recs <- entrez_summary(db = "pubmed",
                         term = "(Biostatistics AND Public Health) AND 2015[PDAT]", 
                         retmax=n, 
                         retstart=seq_start, 
                         web_history = search$web_history)
  results <- c(results, recs)
}
