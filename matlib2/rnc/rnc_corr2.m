function o=rnc_corr(t2,s2, t1, s1, dt);



[I,J,T]=size(s2);

o.corr=zeros(I,J)*nan;
o.regress=o.corr*nan;
o.r1=o.corr*nan;
o.r2=o.corr*nan;

for i=1:I
for j=1:J
   tmp=sq(s2(i,j,:));
   if ~isnan(tmp(1))
   [c12,r1, r2]=correlation(t1, s1, t2, tmp , dt);
   o.corr(i,j)=c12;
   o.r1(i,j)=r1;
   o.r2(i,j)=r2;

   end
end
end


