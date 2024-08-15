tic,close all, clc, clear,format long g
load('world_map2','coast4')
x1=150; x2=210; y1=12; y2=29;

pth='Y:\SCS initial data\web\copernicus\chl_interpolated_4km_month\';
files=ls([pth,'*.nc']); return
    
for m=6:7 %% in 2018
   in=[pth,files(m-5,:)]
    lon=ncread(in,'lon');
    lat=ncread(in,'lat');       
    chl=ncread(in,'CHL');
        lon=ncread(in,'lon');
        ilon=find(lon<0); lon(ilon)=lon(ilon)+360;
        lon2(1:length(lon)-length(ilon))=lon(length(ilon)+1:end); 
        lon2(length(lon)-length(ilon)+1:length(lon))=lon(1:length(ilon));
        lon=lon2; clear lon2
        chl=chl';
        chl2(:,1:length(lon)-length(ilon))=chl(:,length(ilon)+1:end); 
        chl2(:,length(lon)-length(ilon)+1:length(lon))=chl(:,1:length(ilon)); %return
        chl=chl2; clear chl2 
        
    Ix=find(lon>=x1 & lon<=x2);
    Iy=find(lat>=y1 & lat<=y2);
    [cx,cy]=meshgrid(lon(Ix),lat(Iy));

    chl=chl(Iy,Ix);        

    subplot(2,1,m-5)
    pcolor(cx,cy,log10(chl)); shading flat
         caxis([-1.6 -0.4])
%         colormap winter
        hold on
        axis equal
        contour(cx,cy,chl,[0.1 0.1],'linecolor','k')
%         plot(xi(Ibig),yi(Ibig),'.k');
        
        yt=[-1.6:0.2:-0.4];
        h=colorbar('ytick',yt,'yticklabel',...
            {num2str(10.^yt','%4.2f')});
%             [num2str(10.^yt(1),'%4.3f');num2str(10.^yt(2),'%4.3f');num2str(10.^yt(3),'%4.3f');num2str(10.^yt(4),'%4.3f')])
        title(h,'mg/m^3')
        plot(360-158,22.75,'^r','markersize',10,'linewidth',2)        
        h=fillseg(coast4);
        set(h,'edgecolor','k')
        set(gca,'xlim',[x1 x2],'ylim',[y1 y2],'fontsize',18,'fontweight','bold','TickDir','out','linewidth',2,'xtick',[x1:10:x2],'ytick',[4:4:36])
    chl_all(:,:,m-5)=chl;
end          
save('high_chl_bloom_JJ_nocloud','cx','cy','chl_all')
toc