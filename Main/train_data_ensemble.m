%Ϊ��ѵ���������ݵ�ģ����������
%create2019/10/11
clear;
clc;
close all;
la=[];lo=[];ss=[];st=[];sw=[];vw=[];uw=[];
sh=[];hc=[];var_lon=[];t=[];var_lat=[];yy=[];
filepath='E:\����\300\300δ��׼��\';

Member_length=8;
for start_year=2005:2010
    end_year=start_year+Member_length;
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
%���ݵı�׼��
% [sh,ps_sh]=mapminmax(sh');
% [st,ps_st]=mapminmax(st');
% [sw,ps_sw]=mapminmax(sw');
% sh=sh';st=st';sw=sw';
    [sh,sh_mean,sh_std]=zscore(sh);
    [st,st_mean,st_std]=zscore(st);
    [sw,sw_mean,sw_std]=zscore(sw);
    t=cos(t/365*2*pi);
    lo=zscore(cosd(lo));
    la=zscore(la);
    %%
    xx=[sh st sw t lo la];
    ohc_xx=hc;
    %%
    %ģ�͵�ѵ��
    [net,tr]=drs_run(xx,ohc_xx);
    % [net,tr]=drs_run_loop(xx,ohc_xx,3,10
    path_in_save ='E:\��ģ��\'; 
   save([path_in_save,'model',yyyy],'net','sh_mean','sh_std','st_mean','st_std','sw_std','sw_std');
end