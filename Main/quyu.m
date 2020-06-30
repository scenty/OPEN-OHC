%研究区域海洋的变化趋势。
%AT表示大西洋 PA表示太平洋 IN表示印度洋 SO表示南大洋 t表示IAP数据 P表示预测数据
%%
%大西洋
load('D:\OneDrive\00-ZhangHJ-OHC-paper\重建数据\global\OHC700.mat')
load('G:\Data\ocean_basin.mat')
time=datenum(1993,1:312,15);
o=zeros(360,180);
o(o==0)=nan;
for inx=1:144;
    a(inx,:,:)=o;
end
ya=[a;ya];

iap=yt;pre=yp;
argo=ya;
in_t=iap(:,ocean_basin==3);
in_p=pre(:,ocean_basin==3);
in_ar=argo(:,ocean_basin==3);
pa_t=iap(:,ocean_basin==2);
pa_p=pre(:,ocean_basin==2);
pa_ar=argo(:,ocean_basin==2);
at_t=iap(:,ocean_basin==1);
at_p=pre(:,ocean_basin==1);
at_ar=argo(:,ocean_basin==1);
so_t=iap(:,ocean_basin==10);
so_p=pre(:,ocean_basin==10);
so_ar=argo(:,ocean_basin==10);


%大西洋
   ohc_att=nanmean(at_t,2);
   ohc_att=movmean(ohc_att,12);
   ohc_atp=nanmean(at_p,2);
   ohc_atp=movmean(ohc_atp,12);
tr1=SegTrend(1:312,ohc_att,60); %60 months = 5 years
tr2=SegTrend(1:312,ohc_atp,60);
figure
boxplot([tr1(:,1); tr2(:,1)])
boxplot([tr1(:,1) tr2(:,1)])
xticklabels({'IAP','OPEN'})
title('AO')
   %%
%太平洋
   ohc_pat=nanmean(pa_t,2);
   ohc_pat=movmean(ohc_pat,12);
   ohc_pap=nanmean(pa_p,2);
   ohc_pap=movmean(ohc_pap,12);
tr1=SegTrend(1:312,ohc_pat,60); %60 months = 5 years
tr2=SegTrend(1:312,ohc_pap,60);
figure
boxplot([tr1(:,1); tr2(:,1)])
boxplot([tr1(:,1) tr2(:,1)])
xticklabels({'IAP','OPEN'})
   %%
   
   %%
%印度洋
   tmp=in_t(145:312,:);
   ohc_int=nanmean(in_t,2)-nanmean(tmp(:));
   ohc_int=movmean(ohc_int,12);
   ohc_inp=nanmean(in_p,2);
   ohc_inp=movmean(ohc_inp,12);
   ohc_ina=nanmean(in_ar,2);
   ohc_ina=movmean(ohc_ina,12);
return
   %%

%南大洋
   ohc_sot=nanmean(so_t,2)-nanmean(nanmean(so_t(145:312,:),2),1);
   ohc_sot=movmean(ohc_sot,12);
   ohc_sop=nanmean(so_p,2)-nanmean(nanmean(so_p(145:312,:),2),1);
   ohc_sop=movmean(ohc_sop,12);
   ohc_soa=nanmean(so_ar,2)-nanmean(so_ar(:));
   ohc_soa=movmean(ohc_soa,12);
   %%
%    subplot(2,2,1)
%    clf;
%    plot(time,ohc_att,time,ohc_atp,time,ohc_ata);
%    grid on; datetick
%    legend('IAP','Pre','Argo')
%    title('Atlantic')
%    xlabel('Years');
%    ylabel('OHC Change')
%    subplot(2,2,2)
%    clf;
%    plot(time,ohc_int,time,ohc_inp,time,ohc_ina);
%    legend('IAP','Pre','Argo')
%    grid on; datetick
%    title('India')
%    xlabel('Years');
%    ylabel('OHC Change')
%    subplot(2,2,3)
%    clf;
%     plot(time,ohc_pat,time,ohc_pap,time,ohc_paa);
%    legend('IAP','Pre','Argo')
%    grid on; datetick
%    title('Pacific')
%    xlabel('Years');
%    ylabel('OHC Change')
%    subplot(2,2,4)
%    clf;
%    plot(time,ohc_sot,time,ohc_sop,time,ohc_soa);
%   legend('IAP','Pre','Argo')
%   grid on; datetick
%    title('South Ocean')
%    xlabel('Years');
%    ylabel('OHC Change')
   %%
   %绘制四大洋盆
   %大西洋
   figure(1)
   clf;
   plot(time,ohc_att,time,ohc_atp,time,ohc_ata,'linewidth',2); 
    legend('  IAP   :1.96x10^2^0 J','OPEN:1.86x10^2^0 J','  Argo :1.86x10^2^0 J')
   title('Atlantic Ocean'); xlabel('Year'); ylabel('OHC Anomaly (J)');
   set(gca,'fontsize',14,'xtick',727747:1826:737791,'tickdir','out','linewidth',1)
   datetick;box on;
   %印度洋
    figure(2)
   clf;hold on;box on
   plot(time,ohc_int,time,ohc_inp,time,ohc_ina,'linewidth',2);
  legend('  IAP   :2.09x10^2^0 J','OPEN:1.99x10^2^0 J','  Argo :2.01x10^2^0 J')
    title('Indian Ocean');xlabel('Year');ylabel('OHC Anomaly (J)')
   set(gca,'fontsize',14,'xtick',727747:1826:737791,'tickdir','out','linewidth',1)
   datetick
   %太平洋
   figure(3)
   clf;hold on;box on
   plot(time,ohc_pat,time,ohc_pap,time,ohc_paa,'linewidth',2);
   legend('  IAP   :2.14x10^2^0 J','OPEN:2.06x10^2^0 J','  Argo :2.05x10^2^0 J')
    title('Pacific Ocean');xlabel('Year');ylabel('OHC Anomaly (J)')
 set(gca,'fontsize',14,'xtick',727747:1826:737791,'tickdir','out','linewidth',1)
   datetick
   %南大洋
    figure(4)
    clf;hold on;box on
   plot(time,ohc_sot,time,ohc_sop,time,ohc_soa,'linewidth',2);
  legend('  IAP   :2.27x10^2^0 J','OPEN:2.20x10^2^0 J','  Argo :2.19x10^2^0 J')
 
   title('Southern Ocean');xlabel('Year');ylabel('OHC Anomaly (J)')
 set(gca,'fontsize',14,'xtick',727747:1826:737791,'tickdir','out','linewidth',1)
   datetick