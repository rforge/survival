# SCCS $Id: survexp.azr.s,v 4.2 1994-11-22 21:57:12 therneau Exp $
#
# Create the Arizona hazards table, by race
#   The raw numbers below are q* 10^5.  Note that there are 24 leap years/100
#
survexp.azr  <- {
    temp1 <- c(
     1960,170,126,96,73,71,65,60,53,45,38,36,43,61,88,121,153,182,204,218,233,
     249,257,255,245,229,214,203,203,211,223,234,244,251,257,265,277,293,314,
     339,367,398,438,488,546,609,674,740,805,873,946,1029,1126,1240,1372,1518,
     1674,1838,2002,2166,2332,2508,2693,2891,3103,3319,3542,3786,4062,4371,
     4704,5055,5434,5843,6286,6797,7364,7932,8457,8950,9479,10116,10852,11703,
     12668,13924,15362,16847,18244,19512,20665,21873,23285,25039,27025,29014,
     30431,31784,33085,34324,35479,36553,37550,38471,39320,40101,40818,41475,
     42075,42624,1539,119,96,77,55,49,43,37,33,29,26,25,28,35,46,59,71,81,85,
     85,83,83,83,84,86,88,90,92,93,94,95,97,103,114,129,147,165,182,198,213,
     227,244,264,290,320,351,382,410,435,460,484,514,556,614,684,762,840,908,
     960,999,1035,1079,1137,1215,1312,1420,1534,1663,1811,1980,2167,2380,2636,
     2949,3318,3749,4232,4752,5291,5857,6505,7261,8071,8899,9747,10746,11907,
     13152,14441,15774,17202,18754,20370,22003,23631,25298,26762,28133,29413,
     30615,31742,32794,33772,34679,35517,36289,36999,37651,38248,38793,1375,
     138,90,75,62,53,48,43,36,27,20,18,27,49,80,111,138,160,175,185,194,203,
     208,209,207,204,200,197,195,196,196,197,197,198,200,204,209,217,227,241,
     256,277,306,345,391,445,501,557,608,658,708,766,837,925,1025,1131,1236,
     1341,1445,1552,1663,1784,1926,2090,2272,2458,2646,2851,3082,3344,3639,
     3955,4289,4634,4999,5419,5906,6435,6984,7557,8213,8994,9841,10700,11544,
     12506,13579,14708,15898,17159,18462,19838,21372,23083,24869,26617,28001,
     29311,30545,31703,32784,33791,34724,35588,36384,37117,37790,38407,38971,
     39486,988,105,71,44,33,30,25,21,18,15,13,13,17,24,33,43,51,57,61,61,62,63,
     64,65,66,67,69,70,73,76,79,82,86,91,97,105,113,122,130,138,148,160,175,
     195,218,244,272,300,326,352,380,409,441,475,512,548,586,634,696,770,855,
     943,1027,1103,1172,1238,1314,1412,1544,1710,1904,2110,2325,2540,2762,3010,
     3304,3646,4043,4497,5013,5600,6262,6999,7818,8816,9933,11074,12187,13306,
     14532,15917,17400,18960,20573,22228,23729,25173,26551,27859,29094,30255,
     31342,32355,33297,34168,34973,35715,36397,37022)
    temp2 <- c(
     1956,213,151,117,83,79,71,64,54,42,32,32,52,93,149,206,256,300,337,369,
     403,439,471,497,517,536,556,574,589,601,610,619,632,653,682,720,759,796,
     820,833,841,853,874,908,956,1010,1064,1120,1177,1234,1295,1361,1432,1506,
     1584,1668,1756,1839,1913,1985,2050,2128,2251,2436,2667,2920,3164,3378,
     3542,3667,3788,3923,4061,4207,4367,4520,4690,4944,5352,5956,6822,7957,
     9266,10379,11073,11737,12545,13381,14359,15486,16629,17735,18912,20146,
     21378,22554,23274,23944,24563,25135,25662,26146,26590,26996,27367,27706,
     28014,28295,28550,28782,1461,143,133,98,61,53,38,27,21,17,17,20,24,30,38,
     46,55,66,80,97,116,135,151,161,167,172,178,184,190,196,203,209,216,224,
     233,242,253,270,296,328,365,400,428,445,453,456,463,481,517,568,629,688,
     735,763,775,782,800,839,911,1014,1134,1262,1402,1538,1664,1787,1909,2026,
     2148,2285,2439,2612,2812,3027,3242,3460,3683,3900,4127,4391,4719,5129,
     5623,6146,6643,7312,8085,9015,10167,11510,12988,14398,15584,16480,17286,
     18279,19170,20022,20825,21577,22279,22930,23534,24091,24605,25077,25510,
     25907,26269,26600)

    temp3 <- -log(1- c(temp1, temp2, temp2)/100000)/365.24

    # Add in the extrapolated data for 1990 and 2000
    temp <- array(0, c(110,2, 4, 2))
    temp[,,1:2,] <- temp3
    fix  <- c(.00061*(0:109) - .1271, .00041*(0:109) - .1770,
	     -.00015*(0:109) - .0979, .00050*(0:109) - .1448)
    temp[,,3,]   <- exp(log(temp[,,2,]) + fix)
    temp[,,4,]   <- exp(log(temp[,,3,]) + fix)

    attributes(temp) <- list (
	dim      =c(110,2,4,2),
	dimnames =list(0:109, c("male", "female"), 10* 197:200,
			      c("white", "nonwhite")),
	dimid    =c("age", "sex", "year", "race"),
	factor   =c(0,1,10,1),
	cutpoints=list(0:109 * 365.24, NULL, mdy.date(1,1, 197:200*10), NULL),
	summary = function(R) {
		     x <- c(format(round(min(R[,1]) /365.24, 1)),
			    format(round(max(R[,1]) /355.24, 1)),
			    sum(R[,2]==1), sum(R[,2]==2),
			    sum(R[,4]==1), sum(R[,4]==2))
		     x2<- as.character(as.date(c(min(R[,3]), max(R[,3]))))

		     paste("  age ranges from", x[1], "to", x[2], "years\n",
			   " male:", x[3], " female:", x[4], "\n",
			   " date of entry from", x2[1], "to", x2[2], "\n",
			   " white:",x[7], " nonwhite:", x[8], "\n")
		     },
	class='ratetable')
    temp
    }
