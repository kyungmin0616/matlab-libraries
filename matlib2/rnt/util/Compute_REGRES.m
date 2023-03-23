
function [c, n, c2]=Compute_REGRES(t1,f1,t2,f2)


mint=max( [ min(t1) min(t2)] );
maxt=min( [ max(t1) max(t2)] );

istr1=find(t1 == mint);
istr2=find(t2 == mint);

iend1=find(t1 == maxt);
iend2=find(t2 == maxt);

f1=f1(istr1:iend1);
f2=f2(istr2:iend2);

in=find(~isnan(f1));
f1=f1(in);
f2=f2(in);

in=find(~isnan(f2));
f1=f1(in);
f2=f2(in);


c=sum(f1.*f2)/sum(f2.*f2)* std(f2);
c2=sum(f1.*f2)/sum(f1.*f1)* std(f1);

n=length(f1);
