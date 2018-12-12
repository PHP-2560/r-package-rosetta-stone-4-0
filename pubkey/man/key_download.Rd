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
     ~~Text to be fed into Pubmed search~~
}
  \item{full_search}{
     ~~boolean, TRUE will allow more then the default 360 articles to be obtained~~
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
my_data <- key_download("public health AND climate change AND survival AND 2000:2010[PDAT]", full_search = T)

~~This will search on pubmed for "public health AND climate change AND survival AND 2000:2010[PDAT]", please note that full_search is defined here as true, so our search limit of 360 will be broken and all articles returned.  For a sample of this query please see the pubkey vignette.~~

