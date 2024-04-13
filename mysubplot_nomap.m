function [ax]=mysubplot_nomap(Nh,Nw,gap,f_height,f_width,mar_h,mar_w)

width=(f_width-sum(mar_w)-gap(2)*(Nw-1))/Nw;  
height=(f_height-sum(mar_h)-gap(1)*(Nh-1))/Nh;
p=0;
for m=1:Nh
    for n=1:Nw
        p=p+1;
        ax(p,:)=[mar_w(1)+gap(2)*(n-1)+width*(n-1) f_height-mar_h(1)-gap(1)*(m-1)-height*m width height];
    end
end
% ax(:,[1 3])=ax(:,[1 3])/f_width;
% ax(:,[2 4])=ax(:,[2 4])/f_height;