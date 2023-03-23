function o=rnc_corr(forcd,varib, t1, s1, dt);



f=getfield(forcd,varib);
[I,J,T]=size(f);

o.corr=zeros(I,J)*nan;
o.regress=o.corr*nan;

for i=1:I
for j=1:J
   tmp=sq(f(i,j,:));
   if ~isnan(tmp(1))
   [c12,r1, r2]=correlation(t1, s1, forcd.datenum, tmp , dt);
   o.corr(i,j)=c12;
   o.r1(i,j)=r1;
   o.r2(i,j)=r2;

   end
end
end


