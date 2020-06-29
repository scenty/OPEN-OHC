clf
offset = .5e16;
depth = {'300','700','1500','2000'};
depth = {'300'};
year = {'5','10'};
dataset= {'OPEN','IAP'};
cc = ['rbcg']
color = cool(4);
marker='x.'
basin = {'I','A','P','S'}


plot(OPEN35,OPEN310,marker(1),'color',color(1,:));hold on
text(OPEN35,OPEN310,'G','color',color(1,:))
plot(OPEN75,OPEN710,marker(1),'color',color(2,:))
text(OPEN75,OPEN710,'G','color',color(2,:))
plot(OPEN155,OPEN1510,marker(1),'color',color(3,:))
text(OPEN155,OPEN1510,'G','color',color(3,:))
plot(OPEN205,OPEN2010,marker(1),'color',color(4,:))
text(OPEN205,OPEN2010,'G','color',color(4,:))
plot(IAP35,IAP310,marker(2),'color',color(1,:));hold on
text(IAP35,IAP310,'G','color',color(1,:))
plot(IAP75,IAP710,marker(2),'color',color(2,:))
text(IAP75,IAP710,'G','color',color(2,:))
plot(IAP155,IAP1510,marker(2),'color',color(3,:))
text(IAP155,IAP1510,'G','color',color(3,:))
plot(IAP205,IAP2010,marker(2),'color',color(4,:))
text(IAP205,IAP2010,'G','color',color(4,:))

for ii=1:length(depth)

    for kk=1:length(dataset)
v1=[dataset{kk},depth{ii},year{1}];
v2=[dataset{kk},depth{ii},year{2}];

eval(['plot(',v1,',',v2,',marker(kk),','''color'',[',num2str(color(ii,:)),'])'])
eval(['text(',v1,',',v2,'+offset'',basin,''color'',color(ii,:))'])
hold on
    end

end

