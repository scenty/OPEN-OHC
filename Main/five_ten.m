o2d = reshape(yp,[312 360*180]);
ohcp = movmean(nansum(o2d,2),12)-nanmean(ohcp);

o2d = reshape(yt,[312 360*180]);
ohc = movmean(nansum(o2d,2),12)-nanmean(ohc);


tr1=SegTrend(t,ohc,60); %60 months = 5 years
tr2=SegTrend(t,ohcp,60);
figure(1);
boxplot([tr1(:,1); tr2(:,1)])
boxplot([tr1(:,1) tr2(:,1)])
title('FIVE year')


% plot(IAP30010,IAP3005,'b',IAP70010,IAP7005,'g',IAP150010,IAP15005,'y',IAP200010,IAP20005,'r',OPEN30010,OPEN3005,'b',OPEN70010,OPEN7005,'g',OPEN150010,OPEN15005,'y',OPEN200010,OPEN20005,'r')
% legend('I5','I7','I15','I20','O5','O7','O15','O20')
% hold on
% plot(IAP310,IAP35,'.',OPEN310,OPEN35,'.',IAP710,IAP75,'.',OPEN710,OPEN75,'.',IAP1510,IAP155,'.',OPEN1510,OPEN155,'.',IAP2010,IAP205,'.',OPEN2010,OPEN205,'.')
% legend('5','op5','7','op7','15','Op15','20','Op20')
%%
t=1993:1/12:2019;
t=t(1:end-1);
IAP35=std(SegTrend(t,ohc,60));
OPEN35=std(SegTrend(t,ohcp,60));
IAP310=std(SegTrend(t,ohc,120));
OPEN310=std(SegTrend(t,ohcp,120));
%%
% IAP75=std(SegTrend(t,ohc,60));
% OPEN75=std(SegTrend(t,ohcp,60));
% IAP710=std(SegTrend(t,ohc,120));
% OPEN710=std(SegTrend(t,ohcp,120));
% %%
% IAP155=std(SegTrend(t,ohc,60));
% OPEN155=std(SegTrend(t,ohcp,60));
% IAP1510=std(SegTrend(t,ohc,120));
% OPEN1510=std(SegTrend(t,ohcp,120));
% %%
% IAP205=std(SegTrend(t,ohc,60));
% OPEN205=std(SegTrend(t,ohcp,60));
% IAP2010=std(SegTrend(t,ohc,120));
% OPEN2010=std(SegTrend(t,ohcp,120));