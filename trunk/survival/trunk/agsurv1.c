/* SCCS $Id: agsurv1.c,v 4.1 1992-03-04 16:51:45 therneau Exp $  */
/*
** Fit the survival curve, the special case of an Anderson-Gill style data
**   This program differs from survfit in several key ways:
**       Only returns data at the event times, not at censoring times
**       Fewer work arrays, but it is slower.
**       Allows the definition of a "psuedo subject", who has his own n
**           y, x matrix, risk, and strata.
**       Strata play a different role in this routine.  In surv.fit, a
**           separate curve was produced for each strata.  In this routine,
**           the returned curve is for a single subject, who may have spent
**           time in many strata.  The subject's strata vector is 1,2, etc.
**       Because a subject may visit a strata more than once (I allow them to
**           wander about at will-- any restrictions are bound to find an
**           exception sooner or later anyway), I have to go through the
**           entire data set once for EVERY line of the new data.
**
**  Input
**    n=# of subjects
**    nvar - number of vars in xmat
**    y - 3 column matrix containing strart, stop, event
**    score[n] - vector of weights
**    strata[n] - ==1 at the last obs of each strata
**    xmat   = data matrix that generated the Cox fit
**    varcov[nvar,nvar] = covariance matrix of the cox coefs
**
**    hisn  = # of lines that define the new subject
**    hisy  = the y matrix for the new subject -- column 3 is ignored
**    hisxmat= new subject x matrix
**    hisstrat = new subject strata vector
**    hisrisk = score vector for the subject
**
** Output
**    surv  - the survival
**    varh  - the variance of the hazard function
**    nsurv - returned, number of survival time points
**    yy[,1] - contains the survival times
**    yy[2,] - the number of subjects at risk at that survival time
**    yy[3,] - the number of events at that time
**
**  Work
**    d[2*nvar]
**  Input must be sorted by (event before censor) within stop time within strata,
*/
#include <math.h>
#include <stdio.h>
double **dmatrix();

void agsurv1(sn, snvar, y, score, strata, surv,
		  varh, snsurv,xmat,d,varcov, yy,
		  shisn, hisy, hisxmat, hisrisk, hisstrat)
long *sn, *snvar;
long *snsurv, *shisn;
long strata[], hisstrat[];
double score[], y[], xmat[];
double varh[];
double surv[];
double d[], varcov[];
double hisy[], hisxmat[], hisrisk[];
double *yy;
{
    register int i,j,k,l;
    double hazard, varhaz;
    double *start, *stop, *event;
    double temp;
    int n, nvar;
    int nsurv;
    int deaths;
    double *hstart , *hstop;
    double *a;
    int hisn;
    double **covar,
	   **imat,
	   **hisx;
    int current_strata,
	nrisk,
	person;
    double *ytime,
	   *yrisk,
	   *ydeath;

    double time,
	   weight,
	   denom;

    n = *sn;  nvar = *snvar;
    hisn = *shisn;
    start =y;
    stop  = y+n;
    event = y+n+n;
    hstart= hisy;
    hstop = hisy + hisn;
    a = d+nvar;

    ytime = yy;
    yrisk = yy+ n*hisn;
    ydeath= yrisk + n*hisn;

    /*
    **  Set up the ragged arrays
    */
    covar= dmatrix(xmat, n, nvar);
    imat = dmatrix(varcov,  nvar, nvar);
    hisx = dmatrix(hisxmat, hisn, nvar);
    hazard  =0;
    varhaz  =0;
    nsurv =0;
    for (i=0; i<nvar; i++) d[i] =0;
    for (l=0; l<hisn; l++) {
	current_strata =1;
	for (person=0; person<n;) {
	    time = stop[person];
	    if (event[person]==0 || hstart[l] >= time || hstop[l]<time  ||
		    hisstrat[l] != current_strata) {
		current_strata += strata[person];
		person++;
		}
	    else {
		/*
		**   A match -- go to it.
		** compute the mean and denominator over the risk set
		*/
		denom =0;
		for(i=0; i<nvar; i++) a[i] =0;
		nrisk =0;
		for (k=person; k<n; k++) {
		    if (start[k] < time) {
			nrisk++;
			weight = score[k]/hisrisk[l];
			denom += weight;
			for (i=0; i<nvar; i++) {
			    a[i] += weight*(covar[i][k]- hisx[i][l]);
			    }
			 }
		    if (strata[k]==1) break;
		    }

		/*
		** Add results all events at this time point
		*/
		deaths=0;
		for (k=person; k<n && stop[k]==time; k++) {
		    if (event[k]==1) {
			deaths++;
			hazard += 1/denom;
			varhaz += 1/(denom*denom);
			for (i=0; i<nvar; i++)
			    d[i] += a[i]/ (denom*denom);
			}
		    person++;
		    if (strata[k]==1) break;
		    }
		surv[nsurv] = exp(-hazard);
		temp =0;
		for (i=0; i<nvar; i++)
		    for (j=0; j< nvar; j++)
			temp += d[i]*d[j]*imat[i][j];
		varh[nsurv] = varhaz + temp;

		ytime[nsurv] = time;
		yrisk[nsurv] = nrisk;
		ydeath[nsurv]= deaths;
		current_strata += strata[person-1];
		nsurv++;
		}
	    }
	}   /* end  of accumulation loop */
    *snsurv = nsurv;
    }
