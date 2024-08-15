tic,close all, clc, clear,format long g
% x1=160; x2=200; y1=16; y2=28;
x1=170; x2=190; y1=18; y2=27;

pth='Y:\CMEMS\OCEANCOLOUR_GLO_BGC_L4_MY_009_104\CHL\2018\';
p=0;

% load('pixel_area_EarthCurve_160_200_16_28','area_xi'...
%             ,'area_yi','area_grid')
load('pixel_area_EarthCurve_170_190_18_27','area_xi'...
            ,'area_yi','area_grid')        
for m=5:8
    files=ls([pth,'\',num2str(m,'%2.2u'),'\','2018',num2str(m,'%2.2u'),'*.nc']);
    [L,qq]=size(files);  
    for n=1:L
        in=[pth,'\',num2str(m,'%2.2u'),'\',files(n,:)];
        day=files(n,1:8);
        lon=ncread(in,'lon');
        lat=ncread(in,'lat');       
        chl=ncread(in,'CHL');
%         err=ncread(in,'CHL_error');
        err=ncread(in,'CHL_uncertainty');
            lon=ncread(in,'lon');
            ilon=find(lon<0); lon(ilon)=lon(ilon)+360;
            lon2(1:length(lon)-length(ilon))=lon(length(ilon)+1:end); 
            lon2(length(lon)-length(ilon)+1:length(lon))=lon(1:length(ilon));
            lon=lon2; clear lon2
            chl=chl';
            chl2(:,1:length(lon)-length(ilon))=chl(:,length(ilon)+1:end); 
            chl2(:,length(lon)-length(ilon)+1:length(lon))=chl(:,1:length(ilon)); %return
            chl=chl2; clear chl2     
            err=err';
            chl2(:,1:length(lon)-length(ilon))=err(:,length(ilon)+1:end); 
            chl2(:,length(lon)-length(ilon)+1:length(lon))=err(:,1:length(ilon)); %return
            err=chl2; clear chl2  
        Ix=find(lon>=x1 & lon<=x2);
        Iy=find(lat>=y1 & lat<=y2);

        chl=chl(Iy,Ix);
        
        Inan=find(chl==-999); chl(Inan)=NaN;
        
        p=p+1; 
        I01=find(chl>=0.1); area01(p)=sum(area_grid(I01));
        I02=find(chl>=0.2); area02(p)=sum(area_grid(I02));
        I03=find(chl>=0.3); area03(p)=sum(area_grid(I03));
        I04=find(chl>=0.08); area04(p)=sum(area_grid(I04));
        err=err(Iy,Ix);
        chl_err=err.*chl/100;
        
        chl_mean(p)=mean(reshape(chl,1,[]),'omitnan');
        chl_std(p)=std(reshape(chl,1,[]),0,'omitnan');
        chl_max(p)=max(reshape(chl,1,[]),[],'omitnan');
        err_mean(p)=mean(reshape(chl_err,1,[]),'omitnan');
        chl_all(:,:,p)=chl;

    end
end
save('chl_daily_mean_170_190_18_27_preciseA_bgc',...
     'chl_mean','chl_std','chl_max','err_mean','chl_all',...
     'area01','area02','area03','area04')
% save('chl_daily_mean_160_200_16_28_preciseA_bgc','chl_mean','chl_std','chl_max','err_mean',...
%     'area01','area02','area03','area04')

toc