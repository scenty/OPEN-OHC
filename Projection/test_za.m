%本次实验的目的是为了利用2012年数据训练的模型对2015年12个月份的数据做预测
%目标数据为2015年700米数据
%create 2019/8/20
clear all;
close all;
clc
r2=[];
rmse=[];
inx=0;
mrmse=[];
y=1993:2018;
y=zscore(y);
%模式数据的整合
filepath='H:\张浩杰\100km\history\实验5.0\BCC\'
load([filepath,'BCC_2mon.mat'])
sh(1,:,:,:)=ssh;st(1,:,:,:)=sst;u(1,:,:,:)=uw;v(1,:,:,:)=vw;
filepath='H:\张浩杰\100km\history\实验5.0\Can\'
load([filepath,'Can_2mon.mat'])
sh(2,:,:,:)=ssh;st(2,:,:,:)=sst;u(2,:,:,:)=uw;v(2,:,:,:)=vw;
filepath='H:\张浩杰\100km\history\实验5.0\GIS\'
load([filepath,'GIS_2mon.mat'])
sh(3,:,:,:)=ssh;st(3,:,:,:)=sst;u(3,:,:,:)=uw;v(3,:,:,:)=vw;
filepath='H:\张浩杰\100km\history\实验5.0\MIR\'
load([filepath,'MIR_2mon.mat'])
sh(4,:,:,:)=ssh;st(4,:,:,:)=sst;u(4,:,:,:)=uw;v(4,:,:,:)=vw;
filepath='H:\张浩杰\100km\history\实验5.0\MRI\'
load([filepath,'MRI_2mon.mat'])
sh(5,:,:,:)=ssh;st(5,:,:,:)=sst;u(5,:,:,:)=uw;v(5,:,:,:)=vw;
clear ssh sst uw vw
ssh=squeeze(nanmean(sh));sst=squeeze(nanmean(st));uw=squeeze(nanmean(u));vw=squeeze(nanmean(v));
clear sh st u v
ssh(:,160:end,:)=nan;ssh(:,1:30,:)=nan;
sst(:,160:end,:)=nan;sst(:,1:30,:)=nan;
sst(sst==0)=nan;ssh(ssh==0)=nan;
uw(uw==0)=nan;vw(vw==0)=nan;
load('H:\张浩杰\100km\history\数据成果\IPS.mat')
ips_ohc=hc;
load('H:\张浩杰\100km\history\实验7.0\300\BCC\BCC.mat')
BCC_ohc=hc;
load('H:\张浩杰\100km\history\实验7.0\300\Can\Can.mat')
Can_ohc=hc;
load('H:\张浩杰\100km\history\实验7.0\300\GIS\GIS.mat')
GIS_ohc=hc;
load('H:\张浩杰\100km\history\实验7.0\300\MIR\MIR.mat')
MIR_ohc=hc;
load('H:\张浩杰\100km\history\实验7.0\300\MRI\MRI.mat')
MRI_ohc=hc;
% [lon,lat]=meshgrid(0.5:359.5,-89.5:89.5);
% lon=lon';lat=lat';
j=0;
for model=1:10
    m_year=num2str(model,'%02g')
    path='E:\多模型\三层\300\3-3\月变化\卫星数据\2.0\';
    load([path,'model',m_year,'.mat']);
    mkdir(m_year)
          inx=0;
          j=j+1;
    
    for iy=1850:2014;
         

        for im=1:12;
            inx=inx+1
           i_iap=(iy-1940)*12+im;
           mm=num2str(im,'%02g');
           ii=(iy-1850)*12+im;
            disp(im)
            [lon,lat]=meshgrid(0.5:359.5,-89.5:89.5);
             lon=lon';lat=lat';
            yyyy=num2str(iy);
            la=[];lo=[];ss=[];st=[];sw=[];eohc=[];usw=[];vsw=[];
            sh=[];hc=[];var_lon=[];t=[];var_lat=[];yy=[];
            h=squeeze(ssh(:,:,ii));
            s_t=squeeze(sst(:,:,ii));
            u=squeeze(uw(:,:,ii));
            v=squeeze(vw(:,:,ii));
            ips=squeeze(ips_ohc(:,:,ii));
            %
             BCC=squeeze(BCC_ohc(:,:,ii));
             Can=squeeze(Can_ohc(:,:,ii));
             GIS=squeeze(GIS_ohc(:,:,ii));
             MIR=squeeze(MIR_ohc(:,:,ii));
             MRI=squeeze(MRI_ohc(:,:,ii));
             %
            w=sqrt(u.^2+v.^2);
          
            time=zeros(360,180)+(datenum(iy,im,15)-datenum(iy,1,1));
            dh=reshape(h,360*180,1);
            s_t=reshape(s_t,360*180,1);
            w=reshape(w,360*180,1);
            u=reshape(u,360*180,1);
            v=reshape(v,360*180,1);
            lon=reshape(lon,360*180,1);
            lat=reshape(lat,360*180,1);
            time=reshape(time,360*180,1);
           
            ips=reshape(ips,360*180,1);
            %
            BCC=reshape(BCC,360*180,1);
            Can=reshape(Can,360*180,1);
            GIS=reshape(GIS,360*180,1);
            MIR=reshape(MIR,360*180,1);
            MRI=reshape(MRI,360*180,1);
            %去除数据中nan空值
            mask=find(~isnan(s_t)&~isnan(dh)&~isnan(w)&~isnan(ips)&~isnan(BCC)&~isnan(Can)&~isnan(GIS)&~isnan(MRI)&~isnan(MIR));
            h=dh(mask);
            s_t=s_t(mask);
            w=w(mask);
            u=u(mask);
            v=v(mask);
            lon=lon(mask);
            lat=lat(mask);
            time=time(mask);
           ips=ips(mask);
           BCC=BCC(mask);
           Can=Can(mask);
           GIS=GIS(mask);
           MIR=MIR(mask);
           MRI=MRI(mask);
%%
            la=[la;lat];lo=[lo;lon];
            st=[st;s_t];usw=[usw;u];vsw=[vsw;v];
            sw=[sw;w];sh=[sh;h];
            t=[t;time];
            var_lon=lo;var_lat=la;
         %%
            sh=(sh-sh_mean)/sh_std;
            st=(st-st_mean)/st_std;
            sw=(sw-sw_mean)/sw_std;
%             usw=(usw-uw_mean)/uw_std;
%             vsw=(vsw-vw_mean)/vw_std;
            t=cos(t/365*2*pi);
            lo=zscore(cosd(lo));
            la=zscore(la);
            tt=[sh st sw t lo la];

          
            
           
            y_predict=net(tt');
            ohc_pr=y_predict';
             open_ohc=ohc_pr*ohc_std+ohc_mean;
%             figure, plotregression(ohc_t',open_ohc)
           
            close all;
          
           

            %测试数据标准化

            path_in_save =['E:\多模型\三层\300\3-3\模式数据\9.0\',m_year,'\']; 
            save([path_in_save,'pr_',yyyy,mm],'open_ohc','var_lat','var_lon','mask','ips','Can','MRI','MIR','BCC','GIS');
        end

    end
% t=[ssha sssa];
end
