load('D:\OneDrive\00-ZhangHJ-OHC-paper\重建数据\global\OHC700.mat')


tr1=SegTrend(1:312,ohc,60); %60 months = 5 years
tr2=SegTrend(1:312,ohcp,60);
figure
boxplot([tr1(:,1); tr2(:,1)])
boxplot([tr1(:,1) tr2(:,1)])
xticklabels({'IAP','OPEN'})


tr1=SegTrend(1:312,ohc,120); %60 months = 5 years
tr2=SegTrend(1:312,ohcp,120);
figure
boxplot([tr1(:,1); tr2(:,1)])
boxplot([tr1(:,1) tr2(:,1)])
xticklabels({'IAP','OPEN'})

tr1=SegTrend(1:312,ohc,15*12); %60 months = 5 years
tr2=SegTrend(1:312,ohcp,15*12);
figure
boxplot([tr1(:,1); tr2(:,1)])
boxplot([tr1(:,1) tr2(:,1)])
xticklabels({'IAP','OPEN'})