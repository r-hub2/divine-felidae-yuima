\name{LogSPX}
\alias{LogSPX}
\alias{Data}
\docType{data}
\title{
Five Minutes Log SPX Prices
}
\description{
Intraday five minutes Standard and Poor 500 Log-prices data ranging from 09 july 2012 to 01 april 2015.
}
\usage{data(LogSPX)}
\details{The dataset is composed by a list where the element \code{Data$allObs} contains the intraday five minutes Standard and Poor cumulative Log-return data computed as \code{Log(P_t)-Log(P_0)} and \code{P_0} is the open SPX price at 09 july 2012. \code{Data$logdayprice} contains daily SPX log prices and. Each day we have the same number of observation and the value is reported in \code{Data$obsinday}. 
}

\examples{
data(LogSPX)
}
\keyword{datasets}
