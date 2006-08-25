# $Id: coxph.wtest.s,v 1.3 2006-08-25 21:13:28 m015733 Exp $
#
# A Wald test routine, used by the Cox model
#  Why not just do  sum(b * solve(var, b))? -- because the solve
#  function chokes on singular matrices.
#
coxph.wtest <- function(var, b, toler.chol=1e-9) {
    if (is.matrix(b)) {
        nvar <- nrow(b)
        ntest<- ncol(b)
        }
    else {
        nvar <- length(b)
        ntest<- 1
        }
    
    if (length(var)==1) {
        if (nvar ==1) return(list(test=b*b/var, df=1, solve=b/var))
        else stop("Argument lengths do not match")
        }

    if (!is.matrix(var) || (nrow(var) != ncol(var)))
            stop("First argument must be a square matrix")
    if (nrow(var) != nvar) stop("Argument lengths do not match")

    temp <- .C('coxph_wtest', df=as.integer(nvar),
                              as.integer(ntest),
                              as.double(var),
                              tests= as.double(b),
                              solve= double(nvar*ntest),
	                      as.double(toler.chol))
    if (ntest==1) list(test=temp$tests[1], df=temp$df, solve=temp$solve)
    else          list(test=temp$tests[1:ntest], df=temp$df, 
                       solve=matrix(temp$solve, nvar, ntest))
    }
