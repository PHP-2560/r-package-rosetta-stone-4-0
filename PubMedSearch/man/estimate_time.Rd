\name{estimate_time}
\alias{estimate_time}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{test
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
estimate_time(query)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{query}{
%%     ~~Describe \code{query} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
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
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (query)
{
    count <- entrez_search(db = "pubmed", term = query)$count
    hours <- count * 0.7464883/60
    print_message <- paste("Search returned", count, "articles. We estimate that your download will take approximatley",
        as.character(round(hours)), "minutes to complete.")
    if (hours > 30) {
        print_message <- paste(print_message, "Please consider using the advanced search option at https://www.ncbi.nlm.nih.gov/pubmed/advanced to create a more concise search.")
    }
    print(print_message)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
