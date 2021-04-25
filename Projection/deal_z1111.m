%CMIP6数据提取
%%
close all;clear all;clc;
fdir='H:\张浩杰\100km\history\';
files=dir([fdir,'zos_Omon_MIROC6_historical_r1i1p1f1*.nc']);
for ii=1:length(files)
   fname=[fdir,files(ii).name] 

   v1=ncread(fname,'longitude');
   v2=ncread(fname,'latitude');
%    v1=ncread(fname,'lon');
%    v2=ncread(fname,'lat');
   v3=ncread(fname,'time');
%    v0=squeeze(v0);
   v0=ncread(fname,'zos');

   output_name=[num2str(fname(31:33)),'_SSH',num2str(ii,'%02g'),'.mat']
   ssh=[num2str(fname(31:33)),'SSH']

    lon=[num2str(fname(31:33)),'lon']
    
    lat=[num2str(fname(31:33)),'lat']
    time=[num2str(fname(31:33)),'time'] 
    eval([ssh,'=v0;'])
    eval([lon,'=v1;'])  
    eval([lat,'=v2;'])
    eval([time,'=v3;'])
    save([fdir,'实验5.0\MIR\',output_name],lon,lat,time,ssh);
end
%%
%提取模式数据的热膨胀系数
clear;clc;
close all;
fdir='H:\张浩杰\100km\history\';
file=dir([fdir,'zostoga_Omon_MIROC6_historical_r1i1p1f1*.nc']);
for ii=1:length(file)
   fm=[fdir,file(1).name]
   MIRTH=ncread(fm,'zostoga');
   output_name=(['MIR_TH',num2str(ii,'%02g'),'.mat']);
    save([fdir,'实验5.0\MIR\',output_name],'MIRTH');
end
%%
close all;clear all;
fdir='H:\张浩杰\100km\history\';
files=dir([fdir,'tos_Omon_MIROC6_historical_r1i1p1f1*.nc']);

for ii=1:length(files)
   fname=[fdir,files(ii).name] 
   
   v1=ncread(fname,'longitude');
   v2=ncread(fname,'latitude');
%    v1=ncread(fname,'lon');
%    v2=ncread(fname,'lat');
   v3=ncread(fname,'time');

   v0=ncread(fname,'tos');
   output_name=[num2str(fname(31:33)),'_SST',num2str(ii,'%02g'),'.mat']
    sst=[num2str(fname(31:33)),'SST']
    
    lon=[num2str(fname(31:33)),'lon']
    
    lat=[num2str(fname(31:33)),'lat']
    time=[num2str(fname(31:33)),'time']
    eval([sst,'=v0;'])
    eval([lon,'=v1;'])  
    eval([lat,'=v2;'])
    eval([time,'=v3;'])
    save([fdir,'实验5.0\MIR\',output_name],lon,lat,time,sst);
end
%%
close all;clear all;
fdir='H:\张浩杰\100km\history\';
files=dir([fdir,'ua_Amon_MIROC6_historical_r1i1p1f1*.nc']);
for ii=1:length(files)
   fname=[fdir,files(ii).name] 
   
%    v1=ncread(fname,'longitude');
%    v2=ncread(fname,'latitude');
   v1=ncread(fname,'lon');
   v2=ncread(fname,'lat');
   v3=ncread(fname,'time');
   v0=ncread(fname,'ua',[1 1 2 1],[length(v1) length(v2) 1 length(v3)]);
   v0=squeeze(v0);
   output_name=[num2str(fname(30:32)),'_2UA',num2str(ii,'%02g'),'.mat']
    ua=[num2str(fname(30:32)),'UA']
    
    lon=[num2str(fname(30:32)),'lon']
    
    lat=[num2str(fname(30:32)),'lat']
    time=[num2str(fname(30:32)),'time']
    eval([ua,'=v0;'])
    eval([lon,'=v1;'])  
    eval([lat,'=v2;'])
    eval([time,'=v3;'])
    save([fdir,'实验5.0\MIR\',output_name],lon,lat,time,ua);
end
%%
close all;clear all;
fdir='H:\张浩杰\100km\history\';
files=dir([fdir,'va_Amon_MIROC6_historical_r1i1p1f1*.nc']);
for ii=1:length(files)
   fname=[fdir,files(ii).name] 
   
% %    v1=ncread(fname,'longitude');
% %    v2=ncread(fname,'latitude');
   v1=ncread(fname,'lon');
   v2=ncread(fname,'lat');
   v3=ncread(fname,'time');
   v0=ncread(fname,'va',[1 1 2 1],[length(v1) length(v2) 1 length(v3)]);
   v0=squeeze(v0);
   output_name=[num2str(fname(30:32)),'_2VA',num2str(ii,'%02g'),'.mat']
    va=[num2str(fname(30:32)),'VA']
    
    lon=[num2str(fname(30:32)),'lon']
    
    lat=[num2str(fname(30:32)),'lat']
    time=[num2str(fname(30:32)),'time']
    eval([va,'=v0;'])
    eval([lon,'=v1;'])  
    eval([lat,'=v2;'])
    eval([time,'=v3;'])
    save([fdir,'实验5.0\MIR\',output_name],lon,lat,time,va);
end
%%
%提取数据并对数据进行整合
%首选是数据都变成一整套
clear
clc
time=zeros(1980,1);
%
fdir='H:\张浩杰\100km\history\实验5.0\MIR\';
files=dir([fdir,'MIR_SSH*.mat']);
v=0;

for ii=1:length(files)
   fname=[fdir,files(ii).name] 
   load(fname)
   vv=length(MIRtime);%
   v1=v+1;
   v=v+vv;
   hssh(:,:,v1:v)=MIRSSH;
end
%%
files=dir([fdir,'MIR_TH*.mat']);
v=0;

for ii=1:length(files)
   fname=[fdir,files(ii).name] 
   load(fname)
   vv=length(MIRTH);%
   v1=v+1;
   v=v+vv;
   hth(v1:v,1)=MIRTH;
end
th= permute(repmat(hth,[1 length(hssh(:,1,1)) length(hssh(1,:,1))]),[2 3 1]);
hsh=hssh+th;
%%
%

files=dir([fdir,'MIR_SST*.mat']);
v=0;

for ii=1:length(files)
   fname=[fdir,files(ii).name] 
    load(fname)
   vv=length(MIRtime);%
   v1=v+1;
   v=v+vv;
   hsst(:,:,v1:v)=MIRSST;
end
slon=MIRlon;slat=MIRlat;%
clear MIRlon MIRlat
%%
%

files=dir([fdir,'MIR_2UA*.mat']);
v=0;

for ii=1:length(files)
   fname=[fdir,files(ii).name] 
   load(fname)
   vv=length(MIRtime);%
   v1=v+1;
   v=v+vv;
   huw(:,:,v1:v)=MIRUA;
end
%%
%

files=dir([fdir,'MIR_2VA*.mat']);
v=0;

for ii=1:length(files)
   fname=[fdir,files(ii).name] 
   load(fname)
   vv=length(MIRtime);%
   v1=v+1;
   v=v+vv;
   hvw(:,:,v1:v)=MIRVA;
   time(v1:v,1)=MIRtime;
end
wlon=MIRlon;wlat=MIRlat;

%%
save([fdir,'MIR2.mat'],'hssh','hsst','huw','hvw','slon','slat','wlon','wlat','time','hsh');