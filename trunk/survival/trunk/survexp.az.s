# SCCS $Id: survexp.az.s,v 4.3 1998-12-17 17:49:42 therneau Exp $
#
# Create the Arizona total hazards table
#   The raw numbers below are q* 10^5.  Note that there are 24 leap years/100
#
survexp.az  <- {
    temp <- c(
     2143,194,148,102,80,78,72,66,58,50,42,40,48,69,101,138,176,209,233,248,
     263,279,289,290,285,274,263,256,259,269,283,295,307,316,325,335,348,365,
     385,410,436,467,504,549,601,657,717,779,846,918,996,1084,1183,1296,1423,
     1563,1714,1873,2034,2196,2361,2534,2720,2921,3136,3357,3584,3829,4102,
     4405,4735,5086,5462,5862,6291,6778,7320,7871,8399,8913,9475,10144,10894,
     11722,12623,13777,15099,16474,17798,19037,20191,21393,22765,24402,26197,
     27962,29090,30135,31111,32017,32857,33633,34347,35004,35606,36157,36661,
     37121,37540,37922,1711,151,129,90,58,55,45,38,33,29,27,27,30,38,49,62,75,
     85,90,91,91,92,93,95,98,101,104,107,110,112,115,120,127,140,155,173,192,
     210,227,242,258,275,295,319,346,374,403,430,455,481,508,540,584,644,714,
     793,872,941,994,1034,1072,1118,1177,1255,1352,1458,1571,1698,1843,2011,
     2197,2408,2663,2973,3339,3764,4241,4752,5282,5837,6474,7214,8004,8802,
     9606,10552,11647,12832,14091,15427,16879,18446,20041,21585,23069,24584,
     25854,26980,27996,28949,29836,30659,31420,32122,32768,33361,33904,34401,
     34855,35269,1466,149,98,81,65,56,51,46,38,29,21,20,30,55,88,123,153,178,
     195,206,217,228,235,238,238,235,233,231,231,231,232,233,234,236,240,244,
     252,261,273,287,304,325,354,392,438,490,545,599,649,699,748,805,875,961,
     1058,1161,1265,1367,1469,1573,1681,1800,1940,2106,2289,2477,2668,2873,
     3101,3358,3645,3954,4279,4615,4970,5375,5845,6357,6899,7475,8145,8946,
     9816,10686,11522,12466,13520,14624,15793,17035,18314,19653,21138,22782,
     24485,26149,27438,28654,29797,30867,31865,32792,33650,34443,35174,35845,
     36461,37024,37539,38009,1063,111,79,51,37,33,27,22,18,15,14,14,18,25,34,
     43,52,58,63,66,68,71,73,75,76,78,79,81,84,87,90,93,98,103,109,116,125,134,
     144,155,167,181,198,217,239,263,289,316,342,370,399,430,462,494,528,562,
     598,645,707,782,868,957,1044,1121,1193,1261,1340,1438,1570,1734,1925,2129,
     2343,2558,2780,3028,3320,3657,4047,4492,5001,5583,6239,6968,7775,8758,
     9858,10984,12093,13214,14441,15811,17257,18750,20271,21823,23221,24560,
     25834,27040,28176,29242,30237,31163,32023,32817,33550,34224,34843,35411,
     993,92,71,52,42,35,31,27,23,19,16,16,25,43,68,95,120,140,154,162,169,
     177,181,182,181,178,176,177,181,188,197,204,212,220,228,237,248,260,
     276,293,313,333,354,375,397,423,455,489,524,561,603,653,714,787,871,
     963,1060,1161,1267,1376,1487,1603,1730,1869,2017,2160,2305,2472,2678,
     2924,3201,3495,3809,4133,4471,4843,5258,5703,6177,6692,7296,7997,8740,
     9469,10182,11126,12256,13512,14879,16350,17959,19725,21534,23225,
     24688,26004,27536,28943,30390,31910,33505,35181,36940,38787,40726,
     42762,44900,47145,49503,51978,784,72,50,40,31,27,23,20,17,15,14,14,16,
     21,27,35,42,48,53,57,60,64,66,66,65,63,62,62,62,64,66,68,71,76,82,89,
     97,105,113,121,129,138,151,167,188,214,241,268,290,310,331,358,391,
     431,477,527,582,641,703,767,831,897,970,1052,1140,1227,1316,1413,1526,
     1661,1816,1988,2182,2392,2617,2859,3128,3434,3792,4208,4692,5236,5830,
     6461,7138,7970,8945,10015,11158,12384,13783,15354,16951,18473,19946,
     21475,23143,24775,26375,27957,29635,31413,33298,35296,37413,39658,
     42038,44560,47233,50068)

    temp2 <- -log(1- temp/100000)/365.24    #daily hazard rate

    #Add in the extrapolated data
    temp <- array(0, c(110,2,4))
    temp[,,1:3] <- temp2
    data.restore('survexp2000.sdump')
    temp[,,4]   <- exp(log(temp[,,3]) + survexp.2000[,,'total'])

    attributes(temp) <- list (
	dim      =c(110,2,4),
	dimnames =list(0:109, c("male", "female"), 10*(197:200)),
	dimid    =c("age", "sex", "year"),
	factor   =c(0,1,10),
	cutpoints=list(0:109 * 365.24, NULL, mdy.date(1,1, 197:200*10)),
	summary = function(R) {
		     x <- c(format(round(min(R[,1]) /365.24, 1)),
			    format(round(max(R[,1]) /355.24, 1)),
			    sum(R[,2]==1), sum(R[,2]==2))
		     x2<- as.character(as.date(c(min(R[,3]), max(R[,3]))))

		     paste("  age ranges from", x[1], "to", x[2], "years\n",
			   " male:", x[3], " female:", x[4], "\n",
			   " date of entry from", x2[1], "to", x2[2], "\n")
		     })
    temp
    }
rm(temp, temp2)
oldClass(survexp.az) <- 'ratetable'
