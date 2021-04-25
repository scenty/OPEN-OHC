clear;clc;
fdir='H:\’≈∫∆Ω‹\100km\history\ µ—È5.0\MPI\';
load([fdir,'MPI2.mat']);
% [slon,slat]=meshgrid(slon,slat);
% slon=slon';slat=slat';
[wlon,wlat]=meshgrid(wlon,wlat);
wlon=wlon';wlat=wlat'; 
lon=0.5:1:359.5;
lat=-89.5:1:89.5;
[lon lat]=meshgrid(lon,lat);
lon=lon';lat=lat';
ssh=zeros(360,180,1980);
sst=zeros(360,180,1980);
uw=zeros(360,180,1980);
vw=zeros(360,180,1980);
hssh=hsh;
for i=1:1980
    disp(i)
    bsh=squeeze(hssh(:,:,i));
    bst=squeeze(hsst(:,:,i));
    bua=squeeze(huw(:,:,i));
    bva=squeeze(hvw(:,:,i));
    sh=griddata(slon,slat,bsh,lon,lat);
    st=griddata(slon,slat,bst,lon,lat);
    ua=griddata(wlon,wlat,bua,lon,lat);
    va=griddata(wlon,wlat,bva,lon,lat);
%     h=sh(mask);sh=zeros(360,180);sh(mask)=h;
%     t=st(mask);st=zeros(360,180);st(mask)=t;
%     u=ua(mask);ua=zeros(360,180);ua(mask)=u;
%     v=va(mask);va=zeros(360,180);va(mask)=v;
    ssh(:,:,i)=sh;
    sst(:,:,i)=st;
    uw(:,:,i)=ua;
    vw(:,:,i)=va;
end
ssh(ssh==0)=nan;
sst(sst==0)=nan;
uw(uw==0)=nan;
vw(vw==0)=nan;
save([fdir,'MPI_2mon.mat'],'ssh','sst','uw','vw','lon','lat','time');

