tic,close all, clc, clear,format long g

load('Z:\STCC\Chla\merged_data\chl_daily_mean_170_190_18_27_preciseA_bgc',...
    'chl_mean','err_mean','chl_std','chl_max',...
    'area01','area02','area03','area04') ;
% load('Z:\STCC\Chla\merged_data\chl_daily_mean_160_200_16_28_preciseA_bgc',...
%     'area01','area02','area03','area04')
load('Z:\STCC\Chla\merged_data\rain_daily_mean_160_200_16_28','rain_mean')
load('Z:\STCC\Chla\merged_data\aot_daily_mean_160_200_16_28','aot_mean')

LL=[31,30,31,31];
p=0;
for m=5:8
    p=p+1;
    if p==1, 
        time2=m+([1:LL(p)]-1)/LL(p);
        gt(:,1)=2018*ones(LL(p),1);
        gt(:,2)=m*ones(LL(p),1);
        gt(:,3)=[1:LL(p)]';        
    else
        gt(length(time2)+1:length(time2)+LL(p),1)=2018*ones(LL(p),1);
        gt(length(time2)+1:length(time2)+LL(p),2)=m*ones(LL(p),1);
        gt(length(time2)+1:length(time2)+LL(p),3)=[1:LL(p)]';          
        time2=[time2 m+([1:LL(p)]-1)/LL(p)];
    end
end
x=time2;
save('Fig2_data','x','aot_mean','rain_mean','chl_mean','area04','gt',...
    'area01','chl_std')


toc