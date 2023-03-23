
function [c, n]=Compute_CORR(t1,f1,t2,f2)

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


c=corrcoef(f1,f2);
c=c(1,2);
n=length(f1);


% /dods/matlib/rnc/rnc_regress.m
