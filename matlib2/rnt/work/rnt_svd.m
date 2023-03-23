function [EOF1, EOF2, PC1, PC2, VEXP] = rnt_svd(t1, f1, mask1, t2, f2, mask2, varargin)

mint=max( [ min(t1(:)) min(t2(:))] );
maxt=min( [ max(t1(:)) max(t2(:))] );


istr1=find(t1 == mint);
istr2=find(t2 == mint);

iend1=find(t1 == maxt);
iend2=find(t2 == maxt);

f1=f1(:,:,istr1:iend1);
f2=f2(:,:,istr2:iend2);



x=ConvertXYT_into_ZT(f1,mask1);
y=ConvertXYT_into_ZT(f2,mask2);

Cxy=x*y';
[U,S,V] = svd(Cxy);

PC1=(U'*x)';
PC2=(V'*y)';

VEXP=diag(S)/sum(diag(S))*100;

EOF1=ConvertZT_into_XYT(U,mask1);
EOF2=ConvertZT_into_XYT(V,mask2);

return
