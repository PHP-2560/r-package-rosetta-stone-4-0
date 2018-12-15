\name{key_summary}
\alias{key_summary}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{key_summary
%%  ~~function to do ... ~~
}
\description{
Creates a user-friendly table with each of the keywords resulting from the query and lists the count for each by year and the total. It is important to note that the user must run the function key_download() first and save the resulting data frame in order to use key_summary().
}
\usage{
key_summary(data)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{
The output of key_download
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
key_summary(my_data)

For visual print of the above plese see the included vignette
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
