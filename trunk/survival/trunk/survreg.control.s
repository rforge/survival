#SCCS  $Id: survreg.control.s,v 4.4 1999-02-21 16:25:06 therneau Exp $
survreg.control <- function(maxiter=30, rel.tolerance=1e-5, failure=1,
			    toler.chol=1e-10, iter.max, debug=0,
			    outer.max = 10) {

    if (missing(iter.max)) {
	iter.max <- maxiter
	}
    else  maxiter <- iter.max
    list(iter.max = iter.max, rel.tolerance = rel.tolerance, 
	 failure =failure, toler.chol= toler.chol, debug=debug,
	 maxiter=maxiter, outer.max=outer.max)
    }
