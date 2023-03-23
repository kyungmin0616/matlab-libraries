function o=rnc_regress(forcd,varib, t1, s1);



f=getfield(forcd,varib);
[I,J,T]=size(f);

o.corr=zeros(I,J)*nan;
o.regress=o.corr*nan;

for i=1:I
for j=1:J
   tmp=sq(f(i,j,:));
   if ~isnan(tmp(1))
%   o.corr(i,j)=Compute_CORR(forcd.datenum, tmp ,t1, s1 );
   o.corr(i,j)=Compute_CORR(t1, s1, forcd.datenum, tmp );
%   o.regress(i,j)=Compute_REGRES(forcd.datenum, tmp ,t1, s1 );
    [c, n, c2]=Compute_REGRES(t1, s1, forcd.datenum, tmp );
    o.regress(i,j)=c2;
   end
end
end
% /dods/matlib/rnt/util/Compute_CORR.m
