#SCCS $Date: 1993-06-30 12:59:46 $ $Id: rowsum.s,v 4.2 1993-06-30 12:59:46 therneau Exp $
rowsum <- function(x, group, reorder=T) {
    if (!is.numeric(x)) stop("x must be numeric")
    if (is.matrix(x)) dd <- dim(x)
    else              dd <- c(length(x), 1)
    n <- dd[1]

    if (length(group) !=n)  stop("Incorrect length for 'group'")
    if (any(is.na(group)))  stop("Missing values for 'group'")
    na.indicator <- max(1,x[!is.na(x)]) * n   #larger than any possible sum
    x[is.na(x)] <- na.indicator

    storage.mode(x) <- 'double'
    temp <- .C("rowsum", dd= as.integer(dd),
			 as.double(na.indicator),
			 x = x,
			 as.double(group))
    new.n <- temp$dd[1]
    ugroup <- unique(group)
    if (is.matrix(x)){
	new.x <- temp$x[1:new.n,]
	dimnames(new.x) <- list(ugroup, dimnames(x)[[2]])
	if (reorder) new.x <- new.x[order(ugroup), ]
	}
    else {
	new.x <- temp$x[1:new.n]
	names(new.x) <- ugroup
	if (reorder) new.x <- new.x[order(ugroup)]
	}

    ifelse(new.x ==na.indicator, NA, new.x)
    }
