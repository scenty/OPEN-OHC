%close all;
clear all;
idepth=2000;
cp=3850;rho=1025;
fdir='GLORYS\';
files=dir([fdir,'*.nc']);
fname=[fdir,files(1).name] ;
lon=ncread(fname,'longitude');lat=ncread(fname,'latitude');
lon=[lon(721:end);lon(1:720)+360];
z=ncread(fname,'depth');
%S=single(zeros(length(files),length(ix),length(iy),54));
z2=(z(2:end)+z(1:end-1))/2;z2=[0;z2];
dz=z2(2:end)-z2(1:end-1);
%z should be positive
iz=dz*0;
iz(z2<=idepth)=1;
idx=min(find(z2>=idepth));
iz(idx-1)=(idepth-z2(idx-1))./dz(idx-1);
if sum(iz.*dz)~=idepth; error('Integration depth error!'); end
%%
dz=permute(repmat(dz,[1 length(lon) length(lat)]),[2 3 1]);
iz=permute(repmat(iz,[1 length(lon) length(lat)]),[2 3 1]);


ohc_all=zeros(length(files),length(lon),length(lat))*nan;
for ii=1:length(files)
   fname=[fdir,files(ii).name] ;
   v0=ncread(fname,'temperature')-273.15;
   v0=v0(:,:,1:end-1);v0(abs(v0)>1e3)=NaN;
   v0=[v0(721:end,:,:); v0(1:720,:,:)];
   
   ohc=squeeze(nansum(cp.*rho.*v0.*dz.*iz,3));
   ohc(ohc==0)=NaN;
   
   ohc_all(ii,:,:)=ohc;%!!!!!!!!!!notice that EN4 is from -83S to 89N!
   dd=strfind(fname,'ean_');
    yyyy=str2num(fname(dd+4:dd+7));
    mm=str2num(fname(dd+8:dd+9));
    time(ii)=datenum(yyyy,mm,1);
end
%calculate and save area matrix
Rearth=6371;
[xx,yy]=meshgrid(lon,lat);xx=xx';yy=yy';
dy=distance(yy(1:end-1,:),xx(1:end-1,:),yy(2:end,:),xx(2:end,:));dy=dy/180*pi*Rearth*1000;
dx=distance(yy(:,1:end-1),xx(:,1:end-1),yy(:,2:end),xx(:,2:end));dx=dx/180*pi*Rearth*1000;
dx(:,end+1)=dx(:,end);dy(end+1,:)=dy(end,:);
area = dx.*dy;
%%%%

output_name=['GLORYSOHC',num2str(idepth),'.mat']
ohc_name=['ohc',num2str(idepth)]
eval([ohc_name,'=ohc_all;'])
eval(['save(output_name,''lon'',''area'',''lat'',''time'',''',ohc_name,''',''-v7.3'')'])

return


clear
load ARMOROHC2000.mat 
ohc2000(:,:,lat>=65.5|lat<=-63.5)=NaN;
lon(lon<0)=lon(lon<0)+360;
save ARMOROHC2000.mat -v7.3
ohc300=ohc2000;
area=permute(repmat(area,[1 1 size(ohc300,1)]),[3 1 2]);
tmp=nansum(reshape(ohc300.*area,[size(ohc300,1), size(ohc300,2)*size(ohc300,3)]),2);
plot(time,movmean(tmp-nanmean(tmp),12),'r--')
ohcarmor2000=tmp;
save armorGOHC ohcarmor* -append

tmp=ohcarmor300;
plot(time2,movmean(tmp-nanmean(tmp),12));hold on

