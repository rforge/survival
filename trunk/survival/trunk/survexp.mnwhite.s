# SCCS $Id: survexp.mnwhite.s,v 4.5 2000-06-12 09:42:16 boos Exp $
#
# Create the Minnesota white total hazards table
#   The raw numbers below are q* 10^5.  Note that there are 24 leap years/100
#
# For the first year, 1950, we had to recreate q from a derived table of
#   hazards.  This should have regenerated integer values, but didn't
#   quite.
#
survexp.mnwhite  <- {
    temp <- c(
     2712,176.8,141.1,95.9,78.4,75.4,72.4,69.3,65.2,65.3,65.3,67.4,72.7,84.1,
     98.8,115.5,132.3,142.9,150.4,153.8,156.1,156.4,157.7,154.8,151.8,147.8,
     144.9,143,142.1,145.5,146.8,152.3,161.1,173.1,187.3,205.9,226.8,248.8,
     273.2,299.9,329.1,360.7,397,435.9,478.6,523,571.4,625.1,680.9,737.8,801.6,
     870.3,952.4,1043.7,1141.3,1250.5,1367.2,1497,1631.1,1772.6,1926.3,2094.8,
     2285.2,2493.2,2715.4,2957,3219.5,3509.3,3811.9,4124.8,4467.6,4856.9,
     5309.7,5831.9,6412.1,7041.9,7711.1,8411.6,9116.9,9832.3,10601.5,11448.2,
     12410.5,13495.7,14680.4,15952.9,17299.1,18703.7,20197.2,21788.1,23435.3,
     25090.2,26712.6,28276.2,29862.5,31372.6,33061.2,34552.9,36024.8,37864.2,
     39062.6,41655.3,43420.3,45203.2,47004,48823,50659.9,52514.8,54387.6,
     56278.6,2165,140,108.5,72.8,61.5,57.5,51.3,48.3,45.2,42.2,40.1,39.1,38.1,
     40.2,43.3,46.4,48.5,52.6,54.7,57.8,59.9,63.1,65.2,66.3,66.3,68.4,68.5,
     71.6,73.8,76.9,81.2,86.4,92.8,102.2,112.8,125.4,139.2,153,166.9,179.8,
     195.9,212.1,234.8,259.7,290.2,321.9,355.1,387.4,418.1,446.8,477.1,512.2,
     556.5,607.1,666.3,730,801.9,882.1,966.7,1057.1,1157.3,1271.3,1405.1,
     1555.1,1717.9,1898.6,2103,2336.5,2590.5,2864.2,3165.1,3502.4,3888.4,
     4315.1,4774.8,5280.5,5836,6457.4,7139.4,7871.4,8662.6,9521.3,10452.9,
     11450.5,12509.7,13639.3,14854,16169.6,17581.8,19103.5,20705.3,22364.8,
     24064.8,25797.2,27623,29484,31358.8,33248.7,35107.7,36914,39009.4,40931.9,
     42965.3,45031.4,47129.9,49261.3,51425.3,53621.8,55850.9,58112.6,
     2470,147,97,78,66,63,60,58,54,49,45,44,49,60,78,96,114,131,146,160,175,
     188,193,186,172,154,138,129,128,135,144,154,161,167,171,177,186,202,226,
     257,293,330,369,407,447,489,536,593,662,742,830,920,1008,1088,1165,1244,
     1334,1441,1572,1723,1888,2061,2245,2439,2644,2861,3098,3363,3667,4007,
     4379,4777,5199,5644,6117,6619,7170,7798,8530,9373,10380,11515,12660,13690,
     14584,15696,16895,18228,19809,21622,23552,25471,27336,29018,30408,31416,
     32915,34450,36018,37616,39242,40891,42562,44250,45951,47662,49378,51095,
     52810,54519,1808,133,86,66,58,47,39,33,30,28,27,28,30,33,36,41,45,49,51,
     52,52,53,54,55,57,58,60,62,64,66,69,73,78,84,90,98,107,117,127,137,148,
     162,180,204,232,264,296,327,357,386,419,454,491,527,566,607,654,715,792,
     884,989,1100,1210,1313,1417,1526,1654,1822,2041,2306,2602,2916,3250,3600,
     3974,4364,4796,5315,5956,6715,7600,8569,9565,10526,11466,13063,14807,
     16620,18485,20398,22376,24393,26376,28252,29952,31416,32915,34450,36018,
     37616,39242,40891,42562,44250,45951,47662,49378,51095,52810,54519,1963,
     123,84,71,56,53,51,48,44,39,33,32,38,54,78,106,132,155,172,185,199,215,
     221,211,190,163,139,123,119,123,132,139,147,151,155,161,171,187,207,232,
     260,290,324,364,411,462,517,573,631,692,755,827,914,1022,1146,1283,1423,
     1560,1688,1813,1941,2085,2253,2456,2693,2961,3248,3539,3814,4078,4332,
     4612,4962,5419,5971,6581,7201,7826,8445,9082,9811,10650,11531,12404,13271,
     14340,15624,16981,18320,19632,20995,22519,24150,25847,27493,29014,30431,
     31784,33085,34324,35479,36553,37550,38471,39320,40101,40818,41475,42075,
     42624,1403,85,69,52,40,39,35,32,29,26,23,22,24,29,37,47,56,62,64,62,60,58,
     57,57,58,59,60,62,65,70,75,82,87,92,95,99,105,113,124,137,151,166,183,202,
     224,248,273,299,326,353,383,415,450,490,534,584,637,694,754,818,889,969,
     1055,1146,1247,1356,1481,1636,1826,2044,2276,2522,2796,3110,3466,3853,
     4269,4732,5252,5834,6491,7214,7983,8787,9649,10744,12025,13332,14556,
     15727,17016,18539,20189,21905,23615,25298,26762,28133,29413,30615,31742,
     32794,33772,34679,35517,36289,36999,37651,38248,38793,1125,78,63,51,44,38,
     35,32,28,23,18,18,26,44,66,88,107,123,135,146,157,168,173,170,162,151,141,
     133,127,125,122,119,118,120,125,132,141,151,161,172,186,205,227,251,279,
     309,345,391,449,516,587,658,728,796,865,938,1018,1110,1221,1349,1490,1642,
     1816,2013,2229,2464,2710,2958,3203,3451,3715,4006,4326,4683,5080,5510,
     5978,6497,7072,7702,8392,9135,9913,10718,11563,12594,13737,14904,16056,
     17238,18563,20094,21748,23433,25058,26617,28001,29311,30545,31703,32784,
     33791,34724,35588,36384,37117,37790,38407,38971,39486,874,50,41,35,31,29,
     27,25,23,19,16,15,17,21,28,35,41,45,48,49,50,52,52,51,49,47,45,43,44,45,
     48,50,54,58,63,70,78,87,96,105,116,129,143,158,174,192,211,233,255,278,
     301,326,355,390,430,475,521,569,618,671,728,792,866,951,1048,1155,1269,
     1388,1510,1640,1781,1942,2130,2351,2603,2872,3164,3504,3911,4382,4903,
     5460,6069,6736,7471,8399,9432,10511,11613,12785,14143,15697,17324,18947,
     20568,22228,23729,25173,26551,27859,29094,30255,31342,32355,33297,34168,
     34973,35715,36397,37022,
     749,49,34,28,24,22,21,20,18,15,13,13,17,29,45,64,81,95,104,109,114,
     118,120,118,115,111,108,106,107,109,112,114,118,123,130,138,147,155,
     163,171,180,191,203,219,237,260,287,317,347,379,415,460,512,573,643,
     719,804,897,1000,1110,1223,1341,1474,1626,1799,1982,2175,2389,2631,
     2905,3210,3542,3897,4263,4640,5033,5460,5939,6496,7143,7893,8719,9579,
     10417,11238,12192,13295,14471,15706,17012,18458,20048,21675,23260,
     24792,26329,27914,29399,30869,32413,34033,35735,37522,39398,41368,
     43436,45608,47888,50282,52797,545,46,30,23,18,17,15,14,13,12,11,11,13,
     16,22,28,34,39,41,42,43,44,44,42,41,39,38,37,37,37,38,39,41,46,52,60,
     67,76,85,94,104,115,126,138,149,163,179,197,216,238,262,290,321,354,
     390,428,472,524,585,652,724,797,867,935,1005,1077,1160,1262,1391,1545,
     1718,1902,2093,2286,2486,2694,2929,3216,3575,4004,4479,4989,5558,6191,
     6895,7754,8705,9725,10818,12018,13408,14976,16617,18271,19967,21737,
     23434,25091,26715,28318,30017,31818,33727,35750,37895,40169,42579,
     45134,47842,50712)

    temp2 <- -log(1- temp/100000)/365.24    #daily hazard rate

    #Add in the extrapolated data for 2000
    temp <- array(0, c(110,2,6))
    temp[,,1:5] <- temp2
    data.restore('survexp2000.sdump')
    temp[,,6] <- exp(log(temp[,,5]) + survexp.2000[,,"white"])

    attributes(temp) <- list (
	dim      =c(110,2,6),
	dimnames =list(0:109, c("male", "female"), 10* 195:200 ),
	dimid    =c("age", "sex", "year"),
	factor   =c(0,1,10),
	cutpoints=list(0:109 * 365.24, NULL, mdy.date(1,1, 195:200*10)),
	summary = function(R) {
		     x <- c(format(round(min(R[,1]) /365.24, 1)),
			    format(round(max(R[,1]) /365.24, 1)),
			    sum(R[,2]==1), sum(R[,2]==2))
		     x2<- as.character(as.date(c(min(R[,3]), max(R[,3]))))

		     paste("  age ranges from", x[1], "to", x[2], "years\n",
			   " male:", x[3], " female:", x[4], "\n",
			   " date of entry from", x2[1], "to", x2[2], "\n")
		     },
	class='ratetable')
    temp
    }
