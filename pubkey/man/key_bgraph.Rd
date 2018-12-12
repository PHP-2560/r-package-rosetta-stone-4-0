\name{key_bgraph}
\alias{key_bgraph}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{key_bgraph
%%  ~~function to do ... ~~
}
\description{
Returns a bar graph of the top n keywords from a previous query, where n is provided by the users
}
\usage{
bgraph_key(df, n_values = 10)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{df}{
This is the data frame output of key_summary
}
  \item{n_values}{
This is the number of unique keywords the user wants to view, the default value is
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
function (df, n_values = 10)
{
    df \%>\% select(Keyword, Total) \%>\% slice(1:n_values) \%>\% ggplot(.,
        aes(x = Keyword, y = Total)) + geom_bar(stat = "identity",
        fill = "#336699") + theme(axis.ticks = element_blank()) +
        coord_flip() + theme_minimal() + theme(axis.line = element_line(color = "black"))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
