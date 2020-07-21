%Created to train a model with years of data
%create2019/12/11
clear;
clc;
close all;
la=[];lo=[];ss=[];st=[];sw=[];vw=[];uw=[];
sh=[];hc=[];var_lon=[];t=[];var_lat=[];yy=[];
filepath='Data\';
Ensemble_length=8;

for start_year=2005:2010
    end_year=start_year+Ensemble_length;
    la=[];lo=[];ss=[];st=[];sw=[];vw=[];uw=[];
    sh=[];hc=[];var_lon=[];t=[];var_lat=[];yy=[];
    for iyear=start_year:end_year;
        disp(iyear); yyyy=num2str(iyear);
        i=iyear-1993+1;
        for imon=1:12;

            disp(imon)
            tim_pro=datenum(iyear,imon,15);
            fname=[filepath 'ar_' datestr(tim_pro,'yyyymm') '.mat'];
            load(fname);
            la=[la;lat];lo=[lo;lon];
            st=[st;sst];
            sw=[sw;ssw];sh=[sh;dh];
            hc=[hc;ohc];
            t=[t;time];
            var_lat=[var_lat;var_lat_notnan];
            var_lon=[var_lon;var_lon_notnan];
        end
    end
    %%
    %Standardization of data
    [sh,sh_mean,sh_std]=zscore(sh);%ssh
    [st,st_mean,st_std]=zscore(st);%sst
    [sw,sw_mean,sw_std]=zscore(sw);%ssw
    t=cos(t/365*2*pi);%time
    lo=zscore(cosd(lo));%lon
    la=zscore(la);%lat
    %%
    xx=[sh st sw t lo la];
    ohc_xx = hc; %1. non standarization
    ohc_xx=zscore(hc); %2. global standarization
    ohc_xx=hc; % 3. local standarization
    %%
    %Model training
    [net,tr]=drs_run_loop(xx,ohc_xx,3,3);
    %[net,tr]=drs_run(xx,ohc_xx); %
    path_in_save ='Data\'; 
   save([path_in_save,'model',yyyy],'net','sh_mean','sh_std','st_mean','st_std','sw_std','sw_std');
end