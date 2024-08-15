tic,close all, clc, clear,format long g
x1=150; x2=210; y1=15; y2=29;


pth='Y:\CMEMS\chl_KD490_ZD\chl_interpolated_4km_daily\';
p=0;
Imask_all=[];
m=5; 

    files=ls([pth,'2018',num2str(m,'%2.2u'),'*.nc']);
    [L,qq]=size(files);
    
    n=1;
        in=[pth,files(n,:)];
        day=files(n,1:8);
        lon=ncread(in,'lon');
        lat=ncread(in,'lat');       
            lon=ncread(in,'lon');
            ilon=find(lon<0); lon(ilon)=lon(ilon)+360;
            lon2(1:length(lon)-length(ilon))=lon(length(ilon)+1:end); 
            lon2(length(lon)-length(ilon)+1:length(lon))=lon(1:length(ilon));
            lon=lon2; clear lon2
        Ix=find(lon>=x1 & lon<=x2);
        Iy=find(lat>=y1 & lat<=y2);
            [xi,yi]=meshgrid(lon(Ix),lat(Iy));
        for p=1:length(Iy)-1
            Y1=yi(p,1); Y2=yi(p,1);
            X1=xi(p,1:end-1); X2=xi(p,2:end); 
            [qq,DX,qq]=ds(X1,X2,Y1,Y2);
            Y2=yi(p,1); Y1=yi(p+1,1);
            X1=xi(p,1); X2=xi(p,1);
            [qq,qq,DY]=ds(X1,X2,Y1,Y2);
            area_grid(p,:)=DX*DY;
        end
        xi=xi(1:end-1,1:end-1);
        yi=yi(2:end-1,2:end-1);
        
%         x1=160; x2=200; y1=16; y2=28;
        x1=170; x2=190; y1=18; y2=27;
        Ix=find(xi(1,:)>=x1 & xi(1,:)<=x2);
        Iy=find(yi(:,1)>=y1 & yi(:,1)<=y2);

        xi=xi(Iy,Ix); yi=yi(Iy,Ix);
        area_grid=area_grid(Iy,Ix);
        
%         pcolor(xi,yi,area_grid/1000/1000); shading flat
%         axis equal
        area_xi=xi; area_yi=yi;
%         save('pixel_area_EarthCurve_160_200_16_28','area_xi'...
%             ,'area_yi','area_grid')
        save('pixel_area_EarthCurve_170_190_18_27','area_xi'...
            ,'area_yi','area_grid')       

        toc