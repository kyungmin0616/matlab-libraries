function [EOF1, EOF2, PC, TIME, VEXP, norm_x, norm_y]=rnt_combinedEOF(t1, f1, mask1, t2, f2, mask2, varargin);

mint=max( [ min(t1(:)) min(t2(:))] );
maxt=min( [ max(t1(:)) max(t2(:))] );


istr1=find(t1 == mint);
istr2=find(t2 == mint);

iend1=find(t1 == maxt);
iend2=find(t2 == maxt);

f1=f1(:,:,istr1:iend1);
f2=f2(:,:,istr2:iend2);

TIME=t1(istr1:iend1);

x=ConvertXYT_into_ZT(f1,mask1);
y=ConvertXYT_into_ZT(f2,mask2);

len1=length(x(:,1));
len2=length(y(:,1));

Cxx=(x*x')/len1;
Cyy=(y*y')/len2;

norm_x=mean(sqrt(diag(Cxx)))
norm_y=mean(sqrt(diag(Cyy)))


z=[x/norm_x ;y/norm_y ];

Czz=z*z';
[U,S,V] = svd(Czz);

PC=(U'*z)';


VEXP=diag(S)/sum(diag(S))*100;


EOF1=ConvertZT_into_XYT(U(1:len1,:),mask1);
EOF2=ConvertZT_into_XYT(U(len1+1:end,:),mask2);



return
N=10;
PC=PC(:,1:N);

for n=1:10
   EOF1(:,n)=EOF1(:,n)*std(PC(:,n))*norm_x;
   EOF2(:,n)=EOF2(:,n)*std(PC(:,n))*norm_y;
   PC(:,n)=PC(:,n)/std(PC(:,n));
end
   
   


