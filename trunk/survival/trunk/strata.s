#SCCS $Date: 1992-03-04 16:48:28 $ $Id: strata.s,v 4.1 1992-03-04 16:48:28 therneau Exp $
# Create a strata variable, possibly from many objects
#
strata <- function(..., na.group=F) {
    words <- match.call()
    allf <- list(...)
    if(length(allf) == 1 && is.list(ttt <- unclass(allf[[1]])))
	    allf <- ttt
    nterms <- length(allf)
    what <- allf[[nterms]]
    if(is.null(levels(what)))
	    what <- factor(what)
    levs <- unclass(what) - 1
    wlab <- levels(what)
    if (na.group && any(is.na(what))){
	levs[is.na(levs)] <- length(wlab)
	wlab <- c(wlab, "NA")
	}
    labs <- paste(words[nterms], wlab, sep='=')
    for (i in (1:nterms)[-nterms]) {
	what <- allf[i]
	if(is.null(levels(what)))
		what <- factor(what)
	wlab <- levels(what)
	wlev <- unclass(what) - 1
	if (na.group && any(is.na(wlev))){
	    wlev[is.na(wlev)] <- length(wlab)
	    wlab <- c(wlab, "NA")
	    }
	wlab <- paste(words[i], wlab, sep='=')
	levs <- levs * length(wlab) + wlev
	labs <- as.vector(outer(wlab, labs, paste, sep = ", "))
	}
    levs <- levs + 1
    ulevs <- unique(levs[!is.na(levs)])
    levs <- match(levs, ulevs)
    labs <- labs[ulevs]
    levels(levs) <- labs
    class(levs) <- "factor"
    levs
    }