\encoding{UTF-8}
\name{rng}
\alias{rng}
\alias{rIG}
\alias{dIG}
\alias{rNIG}
\alias{dNIG}
\alias{rbgamma}
\alias{dbgamma}
\alias{rvgamma}
\alias{dvgamma}
\alias{rGIG}
\alias{dGIG}
\alias{rGH}
\alias{dGH}
\alias{rstable}
\alias{rpts}
\alias{rnts}

\title{Random Numbers and Densities}
\description{\code{simulate} function can use the specific random number generators to generate Levy paths.}
\usage{
rGIG(x,lambda,delta,gamma)
dGIG(x,lambda,delta,gamma)
rGH(x,lambda,alpha,beta,delta,mu,Lambda)
dGH(x,lambda,alpha,beta,delta,mu,Lambda)
rIG(x,delta,gamma)
dIG(x,delta,gamma)
rNIG(x,alpha,beta,delta,mu,Lambda)
dNIG(x,alpha,beta,delta,mu,Lambda)
rvgamma(x,lambda,alpha,beta,mu,Lambda)
dvgamma(x,lambda,alpha,beta,mu,Lambda)
rbgamma(x,delta.plus,gamma.plus,delta.minus,gamma.minus)
dbgamma(x,delta.plus,gamma.plus,delta.minus,gamma.minus)
rstable(x,alpha,beta,sigma,gamma)
rpts(x,alpha,a,b)
rnts(x,alpha,a,b,beta,mu,Lambda)
}
\arguments{
  \item{x}{Number of R.Ns to be geneated.}
  \item{a}{parameter}
  \item{b}{parameter}
  \item{delta}{parameter written as \eqn{\delta} below}
  \item{gamma}{parameter written as \eqn{\gamma} below}
  \item{mu}{parameter written as \eqn{\mu} below}
  \item{Lambda}{parameter written as \eqn{\Lambda} below}
  \item{alpha}{parameter written as \eqn{\alpha} below}
  \item{lambda}{parameter written as \eqn{\lambda} below}
  \item{sigma}{parameter written as \eqn{\sigma} below}
  \item{beta}{parameter written as \eqn{\beta} below}
  \item{delta.plus}{parameter written as \eqn{\delta_+} below}
  \item{gamma.plus}{parameter written as \eqn{\gamma_+} below}
  \item{delta.minus}{parameter written as \eqn{\delta_-} below}
  \item{gamma.minus}{parameter written as \eqn{\gamma_-} below}

  % \item{IG (inverse Gaussian)}{delta and gamma are positive valued parameter.}
  % \item{NIG (normal inverse Gaussian)}{alpha and delta are nonnegative number, beta and mu are vector and Lambda is matrix.}
  % \item{bgamma (bilateral gamma)}{All of parameters are positive number.}
  % \item{vgamma (variance gamma)}{lamdba and alpha are positive number, beta and mu are vector and Lambda is matrix.}
  % \item{stable}{Stable index 0<alpha<=2; Skewness -1<=beta<=1; Scale sigma>0; Location gamma being a real number.}
}


\details{

\code{GIG} (generalized inverse Gaussian): 
The density function of GIG distribution is expressed as:

\eqn{f(x)= 1/2*(\gamma/\delta)^\lambda*1/bK_\lambda(\gamma*\delta)*x^(\lambda-1)*exp(-1/2*(\delta^2/x+\gamma^2*x))}

where \eqn{bK_\lambda()} is the modified Bessel function of the third kind with order lambda.
The parameters \eqn{\lambda, \delta} and \eqn{\gamma} vary within the following regions:

\eqn{\delta>=0, \gamma>0} if \eqn{\lambda>0},

\eqn{\delta>0, \gamma>0} if \eqn{\lambda=0},

\eqn{\delta>0, \gamma>=0} if \eqn{\lambda<0}.

The corresponding Levy measure is given in Eberlein, E., & Hammerstein, E. A. V. (2004) (it contains IG).

\code{GH} (generalized hyperbolic): Generalized hyperbolic distribution is defined by the normal mean-variance mixture of generalized inverse Gaussian distribution. The parameters \eqn{\alpha, \beta, \delta, \mu} express heaviness of tails, degree of asymmetry, scale and location, respectively. Here the parameter \eqn{\Lambda} is supposed to be symmetric and positive definite with \eqn{det(\Lambda)=1} and the parameters vary within the following region:

\eqn{\delta>=0, \alpha>0, \alpha^2>\beta^T \Lambda \beta} if \eqn{\lambda>0},

\eqn{\delta>0, \alpha>0, \alpha^2>\beta^T \Lambda \beta} if \eqn{\lambda=0},

\eqn{\delta>0, \alpha>=0, \alpha^2>=\beta^T \Lambda \beta} if \eqn{\lambda<0}.

The corresponding Levy measure is given in Eberlein, E., & Hammerstein, E. A. V. (2004) (it contains NIG and vgamma).


\code{IG} (inverse Gaussian (the element of GIG)): \eqn{\Delta} and \eqn{\gamma} are positive (the case of \eqn{\gamma=0} corresponds to the positive half stable, provided by the "rstable").

\code{NIG} (normal inverse Gaussian (the element of GH)): Normal inverse Gaussian distribution is defined by the normal mean-variance mixuture of inverse Gaussian distribution. The parameters \eqn{\alpha, \beta, \delta} and \eqn{\mu} express the heaviness of tails, degree of asymmetry, scale and location, respectively. They satisfy the following conditions:
\eqn{\Lambda} is symmetric and positive definite with \eqn{det(\Lambda)=1; \delta>0; \alpha>0} with \eqn{\alpha^2-\beta^T \Lambda \beta >0}.

\code{vgamma} (variance gamma (the element of GH)): Variance gamma distribution is defined by the normal mean-variance mixture of gamma distribution. The parameters satisfy the following conditions:
Lambda is symmetric and positive definite with \eqn{det(\Lambda)=1; \lambda>0; \alpha>0} with \eqn{\alpha^2-\beta^T \Lambda \beta >0}. Especially in the case of \eqn{\beta=0} it is variance gamma distribution.

\code{bgamma} (bilateral gamma): Bilateral gamma distribution is defined by the difference of independent gamma distributions \eqn{Gamma(\delta_+,\gamma_+) and Gamma(\delta_-,\gamma_-)}. Its Levy density \eqn{f(z)} is given by: 
\eqn{f(z)=\delta_+/z*exp(-\gamma_+*z)*ind(z>0)+\delta_-/|z|*exp(-\gamma_-*|z|)*ind(z<0)}, where the function \eqn{ind()} denotes an indicator function.

\code{stable} (stable): Parameters \eqn{\alpha, \beta, \sigma} and \eqn{\gamma} express stability, degree of skewness, scale and location, respectively. They satisfy the following condition: \eqn{0<\alpha<=2; -1<=\beta<=1; \sigma>0; \gamma} is a real number.

\code{pts} (positive tempered stable): Positive tempered stable distribution is defined by the tilting of positive stable distribution. The parameters \eqn{\alpha, a} and \eqn{b} express stability, scale and degree of tilting, respectively. They satisfy the following condition: \eqn{0<\alpha<1; a>0; b>0}. Its Levy density \eqn{f(z)} is given by: \eqn{f(z)=az^(-1-\alpha)exp(-bz)}.

\code{nts} (normal tempered stable): Normal tempered stable distribution is defined by the normal mean-variance mixture of positive tempered stable distribution. The parameters \eqn{\alpha, a, b, \beta, \mu} and \eqn{\Lambda} express stability, scale, degree of tilting, degree of asymmemtry, location and degree of mixture, respectively. They satisfy the following condition: Lambda is symmetric and positive definite with \eqn{det(\Lambda)=1; 0<\alpha<1; a>0; b>0}. 
In one-dimensional case, its Levy density \eqn{f(z)} is given by: 
\eqn{f(z)=2a/(2\pi)^(1/2)*\exp(\beta*z)*(z^2/(2b+\beta^2))^(-\alpha/2-1/4)*bK_(\alpha+1/2)(z^2(2b+\beta^2)^(1/2))}.

}

\value{
\item{rXXX}{Collection of of random numbers or vectors}
\item{dXXX}{Density function}
}

\author{The YUIMA Project Team

Contacts: Hiroki Masuda \email{hmasuda@ms.u-tokyo.ac.jp} and Yuma Uehara \email{y-uehara@kansai-u.ac.jp}
}
\note{
  Some density-plot functions are still missing: as for the non-Gaussian stable densities, one can use, e.g., stabledist package.
  The rejection-acceptance method is used for generating pts and nts. It should be noted that its acceptance rate decreases at exponential order as \eqn{a} and \eqn{b} become larger: specifically, the rate is given by \eqn{exp(a*\Gamma(-\alpha)*b^(\alpha))}
}

\references{

## rGIG, dGIG, rIG, dIG

Chhikara, R. (1988). The Inverse Gaussian Distribution: Theory: Methodology, and Applications (Vol. 95). CRC Press.

Hormann, W., & Leydold, J. (2014). Generating generalized inverse Gaussian random variates. Statistics and Computing, 24(4), 547-557.
\doi{10.1111/1467-9469.00045}

Jorgensen, B. (2012). Statistical properties of the generalized inverse Gaussian distribution (Vol. 9). Springer Science & Business Media.
\href{https://link.springer.com/book/10.1007/978-1-4612-5698-4}{https://link.springer.com/book/10.1007/978-1-4612-5698-4}

Michael, J. R., Schucany, W. R., & Haas, R. W. (1976). Generating random variates using transformations with multiple roots. The American Statistician, 30(2), 88-90.
\doi{10.1080/00031305.1976.10479147}

## rGH, dGH, rNIG, dNIG, rvgamma, dvgamma

Barndorff-Nielsen, O. (1977). Exponentially decreasing distributions for the logarithm of particle size. In Proceedings of the Royal Society of London A: Mathematical, Physical and Engineering Sciences (Vol. 353, No. 1674, pp. 401-419). The Royal Society.
\doi{10.1098/rspa.1977.0041}

Barndorff-Nielsen, O. E. (1997). Processes of normal inverse Gaussian type. Finance and stochastics, 2(1), 41-68.
\doi{10.1007/s007800050032}

Eberlein, E. (2001). Application of generalized hyperbolic \enc{Levy}{Levy} motions to finance. In \enc{Levy}{Levy} processes (pp. 319-336). \enc{Birkhauser}{Birkhauser} Boston.
\doi{10.1007/978-1-4612-0197-7_14}

Eberlein, E., & Hammerstein, E. A. V. (2004). Generalized hyperbolic and inverse Gaussian distributions: limiting cases and approximation of processes. In Seminar on stochastic analysis, random fields and applications IV (pp. 221-264). Birkh??user Basel.
\doi{10.1007/978-1-4612-0197-7_14}

Madan, D. B., Carr, P. P., & Chang, E. C. (1998). The variance gamma process and option pricing. European finance review, 2(1), 79-105.
\doi{10.1111/1467-9469.00045}

## rbgamma, dbgamma

\enc{Kuchler}{Kuchler}, U., & Tappe, S. (2008). Bilateral Gamma distributions and processes in financial mathematics. Stochastic Processes and their Applications, 118(2), 261-283.
\doi{10.1016/j.spa.2007.04.006}

\enc{Kuchler}{Kuchler}, U., & Tappe, S. (2008). On the shapes of bilateral Gamma densities. Statistics & Probability Letters, 78(15), 2478-2484.
\doi{10.1016/j.spa.2007.04.006}

## rstable

Chambers, John M., Colin L. Mallows, and B. W. Stuck.  (1976) A method for simulating stable random variables, Journal of the american statistical association, 71(354), 340-344.
\doi{10.1080/01621459.1976.10480344}

Weron, \enc{Rafal}{Rafal}. (1996) On the Chambers-Mallows-Stuck method for simulating skewed stable random variables, Statistics & probability letters, 28.2, 165-171.
\doi{10.1016/0167-7152(95)00113-1}

Weron, \enc{Rafal}{Rafal}. (2010) Correction to:" On the Chambers-Mallows-Stuck Method for Simulating Skewed Stable Random Variables", No. 20761, University Library of Munich, Germany.
\href{https://ideas.repec.org/p/pra/mprapa/20761.html}{https://ideas.repec.org/p/pra/mprapa/20761.html}

## rpts

Kawai, R., & Masuda, H. (2011). On simulation of tempered stable random variates. Journal of Computational and Applied Mathematics, 235(8), 2873-2887.
\doi{10.1016/j.cam.2010.12.014}

## rnts

Barndorff-Nielsen, O. E., & Shephard, N. (2001). Normal modified stable processes. Aarhus: MaPhySto, Department of Mathematical Sciences, University of Aarhus.

}

\examples{
\dontrun{
set.seed(123)

# Ex 1. (One-dimensional standard Cauchy distribution)
# The value of parameters is alpha=1,beta=0,sigma=1,gamma=0.
# Choose the values of x.
x<-10 # the number of r.n
rstable(x,1,0,1,0)

# Ex 2. (One-dimensional Levy distribution)
# Choose the values of sigma, gamma, x.
# alpha = 0.5, beta=1
x<-10 # the number of r.n
beta <- 1
sigma <- 0.1
gamma <- 0.1
rstable(x,0.5,beta,sigma,gamma)

# Ex 3. (Symmetric bilateral gamma)
# delta=delta.plus=delta.minus, gamma=gamma.plus=gamma.minus.
# Choose the values of delta and gamma and x.
x<-10 # the number of r.n
rbgamma(x,1,1,1,1)

# Ex 4. ((Possibly skewed) variance gamma)
# lambda, alpha, beta, mu
# Choose the values of lambda, alpha, beta, mu and x.
x<-10 # the number of r.n
rvgamma(x,2,1,-0.5,0)

# Ex 5. (One-dimensional normal inverse Gaussian distribution)
# Lambda=1.
# Choose the parameter values and x.
x<-10 # the number of r.n
rNIG(x,1,1,1,1)

# Ex 6. (Multi-dimensional normal inverse Gaussian distribution)
# Choose the parameter values and x.
beta<-c(.5,.5)
mu<-c(0,0)
Lambda<-matrix(c(1,0,0,1),2,2)
x<-10 # the number of r.n
rNIG(x,1,beta,1,mu,Lambda)

# Ex 7. (Positive tempered stable)
# Choose the parameter values and x.
alpha<-0.7
a<-0.2
b<-1
x<-10 # the number of r.n
rpts(x,alpha,a,b)

# Ex 8. (Generarized inverse Gaussian)
# Choose the parameter values and x.
lambda<-0.3
delta<-1
gamma<-0.5
x<-10 # the number of r.n
rGIG(x,lambda,delta,gamma)

# Ex 9. (Multi-variate generalized hyperbolic)
# Choose the parameter values and x.
lambda<-0.4
alpha<-1
beta<-c(0,0.5)
delta<-1
mu<-c(0,0)
Lambda<-matrix(c(1,0,0,1),2,2)
x<-10 # the number of r.n
rGH(x,lambda,alpha,beta,delta,mu,Lambda)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ts}
