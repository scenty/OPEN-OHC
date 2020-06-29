clear
load OHCall.mat
glory300=ohcarmor300;
glory700=ohcarmor700;
glory1500=ohcarmor1500;
glory2000=ohcarmor2000;
ohc(:,1)=ohc2013;
ohc(:,2)=ohc2014;
ohc(:,3)=ohc2015;
ohc(:,4)=ohc2016;
ohc(:,5)=ohc2017;
ohc(:,6)=ohc2018;

Mlow=nanmean(ohc,2)+3*nanstd(ohc,[],2);Mlow=Mlow';
Mup=nanmean(ohc,2)-3*nanstd(ohc,[],2);Mup=Mup';
%plot(time,Mup,'color',[.5 .5 .5])
%plot(time,Mlow,'color',[.5 .5 .5])
fx=[time time(end) time(end:-1:1) time(1)];
fy=[Mlow Mup(end) Mup(end:-1:1) Mlow(1)];
clf
fp=fill(fx,fy,[.7 .7 .7]);hold on;fp.EdgeColor=[.7 .7 .7];
plot(time,nanmean(ohc,2),'k','linewidth',2);hold on
time2=datenum(1993,1:276,1);
plot(time2,movmean(glory300-nanmean(glory300),12),'linewidth',2);hold on
plot(time,ohc_en,'linewidth',2);hold on
plot(time,ohc_iap,'linewidth',2);hold on
load('D:\02-Data\ARMOR3D\armorGOHC.mat')
time3=datenum(1993,1:312,1);
plot(time3,movmean(ohcarmor300-nanmean(ohcarmor300),12),'linewidth',2);hold on
legend('OPEN+-3\sigma','OPEN','GLORYS2V4','EN4','IAP','ARMOR')