# $Id: survexp.fl.s,v 4.6 2006-08-28 15:50:21 m015733 Exp $
#
# Create the Florida total hazards table
#   The raw numbers below are q* 10^5.  Note that there are 24 leap years/100
#
survexp.fl  <- {
    temp <- c(
     2448,179,125,91,75,68,63,59,54,49,46,46,55,73,100,131,162,188,207,218,229,
     242,250,252,249,243,237,233,235,240,248,256,268,284,303,326,352,381,412,
     444,478,514,557,606,664,727,793,863,937,1016,1101,1196,1305,1434,1581,
     1746,1918,2081,2222,2346,2462,2588,2729,2890,3062,3229,3391,3564,3760,
     3984,4224,4478,4775,5129,5541,6021,6554,7108,7655,8210,8874,9697,10575,
     11401,12135,13070,14209,15471,16851,18319,19779,21255,22838,24564,26320,
     27962,29090,30135,31111,32017,32857,33633,34347,35004,35606,36157,36661,
     37121,37540,37922,1888,160,98,73,57,50,44,39,36,34,33,34,36,41,48,56,65,
     72,77,79,81,84,86,88,90,92,95,99,104,111,120,129,140,152,166,180,197,216,
     237,259,282,304,329,355,385,416,448,482,519,558,601,647,694,741,787,837,
     891,941,985,1027,1066,1111,1172,1254,1353,1461,1570,1688,1816,1959,2116,
     2293,2510,2781,3109,3499,3944,4429,4931,5452,6053,6762,7523,8302,9103,
     10128,11329,12593,13843,15079,16354,17762,19324,21048,22839,24584,25854,
     26980,27996,28949,29836,30659,31420,32122,32768,33361,33904,34401,34855,
     35269,1573,122,95,79,60,54,49,45,39,33,27,27,37,59,87,115,140,161,179,195,
     210,226,237,241,240,238,235,233,231,230,229,229,231,236,246,259,274,292,
     310,330,355,385,417,449,483,519,562,618,688,768,853,937,1021,1106,1193,
     1284,1380,1480,1582,1691,1804,1927,2060,2203,2352,2494,2640,2814,3033,
     3297,3593,3901,4219,4540,4872,5243,5668,6133,6635,7185,7834,8604,9436,
     10262,11061,12060,13219,14423,15637,16875,18162,19564,21114,22800,24505,
     26149,27438,28654,29797,30867,31865,32792,33650,34443,35174,35845,36461,
     37024,37539,38009,1306,103,82,50,36,35,29,25,21,19,17,18,22,30,39,49,58,
     65,71,75,80,84,87,88,88,87,86,86,87,89,91,94,97,102,107,115,123,135,149,
     166,186,208,229,248,267,286,309,336,368,402,437,472,507,544,582,622,665,
     710,761,817,878,943,1012,1083,1155,1226,1303,1399,1523,1675,1849,2033,
     2228,2429,2643,2879,3153,3483,3890,4379,4968,5649,6388,7134,7882,8772,
     9817,10909,12015,13154,14399,15783,17250,18765,20295,21823,23221,24560,
     25834,27040,28176,29242,30237,31163,32023,32817,33550,34224,34843,35411,
     1043,109,61,50,43,39,36,33,29,24,20,19,27,43,66,91,113,132,145,154,
     163,173,181,188,194,199,204,211,220,232,245,258,270,283,296,310,325,
     340,354,367,381,396,413,432,455,481,513,550,592,640,695,760,829,903,
     981,1064,1154,1252,1356,1463,1569,1674,1784,1899,2018,2134,2253,2395,
     2572,2786,3026,3282,3562,3861,4182,4529,4915,5341,5820,6363,7007,7744,
     8515,9258,9978,10966,12155,13449,14810,16236,17794,19538,21349,23080,
     24613,26004,27536,28943,30390,31910,33505,35181,36940,38787,40726,
     42762,44900,47145,49503,51978,
     855,80,54,38,32,28,24,20,18,16,15,16,18,23,29,36,43,49,53,56,59,63,66,
     68,71,73,75,78,84,90,98,105,111,115,118,121,125,131,138,147,157,167,
     179,194,211,232,255,280,305,331,361,395,431,467,505,545,590,641,695,
     751,806,862,922,988,1060,1133,1210,1299,1409,1541,1692,1859,2045,2245,
     2456,2680,2928,3212,3547,3939,4391,4894,5451,6060,6734,7619,8649,9764,
     10926,12154,13562,15167,16814,18393,19916,21475,23143,24775,26375,
     27957,29635,31413,33298,35296,37413,39658,42038,44560,47233,50068)

    temp2 <- -log(1- temp/100000)/365.24    #daily hazard rate

    #Add in the extrapolated data
    temp <- array(0, c(110,2,4))
    temp[,,1:3] <- temp2
    data.restore('survexp2000.sdump')
    temp[,,4] <- exp(log(temp[,,3]) + survexp.2000[,,"total"])

    attributes(temp) <- list (
	dim      =c(110,2,4),
	dimnames =list(0:109, c("male", "female"), 10*(197:200)),
	dimid    =c("age", "sex", "year"),
	factor   =c(0,1,10),
	cutpoints=list(0:109 * 365.24, NULL, julian(1,1, 197:200*10)),
	summary = function(R) {
		     x <- c(format(round(min(R[,1]) /365.24, 1)),
			    format(round(max(R[,1]) /365.24, 1)),
			    sum(R[,2]==1), sum(R[,2]==2))
		     x2<- format(dates(c(min(R[,3]), max(R[,3]))))

		     paste("  age ranges from", x[1], "to", x[2], "years\n",
			   " male:", x[3], " female:", x[4], "\n",
			   " date of entry from", x2[1], "to", x2[2], "\n")
		     })
    temp
    }
rm(temp, temp2, survexp.2000)
oldClass(survexp.fl) <- 'ratetable'
