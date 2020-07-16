%Comparison of accuracy between OPEN and IAP data
%time scale£ºyear
%create 2019/10/20
clear all;
close all;
clc
r2=[];
rmse=[];
inx=0;
mrmse=[];
y=1993:2018;
y=zscore(y);
path='Data\';
load([path,'net.mat']);
filepath='Data\'
for iy=1993:2018;
        yyyy=num2str(iy);
       la=[];lo=[];ss=[];st=[];sw=[];vw=[];uw=[];
       sh=[];hc=[];var_lon=[];t=[];var_lat=[];
       inx=inx+1;
        
    for im=1:12;
        mm=num2str(im,'%02g');
        disp(im)
        tim_pro=datenum(iy,im,15);
        fname=[filepath 'wa_' datestr(tim_pro,'yyyymm') '.mat'];
        load(fname);
        la=[la;lat];lo=[lo;lon];
        st=[st;sst];
        sw=[sw;ssw];sh=[sh;dh];
        hc=[hc;ohc];
        t=[t;time];
        var_lat=[var_lat;var_lat_notnan];
        var_lon=[var_lon;var_lon_notnan];
    end
        sh=(sh-sh_mean)/sh_std;
        st=(st-st_mean)/st_std;
        sw=(sw-sw_mean)/sw_std;
        t=cos(t/365*2*pi);
        lo=zscore(cosd(lo));
        la=zscore(la);
        t=[sh st sw t lo la];
        ohc_t=hc;
        ohc_std=std(ohc_t)
        y_predict=net(t');
        figure, plotregression(ohc_t',y_predict)
        [fitresult, gof] = createFit(ohc_t, y_predict);
        r2=gof.rsquare
        rmse=gof.rmse
        rrmse=rmse/ohc_std
        open=y_predict;iap=ohc_t;
        path_in_save =['Data\']; 
        save([path_in_save,'open_',yyyy,mm],'open','var_lat','var_lon','iap');
end


