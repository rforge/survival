.BG
.FN Surv
.FN is.Surv
.TL
Create a Survival Object
.DN
Create a survival object, usually used as a response variable in a model
formula.
.CS
Surv(time, event)
Surv(time, time2, event, type=<<see below>>, origin=0)
is.Surv(x)
.RA
.AG time
for right censored data, this is the follow up time.  For interval data, the
first argument is the starting time for the interval.
.AG x
any S-PLUS object.
.OA
.AG time2
ending time of the interval for interval censored  or counting process 
data only. 
Intervals are
assumed to be open on the left and closed on the right, (start, end].
For counting process data,
'event' indicates whether an event occurred at the end of the interval.
.AG event
status indicator, normally 0 = alive and 1 = dead.  Other choices are T/F
(T = death) or 1/2 (2 = death).
For interval censored data, the status indicator is 0 = right censored,
1 = event at `time', 2 = left censored, and 3 = interval censored.
For left-censored data, the status indicator is T=uncensored, F=censored.
Although unusual, the event indicator can be omitted,
in which case all subjects are assumed to have an event.
.AG type
character string specifying the type of censoring. Possible values
are `"right"', `"left"', `"counting"', `"interval"', or `"interval2"'.
The default is `"right"' or `"counting"' depending on whether the `time2'
argument is absent or present, respectively.
.AG origin
hazard function origin for counting process data.  Most often
used in a model containing time dependent strata 
to align the subjects properly when they change from one strata to
another.
.RT
in the case of 'Surv', a matrix of 2 or 3 columns of class '"Surv"'
containing 'time', 'time2' (if provided), and 'status'.
.PP 
In the case of 'is.Surv', a logical value 'T' if 'x' inherits from class
'"Surv"', otherwise an 'F'.
.SH DETAILS
In theory it is possible to represent interval censored data without a
third column containing the explicit status.  Exact, right censored,
left censored and interval censored observation would be represented as
intervals of [a,a], [a, infinity), (-infinity,b], and [a,b) 
respectively; each interval is a pair of time points within which the event is 
known to have occurred.
.PP
If `type="interval2"', the representation given above is
assumed, with `NA' taking the place of infinity.  If `type="interval"',
`event' must be given.  If `event' is `0', `1', or `2', the relevant
information is assumed to be contained in `time', the value in `time2'
is ignored, and the second column of the result contains a
placeholder.
.PP
Presently, the only methods allowing interval censored data are the
parametric models computed by `survreg', 
so the distinction between open and closed intervals
is unimportant.  
The distinction is important for counting process data and
the Cox model.
.PP
The function tries to distinguish between the use of 0/1 and 1/2 coding for
left and right censored data using `if (max(status)==2)'.
If 1/2 coding is used and all the subjects are censored, it will
guess wrong.  Use 0/1 coding in this case.
.SA
`coxph', `survfit', `survreg'.
.EX
Surv(leukemia$time, leukemia$status)
Surv(heart$start, heart$stop, heart$event)
.KW survival4
.WR


