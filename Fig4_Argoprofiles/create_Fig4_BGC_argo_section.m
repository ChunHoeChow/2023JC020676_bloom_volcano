tic,close all, clc, clear,format long g

load('Z:\STCC\Chla\merged_data\GSM\daily\0708_0714_n2_data_ADJUSTED_BGC','xi','yi',...
    'mid_dep','n2','argo_chl','pden','LATi')
xi_sec0708=xi(1:end-1,:);
yi_sec0708=LATi(1:end-1,:); return
zi_sec0708=mid_dep;
n2_sec0708=n2;

R_sec0708R=pden-1000;
xi_sec0708R=xi;
yi_sec0708R=LATi;
zi_sec0708R=yi;

Argo_secCHL0708=argo_chl;

load('Z:\STCC\Chla\merged_data\GSM\daily\0728_0803_n2_data_ADJUSTED_BGC',...
    'xi','yi','mid_dep','n2','argo_chl','pden','LATi')
xi_sec0728=xi(1:end-1,:);
yi_sec0728=LATi(1:end-1,:);
zi_sec0728=mid_dep;
n2_sec0728=n2; 

R_sec0728R=pden-1000;
xi_sec0728R=xi;
yi_sec0728R=LATi;
zi_sec0728R=yi;

Argo_secCHL0728=argo_chl;

load('Z:\STCC\Chla\merged_data\high_chl_bloom_JJ_nocloud_BGC','cx','cy','chl_all')
chl_mean=mean(chl_all(:,:,2),3,'omitnan');

load('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\DATA_CTD_ARGO_XBT\argo_HLCC_water_data_Feb_Sep_without_repeat_profile_ADJUSTED.mat','T_id','T_lon','T_lat','T_pres','T_pres_qc','T_temp','T_temp_qc','T_sal','T_sal_qc','gt') 
date_num=str2num([num2str(gt(:,1)),num2str(gt(:,2),'%2.2u'),num2str(gt(:,3),'%2.2u')]); 
argo_want=[5905059, 5905048]; % super high resolution Argo
% argo_want2=[5903806, 5903805, 5904056, 5902509, 5903804, 5902511, 5905219, 5905274];
argo_want2=[5903806, 5903805, 5904056, 5902509, 5903804, 5902511, 5905219, 5905274];
argo_want3=[5904485, 5904093]; % bio-Argo
date1=20180708;
date2=20180714;
I_in=find(date_num>=date1 & date_num<=date2 & T_lon>=160 & T_lon<=220);
lab2=T_id(I_in); %return
lab2_x=T_lon(I_in);
lab2_y=T_lat(I_in);

[C,ia,ib] = intersect(argo_want2,lab2); %return
[xx,ii]=sort(lab2_x(ib));
yy=lab2_y(ib(ii));

Argo_secID=argo_want2(ia);

[C,ia,ib] = intersect(argo_want3,lab2);
Argo_bioX=lab2_x(ib);
Argo_bioY=lab2_y(ib);
Argo_bioID=argo_want3(ia);

[C,ia,ib] = intersect(argo_want,lab2);
Argo_hresX=lab2_x(ib);
Argo_hresY=lab2_y(ib);
Argo_hresID=argo_want(ia);


load('2018_section_T_dens_N2_170_190','xi2','yi2','pgrad_sec','T_sec','N2_sec','rho_sec')
xi_sec=xi2;
zi_sec=yi2;

load('Z:\STCC\Chla\merged_data\GSM\daily\Argo5905059_n2_data_ADJUSTED2023_BGC',...
    'time_all','mid_dep','n2','argo_chl_all','pden_all','dep_all','time_gt')
mid_time_5905059=time_all(1:end-1,:);
mid_dep_5905059=mid_dep;
n2_5905059=n2;
time_all_5905059=time_all;
time_gt_5905059=time_gt;
dep_all_5905059=dep_all;
pden_all_5905059=pden_all;
chl_all_5905059=argo_chl_all;

load('Z:\STCC\Chla\merged_data\GSM\daily\Argo5905048_n2_data_ADJUSTED2023_BGC',...
    'time_all','mid_dep','n2','argo_chl_all','pden_all','dep_all','time_gt')
mid_time_5905048=time_all(1:end-1,:);
mid_dep_5905048=mid_dep;
n2_5905048=n2;
time_all_5905048=time_all;
time_gt_5905048=time_gt;  
dep_all_5905048=dep_all;
pden_all_5905048=pden_all;
chl_all_5905048=argo_chl_all;

Argo_secX=xx;
Argo_secY=yy;
save('Fig4_data_BGC','cx','cy','chl_mean','Argo_secX','Argo_secY','Argo_secID',...
    'Argo_bioX','Argo_bioY','Argo_bioID','Argo_hresX','Argo_hresY','Argo_hresID',...
    'xi_sec','zi_sec','pgrad_sec','N2_sec','rho_sec',...
    'mid_time_5905059','mid_dep_5905059','n2_5905059','time_gt_5905059',...
    'time_all_5905059','dep_all_5905059','pden_all_5905059','chl_all_5905059',...
    'mid_time_5905048','mid_dep_5905048','n2_5905048','time_gt_5905048',...
    'time_all_5905048','dep_all_5905048','pden_all_5905048','chl_all_5905048',...
    'xi_sec0708','yi_sec0708','zi_sec0708','n2_sec0708',...
    'R_sec0708R','xi_sec0708R','yi_sec0708R','zi_sec0708R','Argo_secCHL0708',...
    'xi_sec0728','yi_sec0728','zi_sec0728','n2_sec0728',...
    'R_sec0728R','xi_sec0728R','yi_sec0728R','zi_sec0728R','Argo_secCHL0728')


% load('Z:\STCC\Chla\merged_data\GSM\daily\satO2_data_ALOHA_5904093_5904485_b_allJJ',...
%     'satO2_5904093','dep_5904093',...
%     'satO2_5904485','dep_5904485','satO2_ALOHA_06','dep_ALOHA_06',...
%     'satO2_ALOHA_07','dep_ALOHA_07','do_point_z',...
%     'satO2_clim180_June','satO2_clim180_July')
% 
% save('Fig7_data_allJJ','satO2_5904093','dep_5904093','satO2_5904485','dep_5904485',...
%     'satO2_ALOHA_06','dep_ALOHA_06','satO2_ALOHA_07','dep_ALOHA_07',...
%     'satO2_clim180_June','satO2_clim180_July','do_point_z')

toc