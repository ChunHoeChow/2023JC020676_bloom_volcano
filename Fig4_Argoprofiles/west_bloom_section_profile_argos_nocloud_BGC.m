tic, clc, clear,format long g,close all, warning off
% id=[5903806, 2902604, 5903805, 5904056, 5902509, 5903804, 5902511, 5905219, 5905274];
% id=[5903806, 5903805, 5904056, 5902509, 5903804, 5902511, 5905219, 5905274];
id=[5903806, 5903805, 5904056, 5902509, 5903804, 5902511, 5905219];
dwant=250;
mon=[7 7; 7 7; 7 8];
day=[8 14; 18 24; 28 3];
% mon=[7 7; 7 7; 7 8];
% day=[1 7; 18 24; 28 3];
f_width=30; f_height=20; mar_w=[2 2]; mar_h=[1 2]; gap=[1.5 1.5];
[ax]=mysubplot_nomap(3,3,gap,f_height,f_width,mar_h,mar_w);
set(figure,'units','centimeter','position',[0.1 1 f_width f_height],'visible','on',...
    'PaperPositionMode', 'manual', 'PaperUnits', 'centimeter', 'PaperPosition', [0 0 f_width f_height]); 
lab=['abcdefghij'];
p=0;

for TIME=1:3
t1=mon(TIME,1)+day(TIME,1)/31;
t2=mon(TIME,2)+day(TIME,2)/31;


clear lon lat temp salt pden lon_high_chl
for m=1:length(id)
    in=['argo_',num2str(id(m)),'_profile_dataplot_nocloud_ADJUSTED_BGC'];
    load(in,'time_all','jd_all','time_all_year','dep_all','temp_all','pden_all','argo_chl_all','lon_all','lat_all','salt_all')  
    I=find(time_all(1,:)>=t1 & time_all(1,:)<=t2);
    if length(I)~=1,
        display('Check length of I')
        return
    end
    Idep=find(dep_all(:,1)<dwant);
    
    lon(m)=lon_all(I);
    lat(m)=lat_all(I);
    
    temp(:,m)=temp_all(Idep,I);
    pden(:,m)=pden_all(Idep,I);
    salt(:,m)=salt_all(Idep,I);
    argo_chl(m)=argo_chl_all(I);
    
    I2=find(argo_chl_all(I)>0.1);
    if length(I2)>0,
        lon_high_chl(m)=lon_all(I(I2));
    else
        lon_high_chl(m)=NaN;
    end
end
% return
[LATi,qq]=meshgrid(lat,dep_all(Idep,1));
[xi,yi]=meshgrid(lon,dep_all(Idep,1));

axes('units','centimeters','position',ax(TIME,:));
contourf(xi,yi,temp,[1:1:32],'linecolor','none')
caxis([14 30])
colormap jet
hold on
% 
plot(xi,yi,'.','color',[1 1 1]*.5)
[C,h]=contour(xi,yi,pden-1000,[1:0.5:32],'linecolor','k');
clabel(C,h,'fontsize',16)
% I=find(argo_chl_all>0.1);
% plot(time_all(1,I),dep_all(1,I),'ok','markerfacecolor','k')
% %         plot(time_all,dep_all,'.k')
plot(lon_high_chl,ones(size(lon_high_chl)),'ok','markerfacecolor','k')
set(gca,'ylim',[0 dwant],'ydir','reverse')
% set(gca,'xlim',[6 10])
set(gca,'fontsize',16,'tickdir','out')
title(['2018/',num2str(mon(TIME,1),'%2.2u'),'/',num2str(day(TIME,1),'%2.2u'),...
    '~',num2str(mon(TIME,2),'%2.2u'),'/',num2str(day(TIME,2),'%2.2u')])
p=p+1;
text(175,170,['(',lab(p),')'],'backgroundcolor','w','fontsize',12)
if TIME==1, 
    ylabel('Depth (m)')
end
        if TIME==3,
            ax1=axes('position',[(ax(TIME,1)+ax(TIME,3)+0.3)/f_width ax(TIME,2)/f_height 0.01 (1*[1*ax(TIME,4)])/f_height]);
            xc_bar=[1 2 3];
            yc_bar=[14:1:30];
            [xc_bar,yc_bar]=meshgrid(xc_bar,yc_bar);
            pcolor(xc_bar,yc_bar,yc_bar)
            colormap(ax1,'jet')
            shading flat, %freezeColors
            caxis([14 30])
            set(gca,'layer','top','xtick',[],'ytick',[14:2:30],'yaxislocation','right','ylim',[14 30],'fontsize',12)
            text(1,31,'^oC','fontsize',12)  
        end
        
        
axes('units','centimeters','position',ax(TIME+3,:));
contourf(xi,yi,salt,[33:0.05:37],'linecolor','none')
caxis([34.5 35.5])
colormap jet
hold on
% 
% plot(xi,yi,'.','color',[1 1 1]*.5)
% [C,h]=contour(xi,yi,pden-1000,[1:0.5:32],'linecolor','k');
% clabel(C,h,'fontsize',16)
% I=find(argo_chl_all>0.1);
% plot(time_all(1,I),dep_all(1,I),'ok','markerfacecolor','k')
% %         plot(time_all,dep_all,'.k')
set(gca,'ylim',[0 dwant],'ydir','reverse')
% set(gca,'xlim',[6 10])
set(gca,'fontsize',16,'tickdir','out')
p=p+1;
text(175,170,['(',lab(p),')'],'backgroundcolor','w','fontsize',12)
if TIME==1, 
    ylabel('Depth (m)')
end
        if TIME==3,
            ax1=axes('position',[(ax(TIME+3,1)+ax(TIME+3,3)+0.3)/f_width ax(TIME+3,2)/f_height 0.01 (1*[1*ax(TIME+3,4)])/f_height]);
            xc_bar=[1 2 3];
            yc_bar=[33:0.05:37];
            [xc_bar,yc_bar]=meshgrid(xc_bar,yc_bar);
            pcolor(xc_bar,yc_bar,yc_bar)
            colormap(ax1,'jet')
            shading flat, %freezeColors
            caxis([34.5 35.5])
            set(gca,'layer','top','xtick',[],'ytick',[33:0.2:37],'yaxislocation','right','ylim',[34.5 35.5],'fontsize',12)
            text(1,35.55,'ppt','fontsize',12)  
        end    

axes('units','centimeters','position',ax(TIME+6,:));
        [mm,nn] = size(pden);
        iup   = 1:mm-1;
        ilo   = 2:mm;

        pden_up = pden(iup,:);
        pden_lo = pden(ilo,:);
        dep_up = yi(iup,:);
        dep_lo = yi(ilo,:);

        mid_pden = (pden_up + pden_lo )/2;
        mid_dep = (dep_up+dep_lo)/2;
        dif_pden = pden_up - pden_lo;
        dif_z    = dep_up - dep_lo;
        n2       = 9.8 * dif_pden ./ (dif_z .* mid_pden);
        contourf(xi(1:end-1,:),mid_dep,n2,[-2:0.05:3]*10^-3,'linecolor','none')
        caxis([0 1.0]*10^-3)
        hold on
        contour(xi(1:end-1,:),mid_dep,n2,[0 0],'linecolor','w')    
set(gca,'ylim',[0 dwant],'ydir','reverse')

% set(gca,'xlim',[6 10])
set(gca,'fontsize',16,'tickdir','out') 
xlabel('Longitude (^oE)')
p=p+1;
text(175,170,['(',lab(p),')'],'backgroundcolor','w','fontsize',12)
if TIME==1, 
    ylabel('Depth (m)')
    save('0708_0714_n2_data_ADJUSTED_BGC','xi','yi','LATi','mid_dep','n2','argo_chl','pden');
end
if TIME==3,
    save('0728_0803_n2_data_ADJUSTED_BGC','xi','yi','LATi','mid_dep','n2','argo_chl','pden');
    ax1=axes('position',[(ax(TIME+6,1)+ax(TIME+6,3)+0.3)/f_width ax(TIME+6,2)/f_height 0.01 (1*[1*ax(TIME+6,4)])/f_height]);
    xc_bar=[1 2 3];
    yc_bar=[0:0.1:1]*10^-3;
    [xc_bar,yc_bar]=meshgrid(xc_bar,yc_bar);
    pcolor(xc_bar,yc_bar,yc_bar)
    colormap(ax1,'jet')
    shading flat, %freezeColors
    caxis([0 1]*10^-3)
    set(gca,'layer','top','xtick',[],'ytick',[0:0.2:1]*10^-3,'yaxislocation','right','ylim',[0 1]*10^-3,'fontsize',12)
    text(1,1.08*10^-3,'s^-^2','fontsize',12)  
end     

% return
end
% saveas(gcf,'west_bloom_stratification_nochl','png')
toc