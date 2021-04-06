load('G:\重建数据\OHC700.mat')

tr = zeros(size(yp,1)-60+1,360,128);

for ii = 1:360
   for jj = 1:128
       tmp = yp(:,ii,jj);
      if nanmean(tmp)~=nan
          for L=5:60  %check
           cff1=SegTrend(1:144,tmp,L);
           tr(1:length(cff1),ii,jj) = cff1; 
          end
      end
   end
    
end
tr(tr==0)=NaN;
for L=1:size(tr,1)
    wrk = squeeze(tr(L,:,:));
    mean_pos(L,:,:) = length(find(wrk>0))./ length(find(wrk));
    mean_neg(L,:,:) = length(find(wrk<0))./ length(find(wrk));
end

tr1=SegTrend(1:144,ohc,60); %60 months = 5 years
tr2=SegTrend(1:144,ohcp,60);
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