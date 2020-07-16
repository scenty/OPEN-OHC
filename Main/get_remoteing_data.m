%Obtain remoting sensing data and corresponding heat content data
cp=3850;
rho=1025;
dd=300;
for iy=2005:2018
    for im=1:12
        i=(iy-2005)*12+im;
        yyyy=num2str(iy);mm=num2str(im,'%02g');dddd=num2str(dd);
        %Get argo data
        path_in='G:\Data\';
        arg_grd  = netcdf.open([path_in,'argo_2005-2019_grd.nc'],'NC_NOWRITE');
        arg_CLIM = netcdf.open([path_in,'argo_CLIM_2005-2016_grd.nc'],'NC_NOWRITE');
        
        longitude = double(netcdf.getVar(arg_grd,0));
        latitude  = double(netcdf.getVar(arg_grd,1));
        [lon, lat] = (meshgrid(longitude,latitude));
        lon=lon';lat=lat';
        depth = double(netcdf.getVar(arg_grd,2));
        %get variables;
        arg_grd_TEMP = netcdf.getVar(arg_grd,4);
        arg_grd_SALT = netcdf.getVar(arg_grd,5);
        arg_grd_ADDEP = netcdf.getVar(arg_grd,8); %get the height data
        arg_CLIM_TEMP = netcdf.getVar(arg_CLIM,4);
        arg_CLIM_SALT = netcdf.getVar(arg_CLIM,5);
        arg_CLIM_ADDEP = netcdf.getVar(arg_CLIM,8);
        %set nan;
        arg_grd_TEMP(arg_grd_TEMP==-999.0) = nan;
        arg_grd_SALT(arg_grd_SALT==-999.0) = nan;
        arg_grd_ADDEP(arg_grd_ADDEP==-999.0) = nan;
        arg_CLIM_TEMP(arg_CLIM_TEMP<=-999.0) = nan;
        arg_CLIM_SALT(arg_CLIM_SALT<=-999.0) = nan;
        arg_CLIM_ADDEP(arg_CLIM_ADDEP<=-999.0) = nan;

    %%
    %Calculate the heat content of the corresponding depth

        alon=360;alat=180;Rearth=6371;
        dy=distance(lat(1:end-1,:),lon(1:end-1,:),lat(2:end,:),lon(2:end,:));dy=dy/180*pi*Rearth*1000;
        dx=distance(lat(:,1:end-1),lon(:,1:end-1),lat(:,2:end),lon(:,2:end));dx=dx/180*pi*Rearth*1000;
        dx(:,end+1)=dx(:,end);
        dy(end+1,:)=dy(end,:);
        temp=double(squeeze(arg_grd_TEMP(:,:,:,i)));%
        dep_choose=depth(depth<=dd);
        b=length(dep_choose);
        dep_interp=[];
        dep_interp(1)=dep_choose(1);
        dep_interp(2:b)=dep_choose(2:end)-dep_choose(1:end-1);
        z3d  = permute(repmat(dep_interp',[1 alon alat]),[2 3 1]); % repmat
        temp1 = squeeze(nansum(temp(:,:,1:b).*z3d,3));
        ohc=temp1*rho*cp.*dx.*dy;
        ohc(find(ohc==0))=nan;
        month = im;%
         %get time
        time=datenum(iy,month,15)-datenum(iy,1,1);
        clear alat alon arg_grd arg_grd_ADDEP arg_grd_SALT arg_grd_TEMP b dep_choose
        clear dep_interp  longitude latitude  Rearth  temp temp1 z3d
        clear arg_CLIM arg_CLIM_ADDEP arg_grd arg_grd_ADDEP  var_CLIM_SUR_ADDEP
        clear var_SUR_ADDEP var_SUR_SALT var_SUR_TEMP  var_CLIM_SALT arg_CLIM_SALT 
   
    
        %% Read satellite surface temperature data
        % 
        % 
        path_in_sst='G:\Data\OISSTm\';
        var_sst = load([path_in_sst,'SST',yyyy,'m',mm,'.mat'],'mvar');
        var_sst=var_sst.mvar;
        xlon=double(ncread([path_in_sst,'20190101120000-NCEI-L4_GHRSST-SSTblend-AVHRR_OI-GLOB-v02.0-fv02.0.nc'],'lon'));
        ylat=double(ncread([path_in_sst,'20190101120000-NCEI-L4_GHRSST-SSTblend-AVHRR_OI-GLOB-v02.0-fv02.0.nc'],'lat'));
        xlon=xlon+180;
        var_sst(var_sst>250) = nan;
        var_sst_grid = griddata(xlon,ylat,var_sst,lon,lat,'nearest');
        var_sst_grid(var_sst_grid>250) = nan;
        clear xx yy xlon ylat var_sst var_CLIM_SUR_TEMP arg_CLIM_TEMP
        clear i j r1 r2 r3 r4 s x x1 x2 y1 y2 y 
        %%
        %Acquisition of ocean altitude data (available from AVISO)
        path_in_dh='G:\Data\AVISO\';
        var_dh=load([path_in_dh,'ADT',yyyy,'m',mm,'.mat'],'mad');
        dh=var_dh.mad;
        clear var_dh month path_in_dh  dh_clim

        %%
        %Read satellite surface wind data
        path_in_ssw_clm='G:\Data\SSW_clm\';
        load([path_in_ssw_clm , 'var_CLIM_U_SUR_SSW_',mm,'.mat']);
        load([path_in_ssw_clm , 'var_CLIM_V_SUR_SSW_',mm,'.mat']);
        path_in_ssw=['G:\Data\SSW-monthly\',yyyy,'\'];
        fname=[path_in_ssw,'CCMP_Wind_Analysis_',yyyy,mm,'_V02.0_L3.5_RSS.nc']
        ssw_ccmp = netcdf.open(fname,'NC_NOWRITE');
        XLON = double(netcdf.getVar(ssw_ccmp,0));
        YLAT  = double(netcdf.getVar(ssw_ccmp,1));

        LON = 0.5:1:359.5;
        LAT = -78.5:1:77.5;

        [LON, LAT] = meshgrid(LON, LAT);
        [XLON,YLAT] = meshgrid(XLON, YLAT);

         var_u_wspd = netcdf.getVar(ssw_ccmp,3);
         var_v_wspd = netcdf.getVar(ssw_ccmp,4);
         var_u_wspd = double(var_u_wspd);
         var_v_wspd = double(var_v_wspd);
         var_u_wspd(var_u_wspd==-9999.0) = nan;
         var_v_wspd(var_v_wspd==-9999.0) = nan;
         var_u_wspd_grid = griddata(XLON,YLAT,var_u_wspd',LON,LAT,'nearest');
         var_v_wspd_grid = griddata(XLON,YLAT,var_v_wspd',LON,LAT,'nearest');
        % %calculate ssw anomaly;
        var_wspd_grid = sqrt(var_u_wspd_grid.^2 + var_v_wspd_grid.^2);
         var_ssw_grid= var_wspd_grid';
         var_u_ssw_grid=var_u_wspd_grid';var_v_ssw_grid=var_v_wspd_grid';
         clear  ssw_ccmp var_u_wspd  var_v_wspd  XLON YLAT
         clear LON LAT var_CLIM_SUR_SSW var_CLIM_U_SUR_SSW var_CLIM_V_SUR_SSW 
         clear var_wspd_grid var_u_wspd_grid var_v_wspd_grid

        %%
        %Remove the value containing nan in the data
        
        var_sst= reshape(var_sst_grid(1:360,12:168),360*157,1);
        var_ssw=reshape(var_ssw_grid,360*157,1);
        var_uw=reshape(var_u_ssw_grid,360*157,1);
        var_vw=reshape(var_v_ssw_grid,360*157,1);
        var_dh=reshape(dh(1:360,12:168),360*157,1);
        lon=reshape(lon(:,12:168),360*157,1);
        lat=reshape(lat(:,12:168),360*157,1);
        var_ohc=reshape(ohc(1:360,12:168),360*157,1);
        time=zeros(360*157,1)+time;
        clear var_sst_grid var_SUR_ADDEP var_sss_n dha mlda var_ssw_grid var_v_ssw_grid
        clear LON LAT ohc var_SUR_TEMP var_SUR_SALT var_sst_grid var_u_ssw_grid
        clear var_sst_anom var_sss_anom addepa var_ssw_grid_anmo atemp asal ohc ohc_clm

        %%
         %Find the non-null value of satellite data and remove the null value;
        index_notnan = find(~isnan(var_sst));
        var_sst_notnan = var_sst(index_notnan);
        var_ssw_notnan = var_ssw(index_notnan);
        var_uw_notnan=var_uw(index_notnan);
        var_vw_notnan=var_vw(index_notnan);
        var_dh_notnan=var_dh(index_notnan);
        var_lon_notnan =lon(index_notnan); 
        var_lat_notnan =lat(index_notnan);
        var_time=time(index_notnan);
        var_ohc_notnan=var_ohc(index_notnan);
        %aviso
        index_notnan = find(~isnan(var_dh_notnan));
        var_sst_notnan = var_sst_notnan(index_notnan);
        var_ssw_notnan = var_ssw_notnan(index_notnan);
        var_uw_notnan=var_uw_notnan(index_notnan);
        var_vw_notnan=var_vw_notnan(index_notnan);
        var_dh_notnan=var_dh_notnan(index_notnan);
        var_lon_notnan = var_lon_notnan(index_notnan); 
        var_lat_notnan = var_lat_notnan (index_notnan);
        var_time=var_time(index_notnan);
        var_ohc_notnan=var_ohc_notnan(index_notnan);
        %ohc
        index_notnan = find(~isnan(var_ohc_notnan));
        var_sst_notnan = var_sst_notnan(index_notnan);
        var_ssw_notnan = var_ssw_notnan(index_notnan);
        var_uw_notnan=var_uw_notnan(index_notnan);
        var_vw_notnan=var_vw_notnan(index_notnan);
        var_dh_notnan=var_dh_notnan(index_notnan);
        var_lon_notnan = var_lon_notnan(index_notnan); 
        var_lat_notnan = var_lat_notnan (index_notnan);
        var_time=var_time(index_notnan);
        var_ohc_notnan=var_ohc_notnan(index_notnan);
        clear index_notnan var_sst var_ssh var_sss LON_feature
        clear LAT_feature var_ohc var_temp var_sal var_ssw 

        %%
        
        sst=(var_sst_notnan);clear var_sst_notnan
        ssw=(var_ssw_notnan);clear var_ssw_notnan
        uw=(var_uw_notnan);clear var_uw_notnan
        vw=(var_vw_notnan);clear var_vw_notnan
        dh=(var_dh_notnan);clear var_dh_notnan
        lon=(var_lon_notnan);
        lat=(var_lat_notnan);
        time=(var_time);
        ohc=var_ohc_notnan;clear var_ohc_notnan
        
        %%
        %save data
        path_in_save =['E:\Data\',dddd,'\']; 
        save([path_in_save,'ar_',yyyy,mm],'sst','ssw','ohc','lat','lon','var_lon_notnan','var_lat_notnan','time','uw','vw','dh');
        %%
        %Clear the data to avoid affecting the next calculation
        clear tempa arg_mlda addepa ohc_anomly arg_lon lona lata arg_lat arg_time arg_sswa arg_uwa arg_vwa
        clear fname lat lata lon lona mlda mm ohc ohc_anomly path_in path_in_save
        clear path_in_sst path_in_ssw path_in_ssw_clm ssha sst_clim sst_clm ssta sswa time uwa var_addepa
        clear var_CLIM_SUR_SALT var_lat_notnan var_lon_notnan var_sst_clim var_time var_u_ssw_grid_anmo
        clear var_uw var_v_ssw_grid_anmo var_vw vwa wohc_anomly yyyy dha var_addepa depth dh  ohc_zs
        clear sst ssw uw v
    end
end