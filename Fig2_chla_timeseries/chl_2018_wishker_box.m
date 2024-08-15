tic,close all, clc, clear,format long g

load('chl_daily_mean_170_190_18_27_preciseA_bgc',...
    'chl_mean','err_mean','chl_all',...
    'chl_std','chl_max') ;

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
%         time2=[time2 m+([1:LL(p)]-1)/LL(p)];
        gt(length(time2)+1:length(time2)+LL(p),1)=2018*ones(LL(p),1);
        gt(length(time2)+1:length(time2)+LL(p),2)=m*ones(LL(p),1);
        gt(length(time2)+1:length(time2)+LL(p),3)=[1:LL(p)]';          
        time2=[time2 m+([1:LL(p)]-1)/LL(p)];
    end

end
L=length(time2);
for m=1:L
    q=reshape(chl_all(:,:,m),1,[]);
    Q2(m)=median(q,'omitnan');
    max_data(m)=max(q,[],'omitnan');
    min_data(m)=min(q,[],'omitnan');
    Q3(m) = quantile(q,0.75);
    Q1(m) = quantile(q,0.25);
    up=Q3(m)+1.5*(Q3(m)-Q1(m));
    dn=Q1(m)-1.5*(Q3(m)-Q1(m));
    if up<max_data(m)
        wup(m)=up;
    else
        wup(m)=max_data(m)
    end
    if dn>min_data(m)
        wdn(m)=dn;
    else
        wdn(m)=min_data(m);
    end    
end
plot(time2,Q2,'r')
hold on
plot(time2,Q3,'b')
plot(time2,Q1,'b')
plot(time2,wup,'k')
plot(time2,wdn,'k')

save('D:\on_going_proposal\running\science\on_going_paper\bloom_2018\whiskers_data_170_190_18_27_2018','time2','Q2','Q3','Q1','wup','wdn')

toc