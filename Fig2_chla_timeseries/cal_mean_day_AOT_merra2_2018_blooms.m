tic, clc, clear,format long g,close all, warning of
x1=170; x2=190; y1=16; y2=28;
% x1=150; x2=210; y1=5; y2=28;
pth='Y:\SCS initial data\web\copernicus\AOT\daily\';
files=ls([pth,'*.nc4']);
[L,qq]=size(files); 
p=0;
       
for m=1:L
    in=[pth,files(m,:)]; 
    year(m)=str2num(files(m,27:30));
    month(m)=str2num(files(m,31:32));
    day(m)=str2num(files(m,33:34));
    lon=ncread(in,'lon');
            ilon=find(lon<0); lon(ilon)=lon(ilon)+360;
            lon2(1:length(lon)-length(ilon))=lon(length(ilon)+1:end); 
            lon2(length(lon)-length(ilon)+1:length(lon))=lon(1:length(ilon));
            lon=lon2; clear lon2
    lat=ncread(in,'lat');
    aot=ncread(in,'AODANA');
    aot=mean(aot,3,'omitnan');
    aot=aot';
        chl2(:,1:length(lon)-length(ilon))=aot(:,length(ilon)+1:end); 
        chl2(:,length(lon)-length(ilon)+1:length(lon))=aot(:,1:length(ilon)); %return
        aot=chl2; clear chl2  
    aotinc=ncread(in,'AODINC');
    aotinc=mean(aotinc,3,'omitnan');
    aotinc=aotinc';
        chl2(:,1:length(lon)-length(ilon))=aotinc(:,length(ilon)+1:end); 
        chl2(:,length(lon)-length(ilon)+1:length(lon))=aotinc(:,1:length(ilon)); %return
        aotinc=chl2; clear chl2         
        
    Ix=find(lon>=x1 & lon<=x2);
    Iy=find(lat>=y1 & lat<=y2);
    aot=aot(Iy,Ix);  aotinc=aotinc(Iy,Ix);

    aot_mean(m)=mean(reshape(aot,1,[]),'omitnan');
    aotinc_mean(m)=mean(reshape(aotinc,1,[]),'omitnan');
    aot_all(:,:,m)=aot;
    aotinc_all(:,:,m)=aotinc;

end
[xi,yi]=meshgrid(lon(Ix),lat(Iy));
% save('aot_daily_mean_150_210_5_28','aot_mean','aot_all',...
%     'year','month','day','aotinc_mean','aotinc_all','xi','yi')
save('aot_daily_mean_170_190_16_28','aot_mean','aot_all',...
    'year','month','day','aotinc_mean','aotinc_all','xi','yi')

toc