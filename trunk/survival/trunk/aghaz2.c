/*  SCCS $Id: aghaz2.c,v 5.1 1998-08-30 14:51:52 therneau Exp $
/*
** Compute the hazard and cumulative hazard functions.
**
** Input
**      n       number of subjects
**      start   start times
**      stop    stop times
**      event   =1 if there was an event at time 'stop'
**      score   the vector of subject scores, i.e., exp(beta*z)
**      strata  is =1 for the last obs of a strata
**
** Output
**      hazard  for each subject, the increment in the cumulative hazard
**                 computed at that subject's observation time.  If two
**                 subjects in the same strata have a tied time, then the
**                 hazard is set to 0 for all but the first of the ties.
**      cumhaz  The cumulative hazard experienced by each subject.
**
** The martingale residual will be event[i] - score[i]*cumhaz[i]
*/
#include <stdio.h>
#include "survproto.h"

void aghaz2(long   *n,     double *start,   double *stop,   long   *event, 
	    double *score, long   * strata, double *hazard, double * cumhaz)
    {
    int i,j,k;
    double denom;
    double temp;
    double time;
    int deaths;

    for (i=0; i<*n; ) {
	if (event[i] ==1) {
	    /*
	    ** compute the sum of weights over the risk set
	    **   and count the deaths
	    */
	    denom =0;
	    deaths =0;
	    time = stop[i];
	    for (k=i; k<*n; k++) {
		if (start[k] < time) denom += score[k];
		if (stop[k]==time) deaths += event[k];
		if (strata[k]==1) break;
		}

	    hazard[i] = deaths/denom;
	    for (k=i; k<*n && stop[k]==time; k++) {
		i++;
		if (strata[k]==1) break;
		}
	    }
	else i++;
	}

    j=0;
    for (i=0; i<*n; i++) {
	temp =0;
	for (k=j; k<=i; k++)
	    if (start[i] < stop[k]) temp += hazard[k];
	cumhaz[i] = temp;
	if (strata[i]==1) j=i+1;
	}
    }
