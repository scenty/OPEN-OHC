close all;clear all;
idepth=300;
cp=3850;rho=1025;
fdir='G:\EN4\'; % this is EN4 directory
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
z3d=repmat(z,[1 360 173]);

ohc_all=zeros(length(files),360,180)*nan;
for ii=1:length(files)
   fname=[fdir,files(ii).name] ;
   v0=ncread(fname,'temperature');v0(abs(v0)>1e3)=NaN;
   ohc28=get_ohcT(z,permute(v0,[3 1 2]),28);
   %v0=v0(:,:,1:end-1);
   %ohc=squeeze(nansum(cp.*rho.*v0.*dz.*iz,3));
   ohc28(ohc28==0)=NaN;
   
   ohc_all(ii,:,8:end)=ohc28;%!!!!!!!!!!notice that EN4 is from -83S to 89N!
   dd=strfind(fname,'g10.');
    yyyy=str2num(fname(dd+4:dd+7));
    mm=str2num(fname(dd+8:dd+9));
    time(ii)=datenum(yyyy,mm,1);
end
%calculate and save area matrix
load('D:\02-Data\ORAS5\ORAS5OHC300.mat','lon','lat');
Rearth=6371;
%xx=v1.lon;yy=v1.lat;
[xx,yy]=meshgrid(lon,lat);xx=xx';yy=yy';
dy=distance(yy(1:end-1,:),xx(1:end-1,:),yy(2:end,:),xx(2:end,:));dy=dy/180*pi*Rearth*1000;
dx=distance(yy(:,1:end-1),xx(:,1:end-1),yy(:,2:end),xx(:,2:end));dx=dx/180*pi*Rearth*1000;
dx(:,end+1)=dx(:,end);dy(end+1,:)=dy(end,:);
area = dx.*dy;
%%%%

output_name=['EN4OHC28.mat']
ohc_name=['ohc28']
eval([ohc_name,'=ohc_all;'])
eval(['save(output_name,''lon'',''area'',''lat'',''xx'',''yy'',''time'',''',ohc_name,''')'])