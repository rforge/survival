# SCCS $Id: cox.zph.s,v 1.12 1993-04-12 11:57:52 therneau Exp $
#  Test proportional hazards
#
cox.zph <- function(fit, transform='km', global=T) {
    call <- match.call()
    if (!inherits(fit, 'coxph')) stop ("Argument must be the result of coxph")
    if (inherits(fit, 'coxph.null'))
	stop("The are no score residuals for a Null model")

    sresid <- resid(fit, 'schoenfeld')
    varnames <- names(fit$coef)
    nvar <- length(varnames)
    ndead<- length(sresid)/nvar
    if (nvar==1) times <- as.numeric(names(sresid))
    else         times <- as.numeric(dimnames(sresid)[[1]])

    if (is.character(transform)) {
	tname <- transform
	ttimes <- switch(transform,
			   'identity'= times,
			   'rank'    = rank(times),
			   'log'     = log(times),
			   'km' = {
				temp <- survfit.km(factor(rep(1,nrow(fit$y))),
						    fit$y, se.fit=F)
				# A nuisance to do left cont KM
				t1 <- temp$surv[temp$n.event>0]
				t2 <- temp$n.event[temp$n.event>0]
				km <- rep(c(1,t1), c(t2,0))
				if (is.null(attr(sresid, 'strata')))
				    1-km
				else (1- km[sort.list(sort.list(times))])
				},
			   stop("Unrecognized transform"))
	}
    else {
	tname <- deparse(substitute(transform))
	ttimes <- transform(times)
	}
    xx <- ttimes - mean(ttimes)

    r2 <- sresid %*% fit$var * ndead
    test <- xx %*% r2        # time weighted col sums
    corel <- c(cor(xx, r2))
    z <- c(test^2 /(diag(fit$var)*ndead* sum(xx^2)))
    Z.ph <- cbind(corel, z, 1- pchisq(z,1))

    if (global && nvar>1) {
	test <- c(xx %*% sresid)
	z    <- c(test %*% fit$var %*% test) * ndead / sum(xx^2)
	Z.ph <- rbind(Z.ph, c(NA, z, 1-pchisq(z, ncol(sresid))))
	dimnames(Z.ph) <- list(c(varnames, "GLOBAL"), c("rho", "chisq", "p"))
	}
    else dimnames(Z.ph) <- list(varnames, c("rho", "chisq", "p"))

    dimnames(r2) <- list(times, names(fit$coef))
    temp <-list(table=Z.ph, x=ttimes, y=r2 + outer(rep(1,ndead), fit$coef),
    var=fit$var, call=call, transform=tname)
    class(temp) <- "cox.zph"
    temp
    }
