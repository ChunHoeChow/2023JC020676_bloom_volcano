tic, clc, clear,format long g,close all, warning off
x1=160; x2=220; y1=10; y2=30;

% pth='V:\SCS initial data\web\copernicus\chl_interpolated_4km_daily\';
% pth='W:\CMEMS\chl_KD490_ZD\chl_interpolated_4km_daily\';
pth='W:\CMEMS\OCEANCOLOUR_GLO_BGC_L4_MY_009_104\CHL\2018\';
files=ls([pth,'*2018*.nc']); 
date_chl=files(:,1:8); %return
yr_chl=str2num(date_chl(:,1:4));
mn_chl=str2num(date_chl(:,5:6));
dd_chl=str2num(date_chl(:,7:8));
% return
% load('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\DATA_CTD_ARGO_XBT\argo_HLCC_water_data.mat','T_id','T_lon','T_lat','T_pres','T_pres_qc','T_temp','T_temp_qc','T_sal','T_sal_qc','gt')
load('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\DATA_CTD_ARGO_XBT\argo_HLCC_water_data_Feb_Sep_without_repeat_profile_ADJUSTED.mat',...
    'T_id','T_jd','T_lon','T_lat','T_pres','T_pres_qc','T_temp','T_temp_qc','T_sal','T_sal_qc','gt')  %% argo_5905058_profile_dataplot2

% return
I=find(T_id==5904056 & gt(:,2)>=6 & gt(:,2)<=10); %return
% myfigure
for m=1:length(I)
    pres=T_pres{I(m)};
    temp=T_temp{I(m)};
    salt=T_sal{I(m)};
    temp_qc=T_temp_qc{I(m)};
    salt_qc=T_sal_qc{I(m)};
    Iok=find(temp_qc=='1' & salt_qc=='1');
    pres=pres(Iok);
    temp=temp(Iok);
    salt=salt(Iok);
    pden = sw_pden(salt,temp,pres,0);
    
    
    time=gt(I(m),:);
    jd=T_jd(I(m));
    argo_lon=T_lon(I(m));
    argo_lat=T_lat(I(m));
    dep = sw_dpth(pres,argo_lat); %return
    
%     subplot(3,3,m)
%     plot(temp,dep)
%     set(gca,'ylim',[0 500],'ydir','reverse')
%     title([num2str(time(1)),'-',num2str(time(2),'%2.2u'),'-',num2str(time(3),'%2.2u')])
    dep_all(:,m)=[2:2:300];
    Iok=find(isfinite(dep)==1 & isfinite(temp)==1);
    temp_all(:,m)=interp1(dep(Iok),temp(Iok),[2:2:300]);
    salt_all(:,m)=interp1(dep(Iok),salt(Iok),[2:2:300]);
    pden_all(:,m)=interp1(dep(Iok),pden(Iok),[2:2:300]);
    lon_all(m)=argo_lon;
    lat_all(m)=argo_lat;
    jd_all(m)=jd;
    
    if time(2)==6, 
        mon_day=30; 
    else
        mon_day=31;
    end
    time_float=time(2)+(time(3)-1)/mon_day;
    time_all(:,m)=ones(1,150)*time_float;
    time_float=time(1)+(time(2)+(time(3)-1)/mon_day)/12;
    time_all_year(:,m)=ones(1,150)*time_float;
    
    Ichl=find(yr_chl==time(1) & mn_chl==time(2) & dd_chl==time(3)); 
    in=[pth,files(Ichl,:)]; %return
    chl = nc_varget(in,'CHL'); 
        lon = nc_varget(in,'lon'); ilon=find(lon<0); lon(ilon)=lon(ilon)+360;
        lon2(1:length(lon)-length(ilon))=lon(length(ilon)+1:end); 
        lon2(length(lon)-length(ilon)+1:length(lon))=lon(1:length(ilon));
        lon=lon2; clear lon2
        lat = nc_varget(in,'lat'); %return
        Ix=find(lon>=x1 & lon<=x2);
        Iy=find(lat>=y1 & lat<=y2);
        [chl_x,chl_y]=meshgrid(lon(Ix),lat(Iy));
    chl2(:,1:length(lon)-length(ilon))=chl(:,length(ilon)+1:end); 
    chl2(:,length(lon)-length(ilon)+1:length(lon))=chl(:,1:length(ilon)); %return
    chl=chl2; clear chl2
    
%     ix=find(lon>=140 & lon<=155);
%     iy=find(lat>=15 & lat<=25); 
    chl=chl(Iy,Ix);
    Ivalue=find(isfinite(chl)==1);
%     argo_chl=interp2(chl_x,chl_y,chl,argo_lon,argo_lat,'nearest');
    argo_chl=griddata(chl_x(Ivalue),chl_y(Ivalue),chl(Ivalue),argo_lon,argo_lat,'linear');
    Ichk=isnan(argo_chl);
    if Ichk==1
        Iok=find(isfinite(chl)==1);
        argo_chl=griddata(chl_x(Iok),chl_y(Iok),chl(Iok),argo_lon,argo_lat);
        argo_chl_qc=0;
    else
        argo_chl_qc=1;
    end
    argo_chl_all(m)=argo_chl;
    argo_chl_qc_all(m)=argo_chl_qc;
%     return
end

myfigure
subplot(5,1,1)
plot(time_all(1,:),argo_chl_all,'.-k')
I=find(argo_chl_qc_all==0);
hold on
plot(time_all(1,I),argo_chl_all(I),'ok')
set(gca,'xlim',[time_all(1,1) time_all(1,end)])
set(gca,'xlim',[6 9.9])
ylabel('CHL conc. (mg/m^3)')
title('Argo 5904056')

subplot(5,1,[2 3])
contourf(time_all,dep_all,temp_all,[1:1:32],'linecolor','none')
% contourf(time_all,pres_all,pden_all-1000,[1:0.25:32],'linecolor','none')
caxis([14 30])
colormap jet
% colorbar 
hold on
% [C,h]=contour(time_all,pres_all,temp_all,[18 18],'linecolor','m');
% clabel(C,h)
[C,h]=contour(time_all,dep_all,pden_all-1000,[1:0.5:32],'linecolor','k');
clabel(C,h)
plot(time_all,dep_all,'.k')
set(gca,'ylim',[0 200],'ydir','reverse')
set(gca,'xlim',[6 9.9])
ylabel('Depth (m)')

[m,n] = size(pden_all);
iup   = 1:m-1;
ilo   = 2:m;

pden_up = pden_all(iup,:);
pden_lo = pden_all(ilo,:);
dep_up = dep_all(iup,:);
dep_lo = dep_all(ilo,:);

mid_pden = (pden_up + pden_lo )/2;
mid_dep = (dep_up+dep_lo)/2;
dif_pden = pden_up - pden_lo;
dif_z    = dep_up - dep_lo;
n2       = 9.8 * dif_pden ./ (dif_z .* mid_pden);

subplot(5,1,[4 5])
% pcolor(time_all(1:end-1,:),mid_dep,n2); shading flat
% colorbar
contourf(time_all(1:end-1,:),mid_dep,n2,[-2:0.05:3]*10^-3,'linecolor','none')
caxis([0 0.5]*10^-3)
hold on
contour(time_all(1:end-1,:),mid_dep,n2,[0 0],'linecolor','w')
set(gca,'ylim',[0 200],'ydir','reverse')
set(gca,'xlim',[6 9.9])
ylabel('Depth (m)')
xlabel('Time (month)')

figure
prof=4;
subplot(1,2,1)
for prof=6:9

plot(n2(:,prof),mid_dep(:,prof))
hold on
plot([mean(n2(:,prof),'omitnan') mean(n2(:,prof),'omitnan')],[0 300],'k')
N2std=mean(n2(:,prof),'omitnan')+std(n2(:,prof),'omitnan'); 
plot([N2std N2std],[0 300],'k')
set(gca,'ydir','reverse','ylim',[0 300])
[xmax,imax,xmin,imin] = extrema(n2(:,prof));
plot(n2(imax,prof),mid_dep(imax,prof),'.r')
% N2max=n2(imax,22);
% Zmax=mid_dep(imax,22);
I=find(n2(imax,prof)>N2std);
plot(n2(imax(I(1)),prof),mid_dep(imax(I(1)),prof),'or')
end

subplot(1,2,2)
for prof=6:9
plot(temp_all(:,prof),dep_all(:,prof))
hold on
% plot([14 26],[mid_dep(imax(I(1)),prof) mid_dep(imax(I(1)),prof)],'r')
% plot([14 26],[dep_all(imax(I(1)),prof) dep_all(imax(I(1)),prof)],'g')

% [N2max,imax]=max(n2(:,prof));
% plot(n2(imax,prof),mid_dep(imax,prof),'ob')
% plot([14 26],[dep_all(imax,prof) dep_all(imax,prof)],'b')

set(gca,'ydir','reverse','ylim',[0 300])
end

save('argo_5904056_profile_dataplot_nocloud_ADJUSTED_BGC','time_all','jd_all','time_all_year','dep_all','temp_all','pden_all','salt_all','argo_chl_all','lon_all','lat_all','n2')

toc