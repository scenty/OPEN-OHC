function trends = SegTrend(t,y,L)
% This  function first segment time-series into L-length pieces,
% then analyze the trend
Nt = length(t); Ny = length(y);
if Nt~=Ny error('Time should equal to the Y'); end
if Nt<L error('The length L should be longer than the time-series'); end

figure();plot(t,y);hold on
for ii=1:Ny+1-L  
    ynew=y(ii:ii+L-1);tnew=t(ii:ii+L-1);
    if size(ynew,2)~=1 ynew=ynew'; end
    if size(tnew,2)~=1 tnew=tnew'; end
    mask=~isnan(ynew+tnew);
    trends(ii,:)=polyfit(tnew(mask),ynew(mask),1);
    plot(tnew,tnew*trends(ii,1)+trends(ii,2),'-','color',[.5 .5 .5])
end

trends=trends(:,1);
end