tic,close all, clc, clear,format long g
x1=160; x2=200; y1=16; y2=28;
x1s=170; x2s=190; y1s=18; y2s=27;
% x1=121; x2=250; y1=12; y2=40; %% whole north Pacific
% load('world_map2','coast4')
p=0;
for yr=2003:2022
    yr
    pth=['W:\CMEMS\OCEANCOLOUR_GLO_BGC_L4_MY_009_104\cmems_obs-oc_glo_bgc-plankton_my_l4-multi-4km_P1M\',num2str(yr),'\'];
    files=ls([pth,'*.nc']); 
    [a,qq]=size(files);
    if a~=12, display('check'); return; end
    for m=1:12
        in=[pth,files(m,:)];
        lon=nc_varget(in,'lon');
        lat=nc_varget(in,'lat');       
        chl=nc_varget(in,'CHL');
        
        lon=nc_varget(in,'lon');
        ilon=find(lon<0); lon(ilon)=lon(ilon)+360;
        lon2(1:length(lon)-length(ilon))=lon(length(ilon)+1:end); 
        lon2(length(lon)-length(ilon)+1:length(lon))=lon(1:length(ilon));
        lon=lon2; clear lon2

        chl2(:,1:length(lon)-length(ilon))=chl(:,length(ilon)+1:end); 
        chl2(:,length(lon)-length(ilon)+1:length(lon))=chl(:,1:length(ilon)); %return
        chl=chl2; clear chl2  
        Inan=find(chl==-999); chl(Inan)=NaN;
        
        Ix=find(lon>=x1 & lon<=x2);
        Iy=find(lat>=y1 & lat<=y2);
        [xi,yi]=meshgrid(lon(Ix),lat(Iy));
                 
        p=p+1;
        chl_box1_spacemean(p)=mean(reshape(chl(Iy,Ix),1,[]),'omitnan');
        chl_box1_spacestd(p)=std(reshape(chl(Iy,Ix),1,[]),0,'omitnan');
        chl_box1_all(:,:,p)=chl(Iy,Ix);
        
        Ix2=find(lon>=x1s & lon<=x2s);
        Iy2=find(lat>=y1s & lat<=y2s);  
        chl_box2_spacemean(p)=mean(reshape(chl(Iy2,Ix2),1,[]),'omitnan');
        chl_box2_spacestd(p)=std(reshape(chl(Iy2,Ix2),1,[]),0,'omitnan');
        chl_box2_all(:,:,p)=chl(Iy2,Ix2);
        year(p)=yr;
        month(p)=m;
%         
%         pcolor(xi,yi,log10(chl(Iy,Ix))); shading flat
%         colorbar
%         axis equal
%         hold on
%         h=fillseg(coast4);
%         set(h,'edgecolor','none')
%         set(gca,'xlim',[x1 x2],'ylim',[y1 y2])        
%         return
    end
end
save('chl_box12_mondata_2003_2022','year','month',...
    'chl_box1_spacemean','chl_box1_spacestd',...
    'chl_box2_spacemean','chl_box2_spacestd','chl_box2_all','chl_box1_all')
toc