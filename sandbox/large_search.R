library(rentrez)


#example of how to iterate through large search
for( seq_start in seq(1,200,50)){
  recs <- entrez_fetch(db="nuccore", web_history=snail_coi$web_history,
                       rettype="fasta", retmax=50, retstart=seq_start)
  cat(recs, file="snail_coi.fasta", append=TRUE)
  cat(seq_start+49, "sequences downloaded\r")
}