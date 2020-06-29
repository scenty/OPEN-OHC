

o1 = nansum(nansum(yp,2),3);

o2 = nansum(nansum(yt,2),3);

o1m=movmean(o1,12)-nanmean(o1);
o2m=movmean(o2,12)-nanmean(o2);

time = 1993+1/24:1/12:2019;

tr1 = polyfit(time(1:216)',ohc_int(1:216),1);
tr3 = polyfit(time(1:216)',o2m(1:216),1);


tr2 = polyfit(time(61:276)',o1m(61:276),1);
tr4 = polyfit(time(61:276)',o2m(61:276),1);