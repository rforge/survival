#  SCCS $Id: survexp.us.s,v 5.2 1998-12-17 17:49:48 therneau Exp $
#
# Create the US total hazards table
#   The raw numbers below are q* 10^5.  Note that there are 24 leap years/100
#
temp <- c(
    1571,1117,631,5238,553,289,201,162,145,130,119,111,106,105,107,113,124,
    139,157,176,194,211,228,246,261,274,283,288,292,297,304,314,325,338,
    352,369,388,409,433,459,488,520,556,595,639,687,740,799,863,932,1006,
    1086,1172,1264,1364,1472,1590,1716,1850,1993,2144,2302,2469,2647,2837,
    3041,3260,3497,3755,4037,4347,4687,5062,5477,5936,6444,7005,7618,8284,
    9002,9770,10590,11461,12386,13367,14404,15498,16643,17831,19055,20308,
    21582,22871,24168,25468,26763,28066,29362,30649,31929,33209,34497,35806,
    37153,38557,40033,41594,43243,44965,46723,48446,50029,51612,1214,813,
    514,4152,489,244,174,140,120,103,90,82,76,75,76,81,90,104,121,138,153,165,
    178,190,201,211,219,226,232,239,247,257,266,277,289,301,315,331,347,
    365,384,405,427,452,479,510,533,580,621,665,712,763,817,876,940,1009,
    1085,1167,1257,1354,1460,1575,1700,1837,1985,2147,2324,2519,2736,2978,
    3250,3554,3895,4274,4696,5163,5679,6243,6856,7519,8233,8997,9814,10687,
    11618,12609,13662,14772,15932,17138,18383,19661,20967,22296,23644,25005,
    26353,27692,29019,30327,31613,32879,34127,35368,36619,37903,39249,40691,
    42258,43978,45869,47941,50193,1148,912,315,3339,244,152,114,96,
    87,78,71,66,63,63,66,71,81,95,112,129,143,155,168,179,188,195,198,198,
    196,195,197,201,207,214,224,236,251,267,287,310,337,368,402,440,482,
    530,583,640,702,769,843,922,1005,1095,1193,1301,1420,1549,1686,1831,
    1984,2143,2308,2482,2668,2868,3078,3295,3528,3784,4070,4330,4711,5069,
    5464,5905,6389,6910,7472,8077,8726,9406,10113,10872,11704,12632,13672,
    14809,16018,17277,18562,19867,21209,22595,24032,25525,27089,28718,30394,
    32097,33807,35537,37301,39079,40852,42600,44319,46021,47714,49405,51100,
    52810,54520,873,647,253,2594,215,125,96,76,66,58,51,46,43,42,42,44,48,
    54,62,70,77,82,87,92,97,101,105,109,113,117,123,130,137,145,155,165,
    177,188,202,216,234,253,274,297,323,351,381,414,449,487,527,569,612,
    658,708,766,828,895,967,1048,1138,1238,1345,1462,1589,1728,1871,2016,
    2176,2364,2592,2858,3155,3484,3848,4251,4687,5153,5659,6213,6824,7488,
    8200,8964,9788,10678,11624,12621,13685,14830,16069,17409,18839,20352,
    21940,23595,25342,27185,29089,31017,32935,34866,36834,38802,40736,42600,
    44375,46084,47756,49419,51100,52810,54529,1157,752,229,2913,181,115,,
    88,74,66,60,55,51,47,44,44,50,62,78,97,114,131,145,156,169,180,187,187,
    181,175,169,167,169,174,181,189,199,210,224,240,259,281,308,338,373,
    412,455,501,551,605,665,735,818,911,1014,1120,1228,1333,1440,1549,1670,
    1809,1971,2154,2350,2554,2769,2992,3226,3474,3739,4017,4307,4612,4936,
    5285,5665,6083,6541,7035,7571,8176,8870,9661,10598,11654,12732,13728,
    14623,15768,17002,18343,19868,21564,23320,25056,26792,28481,30050,31416,
    32915,34450,36018,37616,39242,40891,42562,44250,45951,47662,49378,51095,
    52810,54519,898,538,183,2256,158,93,71,60,52,45,39,35,32,30,29,30,34,
    38,44,50,55,59,61,64,67,70,73,76,79,82,87,92,98,106,114,122,131,140,
    151,163,177,192,210,230,251,274,298,324,351,381,415,453,495,541,590,
    639,686,733,783,841,911,997,1097,1209,1327,1451,1578,1711,1854,2014,
    2199,2415,2661,2929,3219,3546,3914,4327,4767,5246,5804,6469,7240,8144,
    9143,10154,11096,11975,13423,15009,16689,18478,20364,22329,24327,26302,
    28181,29903,31416,32915,34450,36018,37616,39242,40891,42562,44250,45951,
    47662,49378,51095,52810,54519,984,555,159,2245,133,94,78,64,58,54,51,
    46,41,36,35,42,59,84,114,142,167,185,198,212,226,235,235,228,217,206,
    199,198,203,210,218,228,239,252,268,288,312,339,369,401,435,473,518,
    568,623,681,744,812,887,969,1059,1161,1275,1400,1534,1676,1827,1987,
    2158,2339,2532,2738,2960,3200,3463,3746,4044,4350,4665,4991,5344,5740,
    6193,6703,7264,7856,8462,9070,9688,10367,11125,11929,12770,13663,14730,
    15979,17281,18521,19681,20839,22122,23512,25023,26546,27962,29090,30135,
    31111,32017,32857,33633,34347,35004,35606,36157,36661,37121,37540,37922,
    758,405,134,1746,116,77,60,51,43,38,34,31,28,26,25,27,33,40,49,58,66,
    69,71,72,73,75,77,79,81,83,86,90,96,102,110,119,129,140,152,165,180,
    197,215,233,251,273,297,325,354,384,416,449,484,523,565,611,660,712,
    768,829,894,962,1035,1113,1200,1298,1411,1538,1678,1832,2004,2195,2407,
    2632,2879,3165,3503,3893,4325,4790,5295,5840,6432,7097,7834,8612,9419,
    10275,11282,12462,13685,14859,16006,17264,18718,20243,21750,23186,24584,
    25854,26980,27996,28949,29836,30659,31420,32122,32768,33361,33904,34401,
    34855,35269,503,278,152,1393,101,73,58,47,42,39,36,32,26,21,21,30,48,
    72,96,118,137,153,167,181,194,203,205,203,199,196,193,191,191,191,191,
    193,198,205,216,229,244,261,280,303,332,363,398,435,476,522,576,638,
    705,775,846,924,1010,1105,1206,1310,1423,1549,1690,1846,2016,2201,2398,
    2604,2817,3044,3289,3563,3868,4207,4571,4951,5338,5736,6167,6647,7170,
    7740,8365,9069,9859,10708,11579,12463,13419,14479,15554,16618,17700,
    18848,20125,21542,23080,24641,26149,27438,28654,29797,30867,31865,32792,
    33650,34443,35174,35845,36461,37024,37539,38009,421,212,126,1120,86,,
    56,42,33,31,27,24,22,19,18,18,20,26,33,40,47,52,55,57,58,60,62,63,64,
    65,66,67,70,72,75,79,83,89,96,104,114,125,137,149,163,180,199,218,239,
    262,286,315,347,381,416,452,490,532,578,627,678,733,796,867,947,1035,
    1129,1226,1325,1427,1538,1664,1811,1980,2169,2375,2600,2842,3106,3388,
    3704,4073,4515,5033,5622,6269,6973,7722,8519,9409,10405,11420,12427,
    13471,14661,16024,17460,18904,20348,21823,23221,24560,25834,27040,28176,
    29242,30237,31163,32023,32817,33550,34224,34843,35411,381,153,116,1039,
    78,54,42,35,31,28,26,23,20,17,17,25,42,64,89,112,130,142,148,155,161,
    167,170,173,174,176,180,187,196,205,215,224,234,245,257,270,282,293,
    304,315,328,344,365,390,421,457,496,537,580,630,689,755,828,909,995,
    1089,1197,1320,1455,1591,1730,1877,2039,2214,2397,2586,2793,3030,3301,
    3607,3945,4310,4690,5079,5492,5943,6430,6969,7576,8283,9078,9911,10718,
    11497,12378,13424,14560,15770,17058,18460,19998,21596,23158,24618,26004,
    27536,28943,30390,31910,33505,35181,36940,38787,40726,42762,44900,47145,
    49503,51978,318,116,92,828,68,42,32,25,24,21,19,17,16,15,15,18,22,28,
    35,41,46,49,50,52,54,56,57,58,59,60,62,66,70,75,80,85,90,95,101,107,
    115,123,132,142,153,166,180,198,218,242,268,295,324,356,394,434,476,
    520,566,618,677,745,819,895,972,1055,1146,1244,1348,1456,1574,1709,,
    1865,2042,2239,2457,2688,2930,3181,3456,3772,4151,4599,5106,5659,6265,
    6919,7631,8446,9376,10379,11442,12590,13918,15417,16951,18440,19922,
    21475,23143,24775,26375,27957,29635,31413,33298,35296,37413,39658,42038,
    44560,47233,50068)
temp <- array(temp/100000, dim=c(113,2,6))

#
# At this point temp is an array of age, sex, year.  
#  The first 3 ages are the q's for days 0-1, 1-7, and 7-28, the fourth
#  is the q for the entire first year.
# Change the array to one of daily hazard rates
#  For the 4th row, make it so the sum of the first year's hazard is correct,
#  i.e., 1*row1 + 6*row2 + 21*row3 + 337.24* row4 = -log(1-q)
temp2      <- -log(1- temp)/365.24    
temp2[1,,] <- -log(1-temp[1,,]) /1
temp2[2,,] <- -log(1-temp[2,,]) /6     #days 1-7
temp2[3,,] <- -log(1-temp[3,,]) /21    #days 7-28
temp2[4,,] <- (-log(1-temp[4,,]) -(temp2[1,,] + 6*temp2[2,,] + 21*temp2[3,,]))/
                   337.24
#
# Now, add in the year 2000 extrapolation
#
survexp.us <- array(0, dim=c(113,2,7))
survexp.us[,,1:6] <- temp2
data.restore('survexp2000.sdump')
for (i in 1:4) {
    survexp.us[i,,7] <- exp(log(temp2[i,,6]) + survexp.2000[1,,"total"])
    }
survexp.us[5:113,,7] <- exp(log(temp2[5:113,,6]) + survexp.2000[-1,,"total"])

attributes(survexp.us) <- list (
	dim      =c(113,2,7),
	dimnames =list(c('0-1d','1-7d', '7-28d', '28-365d', 
	  as.character(1:109)), c("male", "female"), 10*(194:200)),
	dimid    =c("age", "sex", "year"),
	factor   =c(0,1,10),
	cutpoints=list(c(0,1,7,28,1:109 * 365.24), NULL, 
	               mdy.date(1,1, (194:200)*10)),
	summary = function(R) {
		     x <- c(format(round(min(R[,1]) /365.24, 1)),
			    format(round(max(R[,1]) /355.24, 1)),
			    sum(R[,2]==1), sum(R[,2]==2))
		     x2<- as.character(as.date(c(min(R[,3]), max(R[,3]))))

		     paste("  age ranges from", x[1], "to", x[2], "years\n",
			   " male:", x[3], " female:", x[4], "\n",
			   " date of entry from", x2[1], "to", x2[2], "\n")
		     })
rm(temp, temp2, survexp.2000)    
oldClass(survexp.us) <- 'ratetable'
