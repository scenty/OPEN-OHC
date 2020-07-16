%close all;
clear all;
idepth=700;
cp=3850;rho=1025;
fdir='Levitus\';
files=dir([fdir,'*.nc']);
fname=[fdir,files(1).name] ;   
lon=double(ncread(fname,'lon'));lat=double(ncread(fname,'lat'));
ohc_all=zeros(length(files),length(lon),length(lat))*nan;
for ii=1:length(files)
   fname=[fdir,files(ii).name] ;
   
lon=double(ncread(fname,'lon'));lat=double(ncread(fname,'lat'));
z=double(ncread(fname,'depth'));
%S=single(zeros(length(files),length(ix),length(iy),54));
z2=(z(2:end)+z(1:end-1))/2;z2=[0;z2];
dz=z2(2:end)-z2(1:end-1);
%z should be positive
iz=double(dz)*0;
iz(z2<=idepth)=1;
idx=min(find(z2>=idepth));
iz(idx-1)=(idepth-z2(idx-1))./dz(idx-1);
if sum(iz.*dz)~=idepth; error('Integration depth error!'); end
%%
dz=permute(repmat(dz,[1 length(lon) length(lat)]),[2 3 1]);
iz=permute(repmat(iz,[1 length(lon) length(lat)]),[2 3 1]);


   v0=ncread(fname,'t_an');
   v0=v0(:,:,1:end-1);v0(abs(v0)>1e3)=NaN;
      
   ohc=squeeze(nansum(cp.*rho.*v0.*dz.*iz,3));
   ohc(ohc==0)=NaN;
   ohc(:,lat>=65.5|lat<=-63.5)=NaN;
   ohc_all(ii,:,:)=ohc;%!!!!!!!!!!notice that EN4 is from -83S to 89N!
   dd=strfind(fname,'nom_');
    %yyyy=str2num(fname(dd+4:dd+5))+1900;
    %mm=str2num(fname(dd+8:dd+9));
    time(ii)=datenum(ii/4+1955,1,1);
end

%calculate and save area matrix
Rearth=6371;
[xx,yy]=meshgrid(lon,lat);xx=xx';yy=yy';
dy=distance(yy(1:end-1,:),xx(1:end-1,:),yy(2:end,:),xx(2:end,:));dy=dy/180*pi*Rearth*1000;
dx=distance(yy(:,1:end-1),xx(:,1:end-1),yy(:,2:end),xx(:,2:end));dx=dx/180*pi*Rearth*1000;
dx(:,end+1)=dx(:,end);dy(end+1,:)=dy(end,:);
area = dx.*dy;
area=permute(repmat(area,[1 1 size(ohc_all,1)]),[3 1 2]);
tmp=nansum(reshape(ohc_all.*area,[size(ohc_all,1), size(ohc_all,2)*size(ohc_all,3)]),2);
plot(time,movmean(tmp-nanmean(tmp),12))
eval(['ohcLevitus',num2str(idepth),'=tmp;'])
save LevitusGOHC ohcLevitus* time -append
%%%%
ohc300Ref=nanmean(ohcLevitus300(inx));

output_name=['LevitusOHC',num2str(idepth),'.mat']
ohc_name=['ohc',num2str(idepth)]
eval([ohc_name,'=ohc_all;'])
eval(['save(output_name,''lon'',''area'',''lat'',''time'',''',ohc_name,''',''-v7.3'')'])

return


clear
ohc300=ohc2000;


tmp=ohcarmor300;
plot(time2,movmean(tmp-nanmean(tmp),12));hold on

