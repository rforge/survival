# 
#  SCCS $Id: survpenal.fit.s,v 1.1 1998-11-25 21:09:46 therneau Exp $
# fit a penalized parametric model
#
survpenal.fit<- function(x, y, weights, offset, init, controlvals, dist, 
		       scale=0, nstrat=1, strata, pcols, pattr, assign) {

    iter.max <- controlvals$iter.max
    eps <- controlvals$rel.tol
    toler.chol <- controlvals$toler.chol
    debug <- controlvals$debug

    if (!is.matrix(x)) stop("Invalid X matrix ")
    n <- nrow(x)
    nvar <- ncol(x)
    ny <- ncol(y)
    if (is.null(offset)) offset <- rep(0,n)
    if (missing(weights)|| is.null(weights)) weights<- rep(1.0,n)
    else if (any(weights<=0)) stop("Invalid weights, must be >0")

    if (scale <0) stop("Invalid scale")
    if (scale >0 && nstrat >1) 
	    stop("Cannot have both a fixed scale and strata")
    if (nstrat>1 && (missing(strata) || length(strata)!= n))
	    stop("Invalid strata variable")
    if (nstrat==1) strata <- rep(1,n)
    if (scale >0) nstrat2 <- 0; else nstrat2 <- nstrat

    if (is.character(dist)) {
	sd <- survreg.distributions[[dist]]
	if (is.null(sd)) stop ("Unrecognized distribution")
	}
    else sd <- dist
    dnum <- match(sd$name, c("Extreme value", "Logistic", "Gaussian"))
    if (is.na(dnum)) {
	# Not one of the "built-in distributions
	dnum <- 4
	if (!is.function(sd$quantiles)) 
		stop("Missing quantiles function in user defined distribution")
	stop ('function not yet finished')
	}

    status <- y[,ny]
    #
    # are there any sparse frailty terms?
    # 
    npenal <- length(pattr)
    if (npenal == 0 || length(pcols) != npenal)
	    stop("Invalid pcols or pattr arg")
    sparse <- sapply(pattr, function(x) !is.null(x$sparse) &&  x$sparse)
    if (sum(sparse) >1) stop("Only one sparse penalty term allowed")

    #
    # Create a marking vector for the terms, the same length as assign
    #    with pterms == 0=ordinary term, 1=penalized, 2=sparse,
    #    pindex = length of pcols = position in pterms
    # 
    # Make sure that pcols is a strict subset of assign, so that the
    #   df computation (and printing) can unambiguously decide which cols of
    #   X are penalized and which are not when doing "terms" like actions.
    # To make some downstream things easier, order pcols and pattr to be
    #   in the same relative order as the terms in 'assign' 
    #
    if (missing(assign)) assign <- attr(x, 'assign')
    pterms <- rep(0, length(assign))
    names(pterms) <- names(assign)
    pindex <- rep(0, npenal)
    for (i in 1:npenal) {
	temp <- unlist(lapply(assign, function(x,y) (length(x) == length(y) &&
					     all(x==y)), pcols[[i]]))
	if (sparse[i]) pterms[temp] <- 2
	else pterms[temp] <- 1
	pindex[i] <- (seq(along=temp))[temp]
	}
    if ((sum(pterms==2) != sum(sparse)) || (sum(pterms>0) != npenal))
	    stop("pcols and assign arguments disagree")
    if (any(pindex != sort(pindex))) {
	temp <- order(pindex)
	pindex <- pindex[temp]
	pcols <- pcols[temp]
	pattr <- pattr[temp]
	}
    
    # ptype= 1 or 3 if a sparse term exists, 2 or 3 if a non-sparse exists
    ptype <- any(sparse) + 2*(any(!sparse))

    if (any(sparse)) {
	sparse.attr <- (pattr[sparse])[[1]]  #can't use [[sparse]] directly
	                                     # if 'sparse' is a T/F vector
	fcol <- unlist(pcols[sparse])
	if (length(fcol) > 1) stop("Sparse term must be single column")

	# Remove the sparse term from the X matrix
	frailx <- x[, fcol]
	x <- x[, -fcol, drop=F]
	for (i in 1:length(assign)){
	    j <- assign[[i]]
	    if (j[1] > fcol) assign[[i]] <- j-1
	    }
	for (i in 1:npenal) {
	    j <- pcols[[i]]
	    if (j[1] > fcol) pcol[[i]] <- j-1
	    }

	frailx <- match(frailx, sort(unique(frailx)))
	nfrail <- max(frailx)
	nvar <- nvar - 1

	#Set up the callback for the sparse frailty term
	pfun1 <- sparse.attr$pfun
	expr1 <- expression({
	    coef <- coxlist1$coef
	    if (is.null(extra1)) temp <- pfun1(coef, theta1, n.eff)
	    else  temp <- pfun1(coef, theta1, n.eff, extra1)

	    if (!is.null(temp$recenter)) 
		    coxlist1$coef <- coxlist1$coef - as.double(temp$recenter)
	    if (!temp$flag) {
		coxlist1$first <- -as.double(temp$first)
		coxlist1$second <- as.double(temp$second)
	        }
	    coxlist1$penalty <- -as.double(temp$penalty)
	    coxlist1$flag   <- as.logical(temp$flag)
	    if (any(sapply(coxlist1, length) != c(rep(nfrail,3), 1, 1)))
		    stop("Incorrect length in coxlist1")
	    coxlist1})
	coxlist1 <- list(coef=double(nfrail), first=double(nfrail), 
			 second=double(nfrail), penalty=0.0, flag=F)
	.C("init_coxcall1", as.integer(sys.nframe()), expr1)
	}
    else {
	frailx <- 0
	nfrail <- 0
	}
    nvar2 <- nvar + nstrat - 1*(scale >0)

    # Now the non-sparse penalties
    if (sum(!sparse) >0) {
	full.imat <- !all(unlist(lapply(pattr, function(x) x$diag)))
	ipenal <- (1:length(pattr))[!sparse]   #index for non-sparse terms
	expr2 <- expression({
	    pentot <- 0
	    for (i in ipenal) {
		pen.col <- pcols[[i]]
		coef <- coxlist2$coef[pen.col]
		if (is.null(extralist[[i]]))
			temp <- ((pattr[[i]])$pfun)(coef, thetalist[[i]],n.eff)
		else    temp <- ((pattr[[i]])$pfun)(coef, thetalist[[i]],
						n.eff,extralist[[i]])
		if (!is.null(temp$recenter))
		    coxlist2$coef[pen.col] <- coxlist2$coef[pen.col]- 
			                               temp$recenter
		if (temp$flag) coxlist2$flag[pen.col] <- T
		else {
		    coxlist2$flag[pen.col] <- F
		    coxlist2$first[pen.col] <- -temp$first
		    if (full.imat) {
			tmat <- matrix(coxlist2$second, nvar2, nvar2)
			tmat[pen.col,pen.col] <- temp$second
			coxlist2$second <- c(tmat)
		        }
		    else coxlist2$second[pen.col] <- temp$second
		    }
		pentot <- pentot - temp$penalty
	        }
	    coxlist2$penalty <- as.double(pentot)
	    if (any(sapply(coxlist2, length) != length2)) 
		    stop("Length error in coxlist2")
	    coxlist2})
	if (full.imat) {
	    coxlist2 <- list(coef=double(nvar2), first=double(nvar2), 
		    second= double(nvar2*nvar2), penalty=0.0, flag=rep(F,nvar2))
	    length2 <- c(nvar2, nvar2, nvar2*nvar2, 1, nvar2)
	    }  
	else {
	    coxlist2 <- list(coef=double(nvar2), first=double(nvar2),
		    second=double(nvar2), penalty= 0.0, flag=rep(F,nvar2))
	    length2 <- c(nvar2, nvar2, nvar2, 1, nvar2)
	    }
	.C("init_coxcall2", as.integer(sys.nframe()), expr2)
        }
    else full.imat <- F

    #
    # "Unpack" the passed in paramter list, 
    #   and make the initial call to each of the external routines
    #
    cfun <- lapply(pattr, function(x) x$cfun)
    parmlist <- lapply(pattr, function(x,eps) c(x$cparm, eps2=eps), sqrt(eps))
    extralist<- lapply(pattr, function(x) x$pparm)
    iterlist <- vector('list', length(cfun))
    thetalist <- vector('list', length(cfun))
    printfun  <- lapply(pattr, function(x) x$printfun)
    for (i in 1:length(cfun)) {
	temp <- (cfun[[i]])(parmlist[[i]], iter=0)
	if (sparse[i]) {
	    theta1 <- temp$theta
	    extra1 <- extralist[[i]]
	    }
	thetalist[[i]] <- temp$theta
	iterlist[[i]] <- temp
	}

    #
    # Manufacture the list of calls to cfun, with appropriate arguments
    #
    temp1 <- c('x', 'coef', 'plik', 'loglik', 'status', 'neff',  'df', 'trH')
    temp2 <- c('frailx', 'fcoef', 'loglik',  'fit$loglik', 'status', 'n.eff')
    temp3 <- c('x[,pen.col]', 'coef[pen.col]','loglik',
	       'fit$loglik', 'status', 'n.eff')
    calls <- vector('expression', length(cfun))
    cargs <- lapply(pattr, function(x) x$cargs)
    for (i in 1:length(cfun)) {
	tempchar <- paste("(cfun[[", i, "]])(parmlist[[", i, "]], iter,",
			  "iterlist[[", i, "]]")
	temp2b <- c(temp2, paste('pdf[', i, ']'), paste('trH[', i, ']'))
	temp3b <- c(temp3, paste('pdf[', i, ']'), paste('trH[', i, ']'))
	if (length(cargs[[i]])==0) 
	    calls[i] <- parse(text=paste(tempchar, ")"))
	else {
	    temp <- match(cargs[[i]], temp1)
	    if (any(is.na(temp))) stop(paste((cargs[[i]])[is.na(temp)],
					    "not matched"))
	    if (sparse[i]) temp4 <- paste(temp2b[temp], collapse=',')
	    else           temp4 <- paste(temp3b[temp], collapse=',')
	    
	    calls[i] <- parse(text=paste(paste(tempchar,temp4,sep=','),')'))
	    }
        }
    need.df <- any(!is.na(match(c('df', 'trH'), unlist(cargs))))#do any use df?

    #
    # Last of the setup: create the vector of variable names
    #
    varnames <- dimnames(x)[[2]]
    for (i in 1:npenal) {
	if (!is.null(pattr[[i]]$varname))
		varnames[pcols[[i]]] <- pattr[[i]]$varname
        }

    #
    # Fit the model with just a mean and scale
    #    assume initial values and penalties don't apply here
    #
    meanonly <- (nvar==1 && all(x==1) && nfrail==0)
    if (meanonly) stop("Cannot fit a penalized 'mean only' model")

    yy <- ifelse(status !=3, y[,1], (y[,1]+y[,2])/2 )
    coef <- sd$init(yy, weights)
    if (scale >0) coef[2] <- scale
    variance <- log(coef[2])/2   # init returns \sigma^2, I need log(sigma)
    coef <- c(coef[1], rep(variance, nstrat2))
    # get a better initial value for the mean using the "glim" trick
    deriv <- .C("survreg3",
		as.integer(n),
		as.double(y),
		as.integer(ny),
		as.double(yy),
		nstrat = as.integer(nstrat2),
		strata = as.integer(strata),
		vars= as.double(coef[-1]),
		deriv = matrix(double(n * 3),nrow=n),
		as.integer(3),
		as.integer(dnum))$deriv
    coef[1] <- coef[1] - sum(weights*deriv[,2])/sum(weights*deriv[,3])

    # Now the fit proper (intercept only)
    temp <- 1 +nstrat
    fit0 <- .C("survreg2",
	       iter = as.integer(iter.max),
	       as.integer(n),
	       as.integer(1),
	       as.double(y),
	       as.integer(ny),
	       rep(1.0, n),
	       as.double(weights),
	       as.double(offset),
	       coef= as.double(coef),
	       as.integer(nstrat2),
	       as.integer(strata),
	       u = double(3*(temp) + temp^2),
	       var = matrix(0.0, temp, temp),
	       loglik=double(1),
	       flag=integer(1),
	       as.double(eps),
	       as.double(toler.chol), 
	       as.integer(dnum),
	       debug = as.integer(floor(debug/2)))

    # The "effective n" of the model
    n.eff <- mean(exp(fit0$coef[-1]))^2 / fit0$var[1,1]

    #
    # Fit the model with all covariates
    #   Start with initial values
    #
    nvar3 <- nvar2 + nfrail
    if (is.numeric(init)) {
	if (length(init) != nvar3) {
	    if (length(init) == nvar2) init <- c(rep(0,nfrail), init)
	    else stop("Wrong length for inital values")
	    }
	}
    else  {
	# The algebra behind the 'glim' trick just doesn't work here
	#  Use the intercept fit + zeros
	# Frailty, intercept, other covariates, sigmas
	init <- c(rep(0, nfrail), fit0$coef[1], rep(0, nvar-1), fit0$coef[-1])
	}

    #
    # Tack on the sigmas to "assign", so that the df component includes
    #   the sigmas
    if (nstrat2 >0) assign <- c(assign, list(sigma=(1+nvar):nvar2))

    iter <- iter2 <- 0
    iterfail <- NULL
    thetasave <- unlist(thetalist)
    repeat {
	fit <- .C("survreg4",
		   iter = as.integer(iter.max),
		   as.integer(n),
		   as.integer(nvar),
		   as.double(y),
		   as.integer(ny),
		   as.double(x),
	           as.double(weights),
		   as.double(offset),
		   coef= as.double(init),
	           as.integer(nstrat2),
	           as.integer(strata),
		   u = double(3*(nvar3) + nvar2*nvar3),
		   hmat = double(nvar2*nvar3),
	           hinv = double(nvar2*nvar3),
		   loglik=double(1),
		   flag=integer(1),
		   as.double(eps),
	           as.double(toler.chol), 
		   as.integer(dnum),
	           debug = as.integer(debug),
	           as.integer(ptype),
		   as.integer(full.imat),
		   as.integer(nfrail),
		   as.integer(frailx),
	           fdiag = double(nvar3))

	if (debug>0) browser()
	iter <- iter+1
	iter2 <- iter2 + fit$iter
	if (fit$iter >=iter.max) iterfail <- c(iterfail, iter)

	if (nfrail >0) {
	    fcoef <- fit$coef[1:nfrail]
	    coef  <- fit$coef[-(1:nfrail)]
	    }
	else coef <- fit$coef

	# If any penalties were infinite, the C code has made fdiag=1 out
	#  of self-preservation (0 divides).  But such coefs are guarranteed
	#  zero so the variance should be too.)
	temp <- rep(F, nvar2+nfrail)
	if (nfrail>0) temp[1:nfrail] <- coxlist1$flag
	if (ptype >1) temp[nfrail+ 1:nvar2] <- coxlist2$flag
	fdiag <- ifelse(temp, 0, fit$fdiag)

	if (need.df) {
            #get the penalty portion of the second derive matrix
	    if (nfrail>0) temp1 <- coxlist1$second
	    else 	  temp1 <- 0
	    if (ptype>1)  temp2 <- coxlist2$second
	    else          temp2 <- 0
					
	    dftemp <-coxpenal.df(matrix(fit$hmat, ncol=nvar2),  
			         matrix(fit$hinv, ncol=nvar2), fdiag, 
				 assign, ptype, nvar2,
		                 temp1, temp2, pindex[sparse])
	    df <- dftemp$df
	    var  <- dftemp$var
	    var2 <- dftemp$var2
	    pdf <- df[pterms>0]	          # df's for penalized terms
	    trH <- dftemp$trH[pterms>0]   # trace H 
	    }

	if (nfrail >0)  penalty <- -coxlist1$penalty
	else            penalty <- 0
	if (ptype >1) penalty <- penalty - coxlist2$penalty
	loglik <- fit$loglik + penalty  #C code returns PL - penalty
	if (iter==1) penalty0 <- penalty

	#
	# Call the control function(s)
	#
	done <- T
	for (i in 1:length(cfun)) {
	    pen.col <- pcols[[i]]
	    temp <- eval(calls[i])
	    if (sparse[i]) theta1 <- temp$theta
	    thetalist[[i]] <- temp$theta
	    iterlist[[i]] <- temp
	    done <- done & temp$done
    	    }
	if (done) break

	# 
	# Choose starting estimates for the next iteration
	#
	if (iter==1) {
	    init <- coefsave <- fit$coef
	    thetasave <- cbind(thetasave, unlist(thetalist))
	    }
	else {
	    temp <- unlist(thetalist)
	    coefsave <- cbind(coefsave, fit$coef)
	    # temp = next guess for theta
	    # *save = prior thetas and the resultant fits
	    # choose as initial values the result for the closest old theta
	    howclose <- apply((thetasave-temp)^2,2, sum)
	    which <- min((1:iter)[howclose==min(howclose)])
	    init <- coefsave[,which]
	    thetasave <- cbind(thetasave, temp)
	    }
        }

    if (!need.df) {  #didn't need it iteration by iteration, but do it now
        #get the penalty portion of the second derive matrix
	if (nfrail>0) temp1 <- coxlist1$second
	else 	      temp1 <- 0
	if (ptype>1)  temp2 <- coxlist2$second
	else          temp2 <- 0
					
	dftemp <-coxpenal.df(matrix(fit$hmat,ncol=nvar2),  
			     matrix(fit$hinv,ncol=nvar2),  fdiag, 
		             assign, ptype, nvar2, 
		             temp1, temp2, pindex[sparse])
	df <- dftemp$df
	trH <- dftemp$trH
	var <- dftemp$var
	var2  <- dftemp$var2
        }

    if (iter.max >1 && length(iterfail)>0)
	    warning(paste("Inner loop failed to coverge for iterations", 
			  paste(iterfail, collapse=' ')))
    which.sing <- (fdiag[nfrail + 1:nvar] ==0)
    coef[which.sing] <- NA

    names(iterlist) <- names(pterms[pterms>0])
    cname <- varnames
    cname <- c(cname, rep("Log(scale)", nstrat))
    dimnames(var) <- list(cname, cname)
    names(coef) <- cname

    if (nfrail >0) {
	lp <- offset + fcoef[frailx]
	lp <- lp + x %*%coef[1:nvar] 
	list(coefficients  = coef,
		 var    = var,
		 var2   = var2,
		 loglik = c(fit0$loglik, loglik),
		 iter   = c(iter, iter2),
		 linear.predictors = as.vector(lp),
		 frail = fcoef,
		 fvar  = dftemp$fvar,
		 df = df, 
		 penalty= c(penalty0, penalty),
		 pterms = pterms, assign2=assign,
		 history= iterlist,
		 printfun=printfun)
	}
    else {  #no sparse terms
	list(coefficients  = coef,
	     var    = var,
	     var2   = var2,
	     loglik = c(fit0$loglik, loglik),
	     iter   = c(iter, iter2),
	     linear.predictors = as.vector(x%*%coef[1:nvar]),
	     df = df, df2=dftemp$df2,
	     penalty= c(penalty0, penalty), 
	     pterms = pterms, assign2=assign,
	     history= iterlist,
	     printfun= printfun)
	}
    }
