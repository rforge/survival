# SCCS $Id: survexp.usr.s,v 4.4 1995-01-23 17:51:44 therneau Exp $
#
# Create the US total hazards table, by race
#   The raw numbers below are q* 10^5.  Note that there are 24 leap years/100
#
survexp.usr  <- {
    temp1 <- c(
     2592,153,101,81,69,62,57,53,49,45,42,42,47,59,75,93,111,126,139,149,159,
     169,174,172,165,156,149,145,145,149,156,163,171,181,193,207,225,246,270,
     299,332,368,409,454,504,558,617,686,766,856,955,1058,1162,1264,1368,1475,
     1593,1730,1891,2074,2271,2476,2690,2912,3143,3389,3652,3930,4225,4538,
     4871,5230,5623,6060,6542,7066,7636,8271,8986,9788,10732,11799,12895,13920,
     14861,16039,17303,18665,20194,21877,23601,25289,26973,28612,30128,31416,
     32915,34450,36018,37616,39242,40891,42562,44250,45951,47662,49378,51095,
     52810,54519,1964,135,81,63,55,47,41,37,33,30,28,28,29,32,36,41,47,51,54,
     55,56,58,60,62,63,65,68,71,74,79,85,91,97,105,113,122,133,145,158,174,190,
     209,229,252,276,303,331,362,396,432,473,517,560,601,642,687,740,805,886,
     981,1088,1203,1325,1454,1592,1742,1909,2100,2319,2567,2836,3129,3462,3845,
     4278,4742,5245,5827,6509,7294,8213,9231,10264,11235,12151,13625,15237,
     16936,18731,20611,22560,24536,26481,28322,29988,31416,32915,34450,36018,
     37616,39242,40891,42562,44250,45951,47662,49378,51095,52810,54519,2006,
     116,83,72,59,54,51,48,44,39,34,32,39,55,80,107,134,156,172,181,190,201,
     205,203,195,184,173,165,162,165,170,176,183,192,203,217,235,256,281,310,
     340,372,409,452,501,555,612,673,739,812,892,980,1081,1194,1318,1452,1594,
     1745,1906,2077,2258,2451,2657,2879,3120,3386,3674,3977,4284,4597,4916,
     5262,5655,6118,6647,7231,7843,8472,9103,9749,10466,11273,12127,13012,
     13942,15033,16321,17666,18947,20145,21344,22684,24152,25767,27426,29014,
     30431,31784,33085,34324,35479,36553,37550,38471,39320,40101,40818,41475,
     42075,42624,1532,101,67,54,47,40,36,32,29,27,25,24,26,31,38,46,55,61,64,
     64,64,65,65,66,67,68,70,72,75,79,84,90,97,104,113,122,133,146,161,177,193,
     211,230,254,280,308,336,366,397,430,466,507,550,596,646,699,758,819,884,
     953,1027,1110,1203,1309,1429,1563,1713,1883,2075,2288,2513,2759,3048,3396,
     3803,4255,4740,5264,5829,6440,7128,7893,8702,9539,10427,11465,12685,13944,
     15144,16303,17570,19046,20617,22206,23758,25298,26762,28133,29413,30615,
     31742,32794,33772,34679,35517,36289,36999,37651,38248,38793,1231,92,66,53,
     43,39,37,34,30,24,19,19,28,46,71,96,118,137,151,163,175,186,193,193,189,
     183,177,172,168,167,166,165,166,169,175,184,196,209,224,240,261,287,316,
     348,382,420,463,514,573,639,706,775,850,934,1027,1125,1227,1338,1464,1605,
     1762,1933,2119,2316,2523,2738,2968,3218,3495,3805,4148,4516,4901,5295,
     5703,6146,6642,7180,7762,8394,9099,9886,10733,11613,12523,13507,14592,
     15691,16774,17875,19058,20389,21864,23453,25061,26617,28001,29311,30545,
     31703,32784,33791,34724,35588,36384,37117,37790,38407,38971,39486,965,77,
     51,37,30,28,26,23,21,18,17,16,19,25,32,40,47,52,54,55,56,57,57,58,58,58,
     58,59,60,63,65,68,72,77,83,90,99,109,119,130,143,158,174,192,211,231,254,
     280,310,343,376,410,447,488,532,579,628,681,742,811,889,975,1067,1162,
     1259,1359,1470,1595,1740,1907,2092,2294,2517,2760,3027,3315,3637,4015,
     4467,4995,5589,6239,6949,7713,8539,9463,10491,11534,12559,13617,14831,
     16231,17709,19198,20690,22228,23729,25173,26551,27859,29094,30255,31342,
     32355,33297,34168,34973,35715,36397,37022)
    temp2 <- c(
     4699,337,197,134,102,87,76,68,63,60,60,64,72,85,102,120,140,162,186,210,
     236,262,283,298,307,316,327,339,353,370,389,409,431,455,483,513,546,585,
     633,688,749,814,875,931,984,1038,1101,1183,1292,1422,1565,1710,1854,1994,
     2131,2273,2427,2589,2762,2947,3137,3335,3554,3801,4072,4365,4665,4953,
     5213,5448,5690,5944,6177,6375,6548,6673,6803,7037,7460,8065,8836,9668,
     10452,11038,11410,12280,13313,14588,16219,18166,20304,22519,24791,27050,
     29270,31416,32915,34450,36018,37616,39242,40891,42562,44250,45951,47662,
     49378,51095,52810,54519,3828,289,160,115,92,77,66,56,49,43,40,39,41,46,53,
     63,73,84,94,104,116,128,140,150,160,171,182,197,214,234,256,279,303,326,
     350,374,402,434,471,514,561,611,656,696,733,769,814,875,957,1058,1167,
     1279,1392,1504,1617,1731,1852,1983,2130,2287,2459,2632,2784,2901,2995,
     3072,3162,3296,3500,3762,4066,4372,4646,4853,5007,5127,5274,5510,5897,
     6420,7060,7731,8349,8813,9127,10205,11467,12972,14790,16879,19137,21496,
     23959,26478,28995,31416,32915,34450,36018,37616,39242,40891,42562,44250,
     45951,47662,49378,51095,52810,54519,3408,217,155,109,94,82,74,67,60,53,48,
     48,58,80,113,151,190,230,270,309,357,410,452,473,475,468,464,464,474,494,
     515,535,558,587,621,657,697,742,791,843,898,955,1016,1080,1149,1222,1298,
     1381,1472,1573,1683,1802,1927,2054,2182,2314,2453,2602,2763,2939,3127,
     3324,3532,3744,3959,4171,4389,4636,4935,5292,5714,6169,6617,7001,7318,
     7636,8001,8350,8666,8942,9160,9353,9587,9937,10418,11257,12156,13089,
     13980,14832,15687,16620,17656,18827,20064,21270,21795,22278,22723,23132,
     23506,23848,24160,24445,24705,24941,25155,25350,25526,25686,2765,189,130,
     90,68,62,52,45,39,35,33,33,36,44,54,67,80,93,103,111,121,132,141,150,157,
     164,173,183,195,210,225,242,262,286,313,343,373,405,438,472,507,542,581,
     624,672,725,779,836,892,950,1013,1081,1153,1229,1308,1392,1483,1581,1689,
     1809,1937,2073,2226,2392,2566,2738,2909,3093,3308,3561,3863,4194,4519,
     4790,5004,5208,5446,5704,5997,6321,6656,6991,7342,7716,8122,8747,9465,
     10282,11201,12222,13355,14548,15672,16605,17401,18220,18719,19180,19605,
     19996,20355,20684,20985,21259,21510,21738,21945,22134,22305,22460,2061,
     139,101,82,66,58,51,45,39,34,30,31,39,55,76,98,119,140,162,186,212,239,
     262,279,291,302,314,325,335,346,356,367,379,395,413,436,461,491,523,557,
     595,638,687,743,807,877,952,1036,1128,1225,1323,1424,1531,1648,1774,1905,
     2039,2174,2312,2459,2619,2794,2981,3172,3361,3545,3733,3936,4171,4445,
     4754,5084,5421,5742,6046,6356,6699,7083,7538,8088,8772,9578,10433,11190,
     11781,12406,13154,13945,14805,15729,16621,17527,18599,19866,21229,22554,
     23274,23944,24563,25135,25662,26146,26590,26996,27367,27706,28014,28295,
     28550,28782,1739,120,80,63,46,41,34,29,26,24,23,24,26,31,36,43,49,55,60,
     66,72,78,84,90,96,102,109,115,121,127,133,140,148,159,172,187,205,224,245,
     266,290,316,345,378,413,451,492,537,585,636,688,740,796,858,927,1001,1079,
     1161,1247,1340,1441,1552,1668,1785,1898,2007,2120,2253,2422,2631,2875,
     3138,3408,3659,3888,4114,4363,4648,5001,5442,5992,6626,7279,7834,8251,
     8685,9238,9881,10652,11547,12514,13529,14624,15791,17016,18279,19170,
     20022,20825,21577,22279,22930,23534,24091,24605,25077,25510,25907,26269,
     26600)
    temp3 <- c(
     2297,148,110,86,70,63,55,49,43,37,33,34,41,57,78,99,120,142,165,191,221,
     251,279,300,315,330,346,362,377,392,408,424,441,460,483,509,539,572,609,
     648,691,739,794,857,929,1007,1090,1181,1280,1384,1488,1594,1709,1835,1972,
     2116,2262,2408,2556,2711,2877,3058,3252,3452,3651,3846,4044,4260,4511,
     4804,5141,5501,5866,6202,6508,6814,7154,7537,7999,8566,9268,10087,10953,
     11714,12302,12872,13559,14282,15071,15928,16761,17617,18648,19888,21236,
     22554,23274,23944,24563,25135,25662,26146,26590,26996,27367,27706,28014,
     28295,28550,28782,1927,127,87,66,48,44,37,31,27,25,24,24,27,31,37,43,49,
     56,62,68,74,81,88,95,102,109,118,126,133,140,148,157,168,180,194,211,231,
     252,275,298,324,352,385,421,462,505,552,602,655,710,765,821,882,950,1026,
     1107,1192,1280,1372,1470,1577,1695,1817,1936,2050,2158,2272,2408,2587,
     2810,3072,3354,3639,3899,4132,4360,4615,4909,5282,5754,6350,7041,7751,
     8335,8744,9106,9591,10168,10886,11738,12656,13619,14672,15816,17027,18279,
     19170,20022,20825,21577,22279,22930,23534,24091,24605,25077,25510,25907,
     26269,26600)
    temp3 <- -log(1- c(temp1,temp2, temp2[1:440], temp3)/100000)/365.24

    # Add in the extrapolated data for 1990 and 2000
    temp <- array(0, c(110,2, 5, 3))
    temp[,,1:3,] <- temp3
    fix  <- c(.00061*(0:109) - .1271, .00041*(0:109) - .1770,
	       rep(c(-.00015*(0:109) - .0979, .00050*(0:109) - .1448), 2))
    temp[,,4,]   <- exp(log(temp[,,3,]) + fix)
    temp[,,5,]   <- exp(log(temp[,,4,]) + fix)

    attributes(temp) <- list (
	dim      =c(110,2,5,3),
	dimnames =list(0:109, c("male", "female"), 10* 196:200,
			      c("white", "nonwhite", "black")),
	dimid    =c("age", "sex", "year", "race"),
	factor   =c(0,1,10,1),
	cutpoints=list(0:109 * 365.24, NULL, mdy.date(1,1, 196:200*10), NULL),
	summary = function(R) {
		     x <- c(format(round(min(R[,1]) /365.24, 1)),
			    format(round(max(R[,1]) /355.24, 1)),
			    sum(R[,2]==1), sum(R[,2]==2),
			    sum(R[,4]==1), sum(R[,4]==2), sum(R[,4]==3))
		     x2<- as.character(as.date(c(min(R[,3]), max(R[,3]))))

		     paste("  age ranges from", x[1], "to", x[2], "years\n",
			   " male:", x[3], " female:", x[4], "\n",
			   " date of entry from", x2[1], "to", x2[2], "\n",
			   " white:",x[7], " nonwhite:", x[8]," black:", x[9],
			   "\n")
		     },
	class='ratetable')
    temp
    }
rm(temp, temp1, temp2, temp3)
