# SCCS $Id: survexp.cfit.s,v 4.1 1994-04-08 15:58:05 therneau Exp $
#
#  Do expected survival based on a Cox model
#   A fair bit of the setup work is identical to survfit.coxph, i.e.,
#     to reconstruct the data frame
#
survexp.cfit <- function(x, y, death, cox, se.fit, method) {
    if (!is.matrix(x)) stop("x must be a matrix")

    temp <- coxph.getdata(cox, y=T, x=se.fit, strata=F)
    cy <- temp$y
    cx <- temp$x
    cn <- nrow(cy)
    nvar <- length(cox$coef)

    if (ncol(x) != (1+ nvar))
	stop("x matrix does not match the cox fit")

    ngrp <- max(x[,1])
    if (!is.logical(death)) stop("Invalid value for death indicator")

    if (missing(method))
	method <- (1 + 1*(cox$method=='breslow') +2*(cox$method=='efron')
		     + 10*(death))
    else stop("Program unfinished")

    #
    # Data appears ok so proceed
    #  First sort the old data set
    # Also, expand y to (start, stop] form.  This leads to slower processing,
    #  but I only have to program one case instead of 2.
    if (ncol(cy) ==2) cy <- cbind(0, cy)
    ord <- order(cy[,2], -cy[,3])
    cy  <- cy[ord,]
    score <- exp(cox$linear.predictors[ord])
    if (se.fit) cx <- cx[ord,]
    else  cx <- 0   #dummy, for .C call


    #
    # Process the new data
    #
    if (missing(y) || is.null(y)) y <- rep(max(cy[,2]), nrow(x))
    ord <- order(x[,1])
    x[,1] <- x[,1] - min(x[,1])
    n <- nrow(x)
    ncurve <- length(unique(x[,1]))
    npt <- length(unique(cy[cy[,3]==1,2]))  #unique death times
    surv <- .C('agsurv3', as.integer(n),
			  as.integer(nvar),
			  as.integer(ncurve),
			  as.integer(npt),
			  as.integer(se.fit),
			  as.double(score),
			  y = as.double(y[ord]),
			  x[ord,],
			  cox$coef,
			  cox$var,
			  cox$means,
			  as.integer(cn),
			  cy = cy,
			  cx,
			  surv = matrix(0, npt, ncurve),
			  varhaz = matrix(0, npt, ncurve),
			  nrisk  = matrix(0, npt, ncurve),
			  as.integer(method))

    browser()
    surv <- apply(surv$surv, 2, cumprod)
    if (se.fit)
	list(surv=surv, n=surv$nrisk, times=surv$cy[1:npt],
			se=sqrt(surv$varhaz)/surv)
    else
	list(surv=surv, n=surv$nrisk, times=surv$cy[1:npt,1] )
    }