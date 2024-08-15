tic, clc, clear,format long g,close all,warning off

file=ls('5904093_20201109063648419.nc');

T_lon=[];
T_lat=[];
T_date=[];
T_id=[];

p=0;
c = julian(1950,1,1,0,0,0);
for n=1:1 %length(file)
    in=file;
    read_s=1; read_p=1; read_t=1; read_d=1;
    
    lon=ncread(in,'LONGITUDE');
    lat=ncread(in,'LATITUDE');
    juld=ncread(in,'JULD'); 
    loc_qc=ncread(in,'POSITION_QC');
    float_num=ncread(in,'FLOAT_SERIAL_NO'); 

    try
        P=ncread(in,'PRES_ADJUSTED');  
        Pqc=ncread(in,'PRES_ADJUSTED_QC');  
    catch
        read_p=0
        in
    end
        
    try
        T=ncread(in,'TEMP_ADJUSTED');  
        Tqc=ncread(in,'TEMP_ADJUSTED_QC');  
    catch
        read_t=0
        in
    end
    try 
        S=ncread(in,'PSAL_ADJUSTED');  
        Sqc=ncread(in,'PSAL_ADJUSTED_QC');      
    catch 
        read_s=0
        in
    end
    
    try 
        D=ncread(in,'DOXY_ADJUSTED');  
        Dqc=ncread(in,'DOXY_ADJUSTED_QC');      
    catch 
        read_d=0
        in
    end
    mode=ncread(in,'DATA_MODE');
    return
    for m=1:length(juld)
        if isnan(juld(m))==0 & read_d==1 & read_p==1 , 
%             [year,month,day,fday]=JDtodate_test(juld(m));  %% this is incorrect
            [gtime]=gregoria(juld(m)+c);
%             return
            T_day=[]; T_month=[];

%             sday=sprintf('%02d',day);
%             T_day=[T_day;sday];  %% this is incorrect

%             smonth=sprintf('%02d',month);
%             T_month=[T_month;smonth];

%             year=num2str(year);
%             date=[year,T_month,T_day]; %% this is incorrect
%             date=str2num(date);
% 
%             T_date=[T_date;date]; %% this is incorrect
            
            id=str2num(in(1:7));

            T_lon=[T_lon;lon(m)];
            T_lat=[T_lat;lat(m)];
            T_id=[T_id;id];
            
            p=p+1;
            T_pres(p)={P(:,m)};
            T_pres_qc(p)={Pqc(:,m)};
            T_do(p)={D(:,m)};
            T_do_qc(p)={Dqc(:,m)};
            T_sal(p)={S(:,m)};
            T_sal_qc(p)={Sqc(:,m)};
            T_temp(p)={T(:,m)};
            T_temp_qc(p)={Tqc(:,m)};            
            gt(p,:)=gtime;
        end
    
    end
%     return
end
% I=find(T_lon<0); T_lon(I)=T_lon(I)+360;
save('bio_argo_5904093_data_adjusted_all','T_id','T_lon','T_lat','T_pres','T_pres_qc',...
    'T_do','T_do_qc','T_sal','T_sal_qc','T_temp','T_temp_qc','gt','loc_qc') 

toc