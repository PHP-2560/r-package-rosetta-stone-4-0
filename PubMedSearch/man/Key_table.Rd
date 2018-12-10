\name{Key_table}
\alias{Key_table}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{test
%%  ~~function to do ... ~~
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
}
\usage{
Key_table(data)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{data}{
%%     ~~Describe \code{data} here~~
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
function (data)
{
    Keylist <- data \%>\% select(date, keywords) \%>\% group_by(date) \%>\%
        filter(!is.na(date)) \%>\% arrange(desc(date))
    years <- unique(Keylist$date)
    years <- tolower(years[!is.na(years)])
    TableTracker <- 1
    NamesTracker <- 1
    for (i in 1:length(years)) {
        if (TableTracker == 1) {
            Filtered_Keylist <- Keylist \%>\% filter(date == years[i])
            Unlisted <- unlist(Filtered_Keylist$keywords)
            keyword_count_df <- as.data.frame(table(Unlisted[Unlisted !=
                ""]), stringsAsFactors = FALSE)
            Full_table <- keyword_count_df[order(keyword_count_df$Freq,
                decreasing = TRUE), ]
            if (length(Full_table) > 0) {
                TableTracker <- 0
                empty <- data.frame(Var1 = Full_table[[1, 1]],
                  Freq = 0, stringsAsFactors = FALSE)
            }
            else {
                NamesTracker <- NamesTracker + 1
            }
        }
        else {
            Filtered_Keylist <- Keylist \%>\% filter(date == years[i])
            Unlisted <- unlist(Filtered_Keylist$keywords)
            keyword_count_df <- as.data.frame(table(Unlisted[Unlisted !=
                ""]), stringsAsFactors = FALSE)
            To_Join <- keyword_count_df[order(keyword_count_df$Freq,
                decreasing = TRUE), ]
            if (length(To_Join) == 0) {
                TableTracker <- 0
                Full_table <- full_join(Full_table, empty, by = "Var1")
            }
            else {
                Full_table <- full_join(Full_table, To_Join,
                  by = "Var1")
            }
        }
    }
    name_list <- c("Keyword")
    for (i in NamesTracker:length(years)) {
        name_list[length(name_list) + 1] <- years[i]
    }
    names(Full_table) <- name_list
    Full_table <- Full_table
    Full_table <- mutate_if(Full_table, is.numeric, funs(replace(.,
        is.na(.), 0)))
    Full_table <- Full_table \%>\% mutate(Total = select(., -Keyword) \%>\%
        rowSums()) \%>\% arrange(desc(Total))
    return(Full_table)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
