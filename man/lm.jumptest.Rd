\name{lm.jumptest}
\alias{lm.jumptest}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
%%  ~~function to do ... ~~
Lee and Mykland's Test for the Presence of Jumps Using Normalized Returns
}
\description{
%%  ~~ A concise (1-5 lines) description of what the function does. ~~
Performs a test for the null hypothesis that the realized path has no jump following Lee and Mykland (2008).
}
\usage{
lm.jumptest(yuima, K)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{yuima}{
%%     ~~Describe \code{yuima} here~~
an object of  \code{\link{yuima-class}} or \code{\link{yuima.data-class}}.
}
  \item{K}{
%%     ~~Describe \code{K} here~~
a positive integer indicating the window size to compute local variance estimates. It can be specified as a vector to use different window sizes for different components. The default value is \code{K=pmin(floor(sqrt(252*n)), n)} with \code{n=length(yuima)-1}, following Lee and Mykland (2008) as well as Dumitru and Urga (2012).
}
}

\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
A list with the same length as \code{dim(yuima)}. Each component of the list has class \dQuote{\code{htest}} and contains the following components:
\item{statistic}{the value of the test statistic of the corresponding component of \code{yuima}.}
\item{p.value}{an approximate p-value for the test of the corresponding component.}
\item{method}{the character string \dQuote{\code{Lee and Mykland jump test}}.}
\item{data.name}{the character string \dQuote{\code{xi}}, where \code{i} is the number of the component.}
}
\references{
%% ~put references to the literature/web site here ~
Dumitru, A.-M. and Urga, G. (2012)
  Identifying jumps in financial assets: A comparison between nonparametric jump tests.
  \emph{Journal of Business and Economic Statistics}, \bold{30}, 242--255.
  
Lee, S. S. and Mykland, P. A. (2008)
  Jumps in financial markets: A new nonparametric test and jump dynamics.
  \emph{Review of Financial Studies}, \bold{21}, 2535--2563.
  
Maneesoonthorn, W., Martin, G. M. and Forbes, C. S. (2020)
  High-frequency jump tests: Which test should we use?
  \emph{Journal of Econometrics}, \bold{219}, 478--487.
  
Theodosiou, M. and Zikes, F. (2011)
  A comprehensive comparison of alternative tests for jumps in asset prices. 
  Central Bank of Cyprus Working Paper 2011-2.
}
\author{
%%  ~~who you are~~
Yuta Koike with YUIMA Project Team
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
\code{\link{bns.test}}, \code{\link{minrv.test}}, \code{\link{medrv.test}}, \code{\link{pz.test}}
}
\examples{
set.seed(123)

# One-dimensional case
## Model: dXt=t*dWt+t*dzt, 
## where zt is a compound Poisson process with intensity 5 and jump sizes distribution N(0,1).

model <- setModel(drift=0,diffusion="t",jump.coeff="t",measure.type="CP",
                  measure=list(intensity=5,df=list("dnorm(z,0,sqrt(0.1))")),
                  time.variable="t")

yuima.samp <- setSampling(Terminal = 1, n = 390) 
yuima <- setYuima(model = model, sampling = yuima.samp) 
yuima <- simulate(yuima)
plot(yuima) # The path seems to involve some jumps

lm.jumptest(yuima) # p-value is very small, so the path would have a jump
lm.jumptest(yuima, K = floor(sqrt(390))) # different value of K

# Multi-dimensional case
## Model: Bivariate standard BM + CP
## Only the first component has jumps

mod <- setModel(drift = c(0, 0), diffusion = diag(2),
                jump.coeff = diag(c(1, 0)),
                measure = list(intensity = 5, 
                               df = "dmvnorm(z,c(0,0),diag(2))"),
                jump.variable = c("z"), measure.type=c("CP"),
                solve.variable=c("x1","x2"))

samp <- setSampling(Terminal = 1, n = 390) 
yuima <- setYuima(model = model, sampling = yuima.samp)
yuima <- simulate(object = mod, sampling = samp)
plot(yuima)

lm.jumptest(yuima) # test is performed component-wise
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
\keyword{ts}
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
