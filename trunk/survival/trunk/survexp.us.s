# SCCS $Id: survexp.us.s,v 4.1 1994-01-04 14:57:51 therneau Exp $
#
# Create the US total hazards table
#   The raw numbers below are q* 10^5.  Note that there are 24 leap years/100
#
survexp.us  <- {
    temp <- c(
    2913,181,115,88,74,66,60,55,51,47,44,44,50,62,78,97,114,131,145,156,169,
    180,187,187,181,175,169,167,169,174,181,189,199,210,224,240,259,281,308,
    338,373,412,455,501,551,605,665,735,818,911,1014,1120,1228,1333,1440,1549,
    1670,1809,1971,2154,2350,2554,2769,2992,3226,3474,3739,4017,4307,4612,
    4936,5285,5665,6083,6541,7035,7571,8176,8870,9661,10598,11654,12732,13728,
    14623,15768,17002,18343,19868,21564,23320,25056,26792,28481,30050,31416,
    32915,34450,36018,37616,39242,40891,42562,44250,45951,47662,49378,51095,
    52810,54519,2256,158,93,71,60,52,45,39,35,32,30,29,30,34,38,44,50,55,59,
    61,64,67,70,73,76,79,82,87,92,98,106,114,122,131,140,151,163,177,192,210,
    230,251,274,298,324,351,381,415,453,495,541,590,639,686,733,783,841,911,
    997,1097,1209,1327,1451,1578,1711,1854,2014,2199,2415,2661,2929,3219,3546,
    3914,4327,4767,5246,5804,6469,7240,8144,9143,10154,11096,11975,13423,
    15009,16689,18478,20364,22329,24327,26302,28181,29903,31416,32915,34450,
    36018,37616,39242,40891,42562,44250,45951,47662,49378,51095,52810,54519,
    2245,133,94,78,64,58,54,51,46,41,36,35,42,59,84,114,142,167,185,198,212,
    226,235,235,228,217,206,199,198,203,210,218,228,239,252,268,288,312,339,
    369,401,435,473,518,568,623,681,744,812,887,969,1059,1161,1275,1400,1534,
    1676,1827,1987,2158,2339,2532,2738,2960,3200,3463,3746,4044,4350,4665,
    4991,5344,5740,6193,6703,7264,7856,8462,9070,9688,10367,11125,11929,12770,
    13663,14730,15979,17281,18521,19681,20839,22122,23512,25023,26546,27962,
    29090,30135,31111,32017,32857,33633,34347,35004,35606,36157,36661,37121,
    37540,37922,1746,116,77,60,51,43,38,34,31,28,26,25,27,33,40,49,58,66,69,
    71,72,73,75,77,79,81,83,86,90,96,102,110,119,129,140,152,165,180,197,215,
    233,251,273,297,325,354,384,416,449,484,523,565,611,660,712,768,829,894,
    962,1035,1113,1200,1298,1411,1538,1678,1832,2004,2195,2407,2632,2879,3165,
    3503,3893,4325,4790,5295,5840,6432,7097,7834,8612,9419,10275,11282,12462,
    13685,14859,16006,17264,18718,20243,21750,23186,24584,25854,26980,27996,
    28949,29836,30659,31420,32122,32768,33361,33904,34401,34855,35269,1393,
    101,73,58,47,42,39,36,32,26,21,21,30,48,72,96,118,137,153,167,181,194,203,
    205,203,199,196,193,191,191,191,191,193,198,205,216,229,244,261,280,303,
    332,363,398,435,476,522,576,638,705,775,846,924,1010,1105,1206,1310,1423,
    1549,1690,1846,2016,2201,2398,2604,2817,3044,3289,3563,3868,4207,4571,
    4951,5338,5736,6167,6647,7170,7740,8365,9069,9859,10708,11579,12463,13419,
    14479,15554,16618,17700,18848,20125,21542,23080,24641,26149,27438,28654,
    29797,30867,31865,32792,33650,34443,35174,35845,36461,37024,37539,38009,
    1120,86,56,42,33,31,27,24,22,19,18,18,20,26,33,40,47,52,55,57,58,60,62,63,
    64,65,66,67,70,72,75,79,83,89,96,104,114,125,137,149,163,180,199,218,239,
    262,286,315,347,381,416,452,490,532,578,627,678,733,796,867,947,1035,1129,
    1226,1325,1427,1538,1664,1811,1980,2169,2375,2600,2842,3106,3388,3704,
    4073,4515,5033,5622,6269,6973,7722,8519,9409,10405,11420,12427,13471,
    14661,16024,17460,18904,20348,21823,23221,24560,25834,27040,28176,29242,
    30237,31163,32023,32817,33550,34224,34843,35411)

    temp <- -log(1- temp/100000)/365.24    #daily hazard rate
    attributes(temp) <- list (
	dim      =c(110,2,3),
	dimnames =list(0:109, c("male", "female"), c("1960", "1970", "1980")),
	dimid    =c("age", "sex", "year"),
	factor   =c(0,1,10),
	cutpoints=list(0:109 * 365.24, NULL, mdy.date(1,1, 6:8*10)),
	summary = function(R) {
		     x <- c(format(round(min(R[,1]) /365.24, 1)),
			    format(round(max(R[,1]) /355.24, 1)),
			    sum(R[,2]==1), sum(R[,2]==2))
		     x2<- as.character(as.date(c(min(R[,3]), max(R[,3]))))

		     paste("  age ranges from", x[1], "to", x[2], "years\n",
			   " male:", x[3], " female:", x[4], "\n",
			   " date of entry from", x2[1], "to", x2[2], "\n")
		     },
	class='ratetable')
    temp
    }