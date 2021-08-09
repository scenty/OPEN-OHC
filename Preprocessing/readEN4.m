close all;clear all;
idepth=300;
cp=3850;rho=1025;
fdir='D:\02-Data\EN4\'; % this is EN4 directory
files=dir([fdir,'EN*.nc']);
fname=[fdir,files(1).name] ;

lon=ncread(fname,'lon');lat=ncread(fname,'lat');
z=ncread(fname,'depth');
z2=(z(2:end)+z(1:end-1))/2;z2=[0;z2];
dz=z2(2:end)-z2(1:end-1);
%z should be positive
iz=dz*0;
iz(z2<=idepth)=1;
idx=min(find(z2>=idepth));
iz(idx-1)=(idepth-z2(idx-1))./dz(idx-1);
if sum(iz.*dz)~=idepth; error('Integration depth error!'); end
%%
dz=permute(repmat(dz,[1 360 173]),[2 3 1]);
iz=permute(repmat(iz,[1 360 173]),[2 3 1]);


ohc_all=zeros(length(files),360,180)*nan;
for ii=1:length(files)
   fname=[fdir,files(ii).name] ;
   v0=ncread(fname,'temperature');v0=v0(:,:,1:end-1);v0(abs(v0)>1e3)=NaN;
   ohc=squeeze(nansum(cp.*rho.*v0.*dz.*iz,3));
   ohc(ohc==0)=NaN;
   
   ohc_all(ii,:,8:end)=ohc;%!!!!!!!!!!notice that EN4 is from -83S to 89N!
   dd=strfind(fname,'g10.');
    yyyy=str2num(fname(dd+4:dd+7));
    mm=str2num(fname(dd+8:dd+9));
    time(ii)=datenum(yyyy,mm,1);
end
%calculate and save area matrix
v1=load('D:\04-工作\学生\20测绘-黄磊\shuju\model-data\ORAS5\ORAS5OHC300.mat','lon','lat');
[xx,yy]=meshgrid(v1.lon,v1.lat);
Rearth=6371;

dy=distance(yy(1:end-1,:),xx(1:end-1,:),yy(2:end,:),xx(2:end,:));dy=dy/180*pi*Rearth*1000;
dx=distance(yy(:,1:end-1),xx(:,1:end-1),yy(:,2:end),xx(:,2:end));dx=dx/180*pi*Rearth*1000;
dx(:,end+1)=dx(:,end);dy(end+1,:)=dy(end,:);
area = dx.*dy;
area=permute(repmat(area,[1 1 size(ohc_all,1)]),[3 1 2]);
tmp=nansum(reshape(ohc_all.*area,[size(ohc_all,1), size(ohc_all,2)*size(ohc_all,3)]),2);
plot(time,movmean(tmp-nanmean(tmp),12))
eval(['ohcEN4',num2str(idepth),'=tmp;'])
save EN4GOHC ohcEN4* -append
%%%%

output_name=['EN4OHC',num2str(idepth),'.mat']
ohc_name=['ohc',num2str(idepth)]
eval([ohc_name,'=ohc_all;'])
eval(['save(output_name,''lon'',''area'',''lat'',''time'',''',ohc_name,''')'])



return

idepth=1500
load(['EN4OHC',num2str(idepth),'.mat'])
ohc_all=ohc1500;
v1=load('D:\04-工作\学生\20测绘-黄磊\shuju\model-data\ORAS5\ORAS5OHC300.mat','lon','lat');
[xx,yy]=meshgrid(v1.lon,v1.lat);xx=xx';yy=yy';
Rearth=6371;
dy=distance(yy(1:end-1,:),xx(1:end-1,:),yy(2:end,:),xx(2:end,:));dy=dy/180*pi*Rearth*1000;
dx=distance(yy(:,1:end-1),xx(:,1:end-1),yy(:,2:end),xx(:,2:end));dx=dx/180*pi*Rearth*1000;
dx(:,end+1)=dx(:,end);dy(end+1,:)=dy(end,:);
area = dx.*dy;
area=permute(repmat(area,[1 1 size(ohc_all,1)]),[3 1 2]);
tmp=nansum(reshape(ohc_all.*area,[size(ohc_all,1), size(ohc_all,2)*size(ohc_all,3)]),2);
plot(time,movmean(tmp-nanmean(tmp),12))
eval(['ohcEN4',num2str(idepth),'=tmp;'])
save EN4GOHC ohcEN4* -append


area=permute(repmat(area,[1 1 size(ohc2000,1)]),[3 1 2]);
tmp=nansum(reshape(ohc2000.*area,[360, 360*180]),2);
plot(time,movmean(tmp-nanmean(tmp),12))


