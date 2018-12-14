\name{key_lgraph}
\alias{key_lgraph}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{key_lgraph
%%  ~~function to do ... ~~
}
\description{
key_lgraph() allows the user to efficiently check how keyword trends changed over time by creating line graphs with facets.
}
\usage{
key_lgraph(Full_table, N)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{Full_table}{
The table produced by key_summaey
}
  \item{N}{
In descending order based on frequency, the nuber of keywords you wish to see
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
key_lgraph(climate_table, 6)

For visual print of the above plese see the included vignette
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
