tic, clc, clear,format long g,close all, warning off
id=[5905060, 5905059, 5905048];
f_width=35; f_height=20; mar_w=[2 2]; mar_h=[1 2]; gap=[1.5 1.5];
[ax]=mysubplot_nomap(3,3,gap,f_height,f_width,mar_h,mar_w);
set(figure,'units','centimeter','position',[0.1 1 f_width f_height],'visible','on',...
    'PaperPositionMode', 'manual', 'PaperUnits', 'centimeter', 'PaperPosition', [0 0 f_width f_height]); 
lab=['abcdefghij'];
p=0;  
for m=2:3
    in=['argo_',num2str(id(m)),'_profile_dataplot_nocloud_ADJUSTED2023'];
    load(in,'time_all','time_gt','jd_all','time_all_year','dep_all','temp_all','pden_all','argo_chl_all','lon_all','lat_all','salt_all')
    p=p+1; 
    axes('units','centimeters','position',ax(m,:));
        contourf(time_all,dep_all,temp_all,[1:1:32],'linecolor','none')
        caxis([14 30])
        colormap jet
        % colorbar 
        hold on
        % clabel(C,h)
        plot(time_all,dep_all,'.','color',[1 1 1]*.5)
        [C,h]=contour(time_all,dep_all,pden_all-1000,[1:0.5:32],'linecolor','k');
        clabel(C,h,'fontsize',16)
        I=find(argo_chl_all>0.1);
        plot(time_all(1,I),dep_all(1,I),'ok','markerfacecolor','k')
%         plot(time_all,dep_all,'.k')
        set(gca,'ylim',[0 200],'ydir','reverse')
        set(gca,'xlim',[6 10])
        set(gca,'fontsize',16,'tickdir','out')
        if m==1, ylabel('Depth (m)'), end
        title(num2str(id(m)))
        text(6.5,170,['(',lab(p),')'],'backgroundcolor','w','fontsize',12)
        
        if m==3,
            
            ax1=axes('position',[(ax(m,1)+ax(m,3)+0.3)/f_width ax(m,2)/f_height 0.01 (1*[1*ax(m,4)])/f_height]);
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
    
    p=p+1;   
    axes('units','centimeters','position',ax(m+3,:));        
    contourf(time_all(:,1:2:end), dep_all(:,1:2:end), salt_all(:,1:2:end),[33:0.05:37],'linecolor','none')
    caxis([34.5 35.5])
        hold on
        
        
        set(gca,'ylim',[0 200],'ydir','reverse')
        set(gca,'xlim',[6 10])
        set(gca,'fontsize',16,'tickdir','out')
        if m==1, ylabel('Depth (m)'), end     
        
%         if m==3, xlabel('Time (Calendar month)'), end 
%         xlabel('Time (Calendar month)')
        text(6.5,170,['(',lab(p),')'],'backgroundcolor','w','fontsize',12)
        
        if m==3,
            ax1=axes('position',[(ax(m+3,1)+ax(m+3,3)+0.3)/f_width ax(m+3,2)/f_height 0.01 (1*[1*ax(m+3,4)])/f_height]);
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
        
    p=p+1;   
    axes('units','centimeters','position',ax(m+6,:));        
        [mm,nn] = size(pden_all);
        iup   = 1:mm-1;
        ilo   = 2:mm;

        pden_up = pden_all(iup,:);
        pden_lo = pden_all(ilo,:);
        dep_up = dep_all(iup,:);
        dep_lo = dep_all(ilo,:);

        mid_pden = (pden_up + pden_lo )/2;
        mid_dep = (dep_up+dep_lo)/2;
        dif_pden = pden_up - pden_lo;
        dif_z    = dep_up - dep_lo;
        n2       = 9.8 * dif_pden ./ (dif_z .* mid_pden);

        contourf(time_all(1:end-1,:),mid_dep,n2,[-2:0.05:3]*10^-3,'linecolor','none')
        caxis([0 1.0]*10^-3)
        hold on
        contour(time_all(1:end-1,:),mid_dep,n2,[0 0],'linecolor','w')
        
        
        set(gca,'ylim',[0 200],'ydir','reverse')
        set(gca,'xlim',[6 10])
        set(gca,'fontsize',16,'tickdir','out')
        if m==1, 
            ylabel('Depth (m)'), 
            save('Argo5905060_n2_data_ADJUSTED_BGC','time_all','dep_all',...
                'mid_dep','n2','argo_chl_all','pden_all');
        end     
        if m==2, 
            save('Argo5905059_n2_data_ADJUSTED2023_BGC','time_all','dep_all',...
                'mid_dep','n2','argo_chl_all','pden_all','time_gt');
        end        
%         if m==3, xlabel('Time (Calendar month)'), end 
        xlabel('Time (Calendar month)')
        text(6.5,170,['(',lab(p),')'],'backgroundcolor','w','fontsize',12)
        
        if m==3,
            save('Argo5905048_n2_data_ADJUSTED2023_BGC','time_all','dep_all',...
                'mid_dep','n2','argo_chl_all','pden_all','time_gt');
            ax1=axes('position',[(ax(m+6,1)+ax(m+6,3)+0.3)/f_width ax(m+6,2)/f_height 0.01 (1*[1*ax(m+6,4)])/f_height]);
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
%         for n=1:length(time_all(1,:))
%             D=mid_dep(:,n);
%             N2=n2(:,n);
%             Idep=find(D<70 & N2<0);
%             if length(Idep)>0
%                 [min_n2(n),imin]=min(N2(Idep));
%                 min_dep(n)=D(imin);
%             else
%                 min_n2(n)=NaN;
%                 min_dep(n)=NaN;
%             end
%         end
%         
%         plot(time_all(1:end-1,:),min_dep','*','color',[1 1 1]*1)
%         clear min_dep min_n2
%     return
end
% saveas(gcf,'west_bloom_3argo_profiles_nocloud','png')
toc