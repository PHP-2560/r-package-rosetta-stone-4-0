\name{key_download}
\alias{key_download}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{key_download
%%  ~~function to do ... ~~
}
\description{
Creates a data frame with the PMID, title, date published, authors, and keywords for the articles matching the query provided.
}
\usage{
key_download(query, full_search = F)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{query}{
%%     ~~Text to be fed into Pubmed search~~
}
  \item{full_search}{
%%     ~~boolean, TRUE will alow more then the default 360 articles to be obtaine~~
}
}
\details{
%%  ~~ ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~~~
}
\note{
%%  ~~~~
}

%% ~ ~

\seealso{
%% ~~ ~~~
}
\examples{
## The function is currently defined as
function (query, full_search = F)
{
    search <- entrez_search(db = "pubmed", term = query, use_history = T)
    max <- ifelse(full_search, search$count, 360)
    results <- c()
    for (seq_start in seq(1, max, 360)) {
        recs <- entrez_summary(db = "pubmed", term = query, retmax = 360,
            retstart = seq_start, web_history = search$web_history)
        results <- c(results, recs)
    }
    filter_esummary <- function(data) {
        c(data$uid, data$title, data$pubdate, paste(data$authors$name,
            collapse = ", "))
    }
    filtered_data <- data.frame(matrix(unlist(lapply(results,
        filter_esummary)), byrow = T, ncol = 4), stringsAsFactors = F)
    names(filtered_data) <- c("uid", "title", "date", "authors")
    filtered_data$date <- as.numeric(str_remove(filtered_data$date,
        "[A-z]+.+"))
    get_keywords <- function(x) {
        url <- paste("https://www.ncbi.nlm.nih.gov/pubmed/",
            x, sep = "")
        results <- read_html(url)
        papers <- html_nodes(results, ".rprt")
        keys_html <- html_nodes(papers, ".keywords")
        keys <- html_text(keys_html) \%>\% str_remove("KEYWORDS: ") \%>\%
            str_split("; ")
        keys
    }
    keywords <- lapply(filtered_data$uid, get_keywords)
    filtered_data$keywords <- keywords
    filtered_data
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
