tic, clc, clear,format long g,close all, warning of
x1=160; x2=200; y1=16; y2=28;

% pth2='D:\data\';
pth2='Z:\SCS initial data\web\RSS\AMSR2\3day\';
files=ls([pth2,'*.nc']);
[L,qq]=size(files); %return
p=0;
for m=1:L
    in=[pth2,files(m,:)];
    rx=ncread(in,'lon');
    ry=ncread(in,'lat');
    sst=ncread(in,'SST'); 
    rain=ncread(in,'rain_rate');
    vapor=ncread(in,'water_vapor');
    cloud_liquid=ncread(in,'cloud_liquid_water');
    wspd_aw=ncread(in,'wind_speed_AW'); 
    wspd_MF=ncread(in,'wind_speed_MF');
    wspd_LF=ncread(in,'wind_speed_LF');
    
    Ix=find(rx>=x1 & rx<=x2);
    Iy=find(ry>=y1 & ry<=y2);
    [xi,yi]=meshgrid(rx(Ix),ry(Iy));    
    sst=sst(Ix,Iy)'; 
    rain=rain(Ix,Iy)';
    vapor=vapor(Ix,Iy)';   
    cloud_liquid=cloud_liquid(Ix,Iy)'; 
    wspd_aw=wspd_aw(Ix,Iy)'; 
    wspd_MF=wspd_MF(Ix,Iy)';
    wspd_LF=wspd_LF(Ix,Iy)';    
    
    [Tx,Ty]=my_gradient(xi,yi,sst);
    Tmag=sqrt(Tx.^2+Ty.^2);
    Tmagy=Ty;
    
    p=p+1;
    sst_mean(p)=mean(reshape(sst,1,[]),'omitnan');
    Tmagy_mean(p)=mean(reshape(Tmagy,1,[]),'omitnan');
    Tmag_mean(p)=mean(reshape(Tmag,1,[]),'omitnan');
    rain_mean(p)=mean(reshape(rain,1,[]),'omitnan');
    vapor_mean(p)=mean(reshape(vapor,1,[]),'omitnan');
    cloud_liquid_mean(p)=mean(reshape(cloud_liquid,1,[]),'omitnan');
    wspd_aw_mean(p)=mean(reshape(wspd_aw,1,[]),'omitnan');
    wspd_MF_mean(p)=mean(reshape(wspd_MF,1,[]),'omitnan');
    wspd_LF_mean(p)=mean(reshape(wspd_LF,1,[]),'omitnan');    
end
save('rain_daily_mean_160_200_16_28','rain_mean','vapor_mean'...
    ,'cloud_liquid_mean','Tmag_mean','Tmagy_mean','sst_mean'...
    ,'wspd_aw_mean','wspd_MF_mean','wspd_LF_mean')
toc