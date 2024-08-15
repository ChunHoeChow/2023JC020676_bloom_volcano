tic, clc, clear,format long g,close all,warning off

file=ls('argo*.nc');

T_lon=[];
T_lat=[];
% T_date=[];
T_id=[];

p=0; 
c = julian(1950,1,1,0,0,0);
for n=1:length(file)
    in=file(n,:);
    read_s=1; read_p=1; read_t=1;
    
    lon=ncread(in,'LONGITUDE');
    lat=ncread(in,'LATITUDE');
    juld=ncread(in,'JULD');   %return
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
    mode=ncread(in,'DATA_MODE');
    return    
    for m=1:length(juld)
        if isnan(juld(m))==0 & read_s==1 & read_t==1 & read_p==1 , 
%             [year,month,day,fday]=JDtodate_test(juld(m));  %% this is incorrect
            [gtime]=gregoria(juld(m)+c);
%             return
%             T_day=[]; T_month=[];

%             sday=sprintf('%02d',day);
%             T_day=[T_day;sday];  %% this is incorrect

%             smonth=sprintf('%02d',month);
%             T_month=[T_month;smonth];

%             year=num2str(year);
%             date=[year,T_month,T_day]; %% this is incorrect
%             date=str2num(date);
% 
%             T_date=[T_date;date]; %% this is incorrect
            
            id=str2num(in(15:21));

            T_lon=[T_lon;lon(m)];
            T_lat=[T_lat;lat(m)];
            T_id=[T_id;id];
            
            p=p+1;
            T_pres(p)={P(:,m)};
            T_pres_qc(p)={Pqc(:,m)};
            T_temp(p)={T(:,m)};
            T_temp_qc(p)={Tqc(:,m)};
            T_sal(p)={S(:,m)};
            T_sal_qc(p)={Sqc(:,m)};
            gt(p,:)=gtime;
            T_jd(p)=juld(m); %return
        end
    
    end
end
I=find(T_lon<0); T_lon(I)=T_lon(I)+360;

id_unique=unique(T_id);

p=0;
total_repeat_argo=0;
for m=1:length(id_unique)
    I=find(T_id==id_unique(m));
    time=gt(I,:);
    jd=T_jd(I);
    lon=T_lon(I);
    lat=T_lat(I);
    
    pres=T_pres(I);
    pres_qc=T_pres_qc(I);
    temp=T_temp(I);
    temp_qc=T_temp_qc(I);
    sal=T_sal(I);
    sal_qc=T_sal_qc(I);
    
    dt=sum(abs(diff(time,1)),2);
    dx=abs(diff(lon));
    dy=abs(diff(lat));
    
    Ichk=find(dt>0);
    if abs(length(Ichk)-length(dt))>0
        id_unique(m)
        total_repeat_argo=total_repeat_argo+1;
        for n=1:length(Ichk)+1
            if n==1, 
                same_ind=[1:Ichk(n)];
            elseif n==length(Ichk)+1,
                same_ind=[Ichk(n-1)+1:length(dt)+1];
            else
                same_ind=[Ichk(n-1)+1:Ichk(n)];
            end
            
            for repro=1:length(same_ind)  %% repeated profile
                z=pres{same_ind(repro)};
                z_qc=pres_qc{same_ind(repro)};
                Inan=find(z_qc~='1');
                z(Inan)=NaN;
                dz=diff(z);
                [max_dz,qq]=max(dz);
%                 if id_unique(m)==5905274 & time(Ichk(n),2)==7 & time(Ichk(n),3)==11, 
%                     display('test')
%                     return, 
%                 end
                if max_dz<500 & max(z)>50,
                    p=p+1;
                    gt_new(p,:)=time(same_ind(repro),:);
%                     if id_unique(m)==5905274, return, end
                    T_jd_new(p,:)=jd(same_ind(repro));
                    T_id_new(p,1)=id_unique(m);
                    T_lon_new(p,1)=lon(same_ind(repro));
                    T_lat_new(p,1)=lat(same_ind(repro));
                    T_pres_new(p)=pres(same_ind(repro));
                    T_pres_qc_new(p)=pres_qc(same_ind(repro));
                    T_temp_new(p)=temp(same_ind(repro));
                    T_temp_qc_new(p)=temp_qc(same_ind(repro));
                    T_sal_new(p)=sal(same_ind(repro));
                    T_sal_qc_new(p)=sal_qc(same_ind(repro)); 
                    break
                end
            end
%             if length(same_ind)==2, return, end
%             if id_unique(m)==2901545, 
%                 same_ind
%             end
        end
%         if id_unique(m)==5905274, return, end
    else
%         if id_unique(m)==5905274, return, end
        for n=1:length(I)
            p=p+1;
            gt_new(p,:)=time(n,:);
            T_jd_new(p,1)=jd(n);
            T_id_new(p,1)=id_unique(m);
            T_lon_new(p,1)=lon(n);
            T_lat_new(p,1)=lat(n);
            T_pres_new(p)=pres(n);
            T_pres_qc_new(p)=pres_qc(n);
            T_temp_new(p)=temp(n);
            T_temp_qc_new(p)=temp_qc(n);
            T_sal_new(p)=sal(n);
            T_sal_qc_new(p)=sal_qc(n);   
%             id_unique(m)
%             return
        end

    end

end
T_id=T_id_new;
T_jd=T_jd_new;
T_lon=T_lon_new;
T_lat=T_lat_new;
T_pres=T_pres_new;
T_pres_qc=T_pres_qc_new;
T_temp=T_temp_new;
T_temp_qc=T_temp_qc_new;
T_sal=T_sal_new;
T_sal_qc=T_sal_qc_new;
gt=gt_new;

length(id_unique)
total_repeat_argo

save('argo_HLCC_water_data_Feb_Sep_without_repeat_profile_ADJUSTED','T_id','T_jd','T_lon','T_lat','T_pres','T_pres_qc','T_temp','T_temp_qc','T_sal','T_sal_qc','gt') 

toc